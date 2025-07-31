//
//  CreateUserCard.swift
//  backend
//
//  Created by Hamzah Yousuf on 7/25/25.
//

import Fluent

struct CreateUserCard: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("user_cards")
            .id()
            .field("all_card_id", .uuid, .required,
                   .references("all_cards", "id", onDelete: .cascade))
            .field("last4", .string, .required)
            .field("date_added", .datetime, .required)
            .create()
        
    }
    func revert(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("user_cards").delete()
    }
    
}
