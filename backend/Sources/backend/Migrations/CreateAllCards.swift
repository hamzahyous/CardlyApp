//
//  CreateAllCards.swift
//  backend
//
//  Created by Hamzah Yousuf on 7/22/25.
//

import Fluent

// We defined the structure in Model, but this MAKES THE TABLE IN POSTGRES
struct CreateAllCards: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("all_cards")
            .id()
            .field("name", .string, .required)
            .field("issuer", .string, .required)
            .field("network", .string, .required)
            .field("rewards_type", .string, .required)
            .field("tier", .string, .required)
            .field("bin_prefixes", .array(of: .string), .required)
            .field("category_multipliers", .json, .required)
            .field("verified", .bool, .required, .sql(.default(false)))
            .create()
    }

    // useful if I wanna undo a migration (vapor revert --all)
    func revert(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("all_cards").delete()
    }
}
