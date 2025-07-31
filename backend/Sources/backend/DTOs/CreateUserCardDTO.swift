//
//  UserCarDTO.swift
//  backend
//
//  Created by Hamzah Yousuf on 7/25/25.
//

import Vapor

struct CreateUserCardDTO: Content {
    let allCardId: UUID
    let last4: String
}
