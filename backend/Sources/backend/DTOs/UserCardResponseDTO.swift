//
//  UserCardResponseDTO.swift
//  backend
//
//  Created by Hamzah Yousuf on 7/26/25.
//

import Vapor

struct UserCardResponseDTO: Content {
    let id: UUID
    let allCard: AllCardsResponseDTO  // allCard object
    let last4: String
    let addedDate: Date

    init(from userCard: UserCard, allCardDTO: AllCardsResponseDTO) {
        self.id = userCard.id ?? UUID()
        self.allCard = allCardDTO
        self.last4 = userCard.last4
        self.addedDate = userCard.dateAdded
    }
}

