import SwiftUI

struct FilteredAllCardsView: View {
    let bin: String
    var binMetadata: (scheme: String, tier: String, issuer: String)? = nil
    let last4: String
    @Binding var showScanner: Bool
    @Binding var navigateToFiltered: Bool

    
    
    @State private var searchText: String = ""
    @State private var allCards: [AllCardResponse] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    @State private var selectedCardID: UUID? = nil


    var body: some View {
        VStack(spacing: 0) {
            // Main content section
            VStack(spacing: 0) {
                // Metadata
                if let meta = binMetadata {
                    Text("Detected: \(meta.issuer) • \(meta.scheme) • \(meta.tier)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGroupedBackground))
                }
                
                // Content logic
                if isLoading {
                    ProgressView("Loading cards...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if filteredResults.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "creditcard")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 60)
                            .foregroundColor(.gray)
                        Text("No cards found for BIN \(bin)")
                            .foregroundColor(.gray)
                        NavigationLink("Enter Manually") {
                            ManualCardEntryView(
                                prefilledIssuer: binMetadata?.issuer,
                                prefilledNetwork: binMetadata?.scheme,
                                last4: last4,
                                bin: bin,
                                showScanner: $showScanner,
                                navigateToFiltered: $navigateToFiltered
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(filteredResults, id: \.id) { card in
                        ExpandedAllCardCell(card: card)
                            .scaleEffect(selectedCardID == card.id ? 1.03 : 1.0)
                            .shadow(color: selectedCardID == card.id ? .black.opacity(0.3) : .clear,
                                    radius: 8, x: 0, y: 5)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedCardID)
                            .padding(.vertical, 6)
                        .contentShape(Rectangle()) // makes the whole card tappable
                        .onTapGesture {
                            selectedCardID = (selectedCardID == card.id) ? nil : card.id
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)         // Remove default List background
                    .background(Color(.systemGroupedBackground))

                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // Bottom bar
            HStack(spacing: 12) {
                // 🔹 Enter Manually (always visible)
                NavigationLink(destination:
                                ManualCardEntryView(
                                    prefilledIssuer: binMetadata?.issuer,
                                    prefilledNetwork: binMetadata?.scheme,
                                    last4: last4,
                                    bin: bin,
                                    showScanner: $showScanner,
                                    navigateToFiltered: $navigateToFiltered
                                )) {
                    Text("Enter Manually")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black.opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // 🔹 Confirm (always visible but styled based on state)
                Button("Confirm") {
                    confirmSelection()
                    navigateToFiltered = false
                    showScanner = false
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(selectedCardID == nil ? Color.gray.opacity(0.2) : Color.blue)
                .foregroundColor(selectedCardID == nil ? .gray : .white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: selectedCardID == nil ? .clear : .blue.opacity(0.3), radius: 4)
                .disabled(selectedCardID == nil) // disable when no card selected
                .animation(.easeInOut(duration: 0.2), value: selectedCardID)
            }
            .padding()
            .background(.ultraThinMaterial) // ✅ nicer than plain gray
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(radius: 2)

            .padding()
            .background(Color(.systemGroupedBackground))

        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Select Your Card")
        .onAppear(perform: loadAllCards)
    }

    
    
    // CALM LIL HELPER METHODS
    
    private var filteredResults: [AllCardResponse] {
        allCards.filter { card in
            card.binPrefixes.contains { bin.hasPrefix($0) }
        }
    }
    
    // Networking
    private func loadAllCards() {
        isLoading = true
        errorMessage = nil
        
        CardService.shared.fetchAllCards { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let cards):
                    self.allCards = cards // raw list, filtering happens in computed var
                case .failure(let error):
                    self.errorMessage = "Failed to load cards: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func confirmSelection() {
        guard let selectedID = selectedCardID else { return }
        let request = CreateUserCardRequest(allCardId: selectedID, last4: last4)

        CardService.shared.addUserCard(request) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    // Immediately re-fetch to ensure the backend returns the new list
                    CardService.shared.fetchUserCards { fetchResult in
                        DispatchQueue.main.async {
                            switch fetchResult {
                            case .success(let updatedCards):
                                // Update view model manually if accessible, or just notify
                                NotificationCenter.default.post(name: .didAddCard, object: updatedCards)
                            case .failure(let error):
                                print("Refresh failed: \(error.localizedDescription)")
                            }
                        }
                    }
                case .failure(let error):
                    print("Save failed: \(error)")
                }
            }
        }
    }
}

#Preview {
    FilteredAllCardsView(
        bin: "414720",
        binMetadata: nil,
        last4: "4465",
        showScanner: .constant(true),
        navigateToFiltered: .constant(true)
    )
}

// Chase Sapphire Rewards: 4147201234567898
// Improper (Test) : 4847201234567890

