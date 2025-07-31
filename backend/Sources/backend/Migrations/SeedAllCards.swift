//
//  SeedAllCards.swift
//  backend
//
//  Created by Hamzah Yousuf on 7/25/25.
//

import Fluent

struct SeedAllCards: AsyncMigration {
    func prepare(on database: any Database) async throws {
        let cards: [AllCards] = [
            .init(
                name: "Chase Sapphire Preferred",
                issuer: "Chase",
                network: "Visa",
                tier: "Mid",
                binPrefixes: ["414720", "414721"],
                rewardsType: "Points",
                categoryMultipliers: ["Travel": 2.0, "Dining": 2.0],
                verified: true
            ),
            .init(
                name: "Amex Gold",
                issuer: "American Express",
                network: "Amex",
                tier: "Premium",
                binPrefixes: ["371610", "379217"],
                rewardsType: "Points",
                categoryMultipliers: ["Groceries": 4.0, "Dining": 4.0],
                verified: true
            ),
            .init(
                name: "Capital One Quicksilver",
                issuer: "Capital One",
                network: "Mastercard",
                tier: "Entry",
                binPrefixes: ["517805"],
                rewardsType: "Cashback",
                categoryMultipliers: ["Everything": 1.5],
                verified: true
            )
        ]

        for card in cards {
            try await card.save(on: database)
        }
    }

    func revert(on database: any Database) async throws {
        try await AllCards.query(on: database).delete()
    }
}
