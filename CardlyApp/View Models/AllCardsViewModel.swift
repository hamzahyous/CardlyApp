//
//  AllCardsViewModel.swift
//  CardlyApp
//
//  Created by Hamzah Yousuf on 7/28/25.
//

import SwiftUI
import Foundation

class AllCardsViewModel: ObservableObject {
    @Published var cards: [AllCardResponse] = []
    
    init() {
        fetchAllCards()
    }
    
    func fetchAllCards() {
        CardService.shared.fetchAllCards { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let allCards):
                    self.cards = allCards
                case .failure(let error):
                    print("Failed to load all cards:", error.localizedDescription)
                }
            }
        }
    }
}
