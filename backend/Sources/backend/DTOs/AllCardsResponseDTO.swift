//
//  AllCardResponseDTO.swift
//  backend
//
//  Created by Hamzah Yousuf on 7/26/25.
//

import Vapor

struct AllCardsResponseDTO: Content {
    let id: UUID
    let name: String
    let issuer: String
    let network: String
    let tier: String
    let binPrefixes: [String]
    let rewardsType: String
    let categoryMultipliers: [String: Double]
    let verified: Bool
    
    
    init(from card: AllCards) {
        self.id = card.id!
        self.name = card.name
        self.issuer = card.issuer
        self.network = card.network
        self.tier = card.tier
        self.binPrefixes = card.binPrefixes
        self.rewardsType = card.rewardsType
        self.categoryMultipliers = card.categoryMultipliers
        self.verified = card.verified
    }


}
