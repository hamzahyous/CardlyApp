//
//  AllCard.swift
//  backend
//
//  Created by Hamzah Yousuf on 7/22/25.
//

import Fluent
import Vapor

final class AllCards: Model, Content {
    static let schema = "all_cards"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "issuer")
    var issuer: String

    @Field(key: "network")
    var network: String

    @Field(key: "tier")
    var tier: String

    @Field(key: "bin_prefixes")
    var binPrefixes: [String]

    @Field(key: "rewards_type")
    var rewardsType: String

    @Field(key: "category_multipliers")
    var categoryMultipliers: [String: Double]
    
    @Field(key: "verified")
    var verified: Bool
    init() { }

    init(id: UUID? = nil, name: String, issuer: String, network: String, tier: String, binPrefixes: [String], rewardsType: String, categoryMultipliers: [String: Double], verified: Bool) {
        self.id = id
        self.name = name
        self.issuer = issuer
        self.network = network
        self.tier = tier
        self.binPrefixes = binPrefixes
        self.rewardsType = rewardsType
        self.categoryMultipliers = categoryMultipliers
        self.verified = verified
    }
}

extension AllCards: @unchecked Sendable {}
