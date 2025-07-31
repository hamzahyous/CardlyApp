//
//  CreateAllCardsDTO.swift
//  backend
//
//  Created by Hamzah Yousuf on 7/26/25.
//

import Vapor

struct CreateAllCardsDTO: Content {
    let name: String
    let issuer: String
    let network: String
    let tier: String
    let rewardsType: String
    let categoryMultipliers: [String: Double]
    let verified: Bool
}
