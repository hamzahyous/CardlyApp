//
//  CardService.swift
//  CardlyApp
//
//  Created by Hamzah Yousuf on 7/26/25.
//

import Foundation

// maps to AllCardsResponseDTO
struct AllCardResponse: Codable {
    let id: UUID
    let name: String
    let issuer: String
    let network: String
    let tier: String
    let binPrefixes: [String]
    let rewardsType: String
    let categoryMultipliers: [String: Double]
    let verified: Bool
}

// maps to UserCardResponseDTO
struct UserCardResponse: Codable {
    let id: UUID
    let allCard: AllCardResponse
    let last4: String
    let addedDate: Date
}

// request for adding a user card
struct CreateUserCardRequest: Codable {
    let allCardId: UUID
    let last4: String
}

// request for creating a new AllCard
struct CreateAllCardRequest: Codable {
    let name: String
    let issuer: String
    let network: String
    let tier: String
    let binPrefixes: [String]
    let rewardsType: String
    let categoryMultipliers: [String: Double]
}



class CardService {
    static let shared = CardService()
    private init () {}
    
    private let baseURL = URL(string: "http://127.0.0.1:8080")!
    
    /// A reusable function that performs a network request and decodes the JSON response into a Decodable type.
    /// Check if request succeeded, then if data was recieved, then if recieved, try to decode
    /// - Parameters:
    ///   - request: The `URLRequest` (GET, POST, DELETE, etc.) to send to the backend.
    ///   - completion: A closure that returns either a successfully decoded object of type `T` or an `Error`.
    private func performRequest<T: Decodable>(
        _ request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        // Create a data task with URLSession to send the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Check if the request failed (e.g., no internet, server down)
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Ensure we actually received data
            guard let data = data else {
                // No data? Just return without calling success
                return
            }
            
            // Try to decode the JSON into the expected type `T`
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601   // ✅ Add this
                let decoded = try decoder.decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                print("Decoding failed: \(error)")
                completion(.failure(error))
            }
            
        }.resume() // `.resume()` is required to start the network call
    }
    
    // Note: Fetch all cards from backend
    func fetchAllCards(completion: @escaping (Result<[AllCardResponse], Error>) -> Void) {
        let url = baseURL.appendingPathComponent("all-cards")
        let request = URLRequest(url: url)
        performRequest(request, completion: completion)
    }
    
    // Note: Create a new AllCard (manual entry)
    func createAllCard(_ newCard: CreateAllCardRequest, completion: @escaping(Result<AllCardResponse, Error>) -> Void) {
        let url = baseURL.appendingPathComponent( "all-cards")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(newCard)
        performRequest(request, completion: completion)
    }
    
    // Note: Fetch user’s cards
    func fetchUserCards(completion: @escaping (Result<[UserCardResponse], Error>) -> Void) {
        let url = baseURL.appendingPathComponent("user-cards")
        let request = URLRequest(url: url)
        performRequest(request, completion: completion)
    }

    // Note: Add a card to user’s collection
    func addUserCard(_ createRequest: CreateUserCardRequest, completion: @escaping (Result<UserCardResponse, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("user-cards")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(createRequest)
        performRequest(request, completion: completion)
    }

    // Note: Delete a user card
    func deleteUserCard(userCardId: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("user-cards/\(userCardId.uuidString)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        // For DELETE, no JSON to decode, handle manually
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error { completion(.failure(error)) }
            else { completion(.success(())) }
        }.resume()
    }
    
    
}
