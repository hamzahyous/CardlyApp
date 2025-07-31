//
//  CardListViewModel.swift
//  CardlyApp
//
//  Created by Hamzah Yousuf on 7/12/25.
//

import Foundation
import SwiftUI

class UserCardsViewModel: ObservableObject {
    @Published var cards: [UserCardResponse] = []
    
    init() {
        //fetchCards()
    }
    
    func fetchCards() {
        CardService.shared.fetchUserCards { result in
        
            DispatchQueue.main.async {
                switch result {
                case .success(let userCards):
                    self.cards = userCards
                case .failure(let error):
                    print("Failed to fetch user cards: \(error.localizedDescription)")
                }
            }
        }
        
    }
    
    // Delete user card through API
    func deleteCard(_ card: UserCardResponse) {
        CardService.shared.deleteUserCard(userCardId: card.id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    // Remove from local cards array after deletion
                    self.cards.removeAll { $0.id == card.id }
                case .failure(let error):
                    print("Failed to delete card: \(error.localizedDescription)")
                }
            }
        }
    }
}
