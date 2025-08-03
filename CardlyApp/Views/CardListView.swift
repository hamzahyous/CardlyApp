import SwiftUI

struct CardListView: View {
    @StateObject private var viewModel = UserCardsViewModel()
    
    // alert state
    @State private var showingDeleteConfirm = false
    @State private var selectedCardToDelete: UserCardResponse?
    @State private var showScanner = false


    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                // Header
                HStack {
                    Text("My Cards")
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                    
                    // Navigate to scanner
                    NavigationLink(isActive: $showScanner) {
                        CardScannerView(showScanner: $showScanner)
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.primary)
                    }

                    
                    // Menu
                    Menu {
                        Button("Settings", action: { /* implement */ })
                        Button("Help", action: { /* implement */ })
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .padding()
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Empty State
                if viewModel.cards.isEmpty {
                    VStack {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "creditcard")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 60)
                                .foregroundColor(.gray)
                            Text("No cards yet")
                                .font(.title3)
                                .foregroundColor(.gray)
                            Text("Tap + to add your first card")
                                .font(.footnote)
                                .foregroundColor(.gray.opacity(0.8))
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .offset(y: -40)
                    
                } else {
                    // Card List
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.cards, id: \.id) { userCard in
                                UserCardCell(userCard: userCard)
                                    .onLongPressGesture {
                                        showingDeleteConfirm = true
                                        selectedCardToDelete = userCard
                                    }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            
        }
        // Load cards only once when view appears
        .onAppear {
            if viewModel.cards.isEmpty {
                viewModel.fetchCards()
            }
        }
        // Listen for "didAddCard" notifications to refresh list
        .onReceive(NotificationCenter.default.publisher(for: .didAddCard)) { notification in
            if let updated = notification.object as? [UserCardResponse] {
                viewModel.cards = updated
            } else {
                viewModel.fetchCards()
            }
        }
        .alert("Delete Card?", isPresented: $showingDeleteConfirm) {
            Button("Delete", role: .destructive) {
                if let card = selectedCardToDelete {
                    viewModel.deleteCard(card)
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}

extension Notification.Name {
    static let didAddCard = Notification.Name("didAddCard")
}

#Preview {
    CardListView()
}
