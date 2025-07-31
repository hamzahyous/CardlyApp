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
                            ManualCardEntryView()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(filteredResults, id: \.id) { card in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(card.name).font(.headline)
                                Text("\(card.issuer) • \(card.network) • \(card.tier)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            if selectedCardID == card.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedCardID = (selectedCardID == card.id) ? nil : card.id
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Bottom bar
            HStack(spacing: 12) {
                NavigationLink(destination: ManualCardEntryView()) {
                    Text("Enter Manually")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                if selectedCardID != nil {
                    Button("Confirm") {
                        confirmSelection()
                        navigateToFiltered = false
                        showScanner = false
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
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

// Chase Sapphire Rewards: 4147201234567890
// Improper: 4847201234567890

