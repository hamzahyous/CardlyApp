//
//  UserCardController.swift
//  backend
//
//  Created by Hamzah Yousuf on 7/25/25.
//
// Called by Vapor during app startup to register your routes.


import Vapor
import Fluent


struct UserCardController: RouteCollection {
    // all our routes
    func boot(routes: any RoutesBuilder) throws {
        let userCards = routes.grouped("user-cards")
        userCards.post(use: create)
        userCards.get(use: getAll)
        userCards.get(":id", use: getOne)
        userCards.delete(":id", use: delete)
    }
    
    
    func create(req: Request) async throws -> UserCardResponseDTO {
        let input = try req.content.decode(CreateUserCardDTO.self)
        let userCard = UserCard(allCardID: input.allCardId, last4: input.last4)
        try await userCard.save(on: req.db)

        // fetch with relation so DTO can include allCard info
        guard let savedCard = try await UserCard.query(on: req.db)
            .with(\.$allCard)
            .filter(\.$id == userCard.id!)
            .first()
        else {
            throw Abort(.internalServerError)
        }

        let allCardDTO = AllCardsResponseDTO(from: savedCard.allCard)
        return UserCardResponseDTO(from: savedCard, allCardDTO: allCardDTO)
    }
    

    func getOne(req: Request) async throws -> UserCardResponseDTO {
        guard let id = req.parameters.get("id", as: UUID.self),
              let userCard = try await UserCard.query(on: req.db)
                  .with(\.$allCard)
                  .filter(\.$id == id)
                  .first()
        else {
            throw Abort(.notFound)
        }
        
        let allCardDTO = AllCardsResponseDTO(from: userCard.allCard)
        return UserCardResponseDTO(from: userCard, allCardDTO: allCardDTO)
    }
    
    
    func getAll(req: Request) async throws -> [UserCardResponseDTO] {
        let cards = try await UserCard.query(on: req.db).with(\.$allCard).all()
        return cards.map { userCard in
            let allCardDTO = AllCardsResponseDTO(from: userCard.allCard)
            return UserCardResponseDTO(from: userCard, allCardDTO: allCardDTO)
        }
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let id = req.parameters.get("id", as: UUID.self),
              let userCard = try await UserCard.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        try await userCard.delete(on: req.db)
        return .noContent
    }
}
