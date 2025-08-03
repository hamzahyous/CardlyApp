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
            
            // ----------- POINTS CARDS (10) -----------
            
            
            .init(
                // reliable
                name: "Chase Sapphire Reserve",
                issuer: "Chase",
                network: "Visa",
                tier: "Premium",
                binPrefixes: ["414720", "414722"],
                rewardsType: "Points",
                categoryMultipliers: [
                    "Travel": 4.0,   // booked directly with airlines, hotels, etc.
                    "Dining": 3.0,
                    "Other": 1.0     // all non-bonus purchases
                ],
                verified: true
            ),
            .init(
                // reliable
                name: "Chase Sapphire Preferred",
                issuer: "Chase",
                network: "Visa",
                tier: "Mid",
                binPrefixes: ["414723"],
                rewardsType: "Points",
                categoryMultipliers: [
                    "Travel": 2.0,
                    "Groceries": 3.0,
                    "Dining": 3.0,
                    "Other": 1.0
                ],
                verified: true
            ),
            .init(
                // reliable
                name: "American Express Gold",
                issuer: "American Express",
                network: "Amex",
                tier: "Personal",
                binPrefixes: ["371610", "379217"],
                rewardsType: "Points",
                categoryMultipliers: [
                    "Dining": 4.0,
                    "Groceries": 4.0,
                    "Travel": 3.0,
                    "Other": 1.0
                ],
                verified: true
            ),
            .init(
                // reliable
                name: "American Express Platinum",
                issuer: "American Express",
                network: "Amex",
                tier: "Premium",
                binPrefixes: ["371449", "378282"],
                rewardsType: "Points",
                categoryMultipliers: [
                    "Flights": 5.0,
                    "Hotels": 5.0,
                    "Other": 1.0
                ],
                verified: true
            ),

            .init(
                // unreliable
                name: "Capital One Venture X",
                issuer: "Capital One",
                network: "Visa",
                tier: "Premium",
                binPrefixes: ["402400"],
                rewardsType: "Points",
                categoryMultipliers: [
                    "Travel": 2.0,
                    "Other": 2.0
                ],
                verified: true
            ),

            .init(
                // unreliable
                name: "Capital One Venture Rewards",
                issuer: "Capital One",
                network: "Visa",
                tier: "Mid",
                binPrefixes: ["403993"],
                rewardsType: "Points",
                categoryMultipliers: [
                    "Travel": 2.0,
                    "Other": 2.0
                ],
                verified: true
            ),
            .init(
                // accurate
                name: "Citi Strata Premier",
                issuer: "Citi",
                network: "Mastercard",
                tier: "Mid",
                binPrefixes: ["546616"],
                rewardsType: "Points",
                categoryMultipliers: [
                    "Travel": 3.0,
                    "Dining": 3.0,
                    "Gas": 3.0,
                    "Groceries": 3.0,
                    "Other": 1.0
                ],
                verified: true
            ),
            .init(
                name: "Citi Prestige",
                issuer: "Citi",
                network: "Mastercard",
                tier: "Premium",
                binPrefixes: ["546617"],
                rewardsType: "Points",
                categoryMultipliers: [
                    "Travel": 5.0,
                    "Dining": 5.0,
                    "Other": 1.0
                ],
                verified: true
            ),
            .init(
                name: "U.S. Bank Altitude Connect",
                issuer: "U.S. Bank",
                network: "Visa",
                tier: "Mid",
                binPrefixes: ["403967"],
                rewardsType: "Points",
                categoryMultipliers: [
                    "Travel": 4.0,
                    "Gas": 4.0,
                    "Dining": 2.0,
                    "Groceries": 2.0,
                    "Streaming": 2.0,
                    "Other": 1.0
                ],
                verified: true
            ),
            .init(
                name: "Wells Fargo Autograph Journey",
                issuer: "Wells Fargo",
                network: "Visa",
                tier: "Mid",
                binPrefixes: ["414713"],
                rewardsType: "Points",
                categoryMultipliers: [
                    "Hotels": 5.0,
                    "Flights": 4.0,
                    "Travel": 3.0,
                    "Dining": 3.0,
                    "Gas": 3.0,
                    "Streaming": 3.0,
                    "Phone": 3.0,
                    "Other": 1.0
                ],
                verified: true
            ),

            
            // ----------- CASHBACK CARDS (10) -----------
            
            
            .init(
                name: "Capital One Quicksilver",
                issuer: "Capital One",
                network: "Mastercard",
                tier: "Entry",
                binPrefixes: ["517805"],
                rewardsType: "Cashback",
                categoryMultipliers: ["Everything": 1.5],
                verified: true
            ),
            .init(
                name: "Chase Freedom Unlimited",
                issuer: "Chase",
                network: "Visa",
                tier: "Entry",
                binPrefixes: ["414709"],
                rewardsType: "Cashback",   // treat as cashback for clarity
                categoryMultipliers: [
                    "Dining": 3.0,
                    "Drugstores": 3.0,
                    "Travel": 5.0,       // portal only, but you can still keep it
                    "Other": 1.5
                ],
                verified: true
            ),
            .init(
                name: "Chase Freedom Flex",
                issuer: "Chase",
                network: "Mastercard",
                tier: "Entry",
                binPrefixes: ["521234"],
                rewardsType: "Cashback",
                categoryMultipliers: [
                    "Dining": 3.0,
                    "Drugstores": 3.0,
                    "Other": 1.0
                ],
                verified: true
            ),
            .init(
                name: "Citi Double Cash",
                issuer: "Citi",
                network: "Mastercard",
                tier: "Entry",
                binPrefixes: ["546645"],
                rewardsType: "Cashback",
                categoryMultipliers: [
                    "Everything": 2.0
                ],
                verified: true
            ),
            .init(
                name: "Discover it Cashback",
                issuer: "Discover",
                network: "Discover",
                tier: "Entry",
                binPrefixes: ["601100"],
                rewardsType: "Cashback",
                categoryMultipliers: [
                    "Everything": 1.0,
                    "Rotating": 5.0  // quarterly bonus cats
                ],
                verified: true
            ),
            .init(
                name: "Bank of America Customized Cash Rewards",
                issuer: "Bank of America",
                network: "Visa",
                tier: "Entry",
                binPrefixes: ["414708"],
                rewardsType: "Cashback",
                categoryMultipliers: [
                    "Choice": 3.0,   // user can choose one category (gas, dining, travel, etc.)
                    "Groceries": 2.0,
                    "Other": 1.0
                ],
                verified: true
            ),
            .init(
                name: "Wells Fargo Active Cash",
                issuer: "Wells Fargo",
                network: "Visa",
                tier: "Entry",
                binPrefixes: ["414711"],
                rewardsType: "Cashback",
                categoryMultipliers: [
                    "Everything": 2.0
                ],
                verified: true
            ),
            .init(
                name: "Amazon Prime Visa",
                issuer: "Chase",
                network: "Visa",
                tier: "Entry",
                binPrefixes: ["410034"],
                rewardsType: "Cashback",
                categoryMultipliers: [
                    "Travel": 5.0,      // Chase Travel
                    "Gas": 2.0,
                    "Dining": 2.0,
                    "Transit": 2.0,
                    "Other": 1.0
                ],
                verified: true
            ),
            .init(
                name: "Costco Anywhere Visa",
                issuer: "Citi",
                network: "Visa",
                tier: "Entry",
                binPrefixes: ["410236"],
                rewardsType: "Cashback",
                categoryMultipliers: [
                    "Gas": 4.0,
                    "Dining": 3.0,
                    "Travel": 3.0,
                    "Other": 1.0
                ],
                verified: true
            ),

            .init(
                name: "Amex Blue Cash Preferred",
                issuer: "American Express",
                network: "Amex",
                tier: "Mid",
                binPrefixes: ["374622"],
                rewardsType: "Cashback",
                categoryMultipliers: [
                    "Groceries": 6.0,
                    "Streaming": 6.0,
                    "Gas": 3.0,
                    "Transit": 3.0,
                    "Other": 1.0
                ],
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
