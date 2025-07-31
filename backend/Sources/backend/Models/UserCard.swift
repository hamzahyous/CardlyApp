//
//  UserCard.swift
//  backend
//
//  Created by Hamzah Yousuf on 7/25/25.
//

import Fluent
import Vapor

final class UserCard: Model, Content {
    static let schema = "user_cards"
    // field defines db col name
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "all_card_id")
    var allCard: AllCards
    
    @Field(key: "date_added")
    var dateAdded: Date
    
    @Field(key: "last4")
    var last4: String
    
    init() {}
    
    init(id: UUID? = nil, allCardID: UUID, last4: String ,dateAdded: Date = Date()) {
        self.id = id
        self.$allCard.id = allCardID
        self.last4 = last4
        self.dateAdded = dateAdded
    }
    
}

extension UserCard: @unchecked Sendable {}
