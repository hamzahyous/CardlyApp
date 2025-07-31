//
//  AllCardsController.swift
//  backend
//
//  Created by Hamzah Yousuf on 7/26/25.
//

import Vapor
import Fluent

struct AllCardsController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let allCards = routes.grouped("all-cards")
        allCards.get(use: getAll)                  // GET /all-cards
        allCards.get(":id", use: getOne)           // GET /all-cards/:id
        allCards.get("search", use: search)        // GET /all-cards/search?name=query
        allCards.post(use: create)                 // POST /all-cards (add missing card)
    }

    func getAll(req: Request) async throws -> [AllCardsResponseDTO] {
        let cards = try await AllCards.query(on: req.db).all()
        return cards.map(AllCardsResponseDTO.init)
    }


    func getOne(req: Request) async throws -> AllCardsResponseDTO {
        guard let id = req.parameters.get("id", as: UUID.self),
              let card = try await AllCards.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        return AllCardsResponseDTO(from: card)
    }

    
    func search(req: Request) async throws -> [AllCards] {
        guard let query = req.query[String.self, at: "name"] else {
            throw Abort(.badRequest, reason: "Missing name query parameter")
        }
        return try await AllCards.query(on: req.db)
            .filter(\.$name ~~ query) // ~~ allows partial matches (ILIKE)
            .all()
    }
    
    func create(req: Request) async throws -> AllCardsResponseDTO {
        let input = try req.content.decode(CreateAllCardsDTO.self)
        let card = AllCards(
            name: input.name,
            issuer: input.issuer,
            network: input.network,
            tier: input.tier,
            binPrefixes: [], // empty when manually added
            rewardsType: input.rewardsType,
            categoryMultipliers: input.categoryMultipliers,
            verified: false
        )
        try await card.save(on: req.db)
        return AllCardsResponseDTO(from: card)
    }


}
