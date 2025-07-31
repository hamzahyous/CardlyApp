//
//  CardSeeder.swift
//  CardlyApp
//
//  Created by Hamzah Yousuf on 7/16/25.
//

import Foundation
import CoreData

// Basic seed data struct
struct CardSeedData {
    let name: String
    let issuer: String
    let network: String
    let cardType: String
    let rewardsType: String
    let tier: String
    let categoryTags: [String]
}

struct CardSeeder {
    static func seedCards(context: NSManagedObjectContext) {
        // 1. Check if cards already exist
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "AllCards")
        fetchRequest.includesPropertyValues = false

        do {
            let count = try context.count(for: fetchRequest)
            if count > 0 {
                print("AllCards already seeded. Skipping.")
                return
            }
        } catch {
            print("Error checking existing cards: \(error)")
            return
        }

        // 2. Add sample cards
        for card in sampleCardData() {
            let newCard = AllCards(context: context)
            newCard.id = UUID()
            newCard.name = card.name
            newCard.network = card.network
            newCard.issuer = card.issuer
            newCard.tier = card.tier
            newCard.rewardsType = card.rewardsType
            newCard.cardType = card.cardType
            newCard.categoryTags = card.categoryTags as NSObject
        }

        // 3. Save to Core Data
        do {
            try context.save()
            print("Seeded AllCards successfully.")
        } catch {
            print("Failed to save: \(error)")
        }
    }

    // 4. Sample cards to load
    static func sampleCardData() -> [CardSeedData] {
        return [
            CardSeedData(
                name: "Citi Double Cash",
                issuer: "Citi",
                network: "MASTERCARD",
                cardType: "Credit",
                rewardsType: "Cashback",
                tier: "Standard",
                categoryTags: ["groceries", "gas", "everywhere"]
            ),
            CardSeedData(
                name: "Chase Sapphire Preferred",
                issuer: "Chase",
                network: "VISA",
                cardType: "Credit",
                rewardsType: "Points",
                tier: "Signature",
                categoryTags: ["travel", "dining"]
            )
        ]
    }
}
