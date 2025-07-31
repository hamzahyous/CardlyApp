//
//  HandyAPI.swift
//  CardlyApp
//
//  Created by Hamzah Yousuf on 7/17/25.
//

import Foundation

struct HandyAPI {
    static func lookupBIN(_ bin: String) async -> (network: String, tier: String, issuer: String)? {
        // api request we call for a spesific bin we pass in. Returns a beautiful tuple of info we want.
        guard let url = URL(string: "https://data.handyapi.com/bin/\(bin)") else {
            return nil
        }
    
        // header as defined by my HandyAPI account. A secret.
        var request = URLRequest(url: url)
        request.setValue("HAS-0Y0497x5U1gb0KrCJPuhLvMj8y", forHTTPHeaderField: "x-api-key")

        do {
            // request actually send to server
            let (data, _) = try await URLSession.shared.data(for: request)
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                let network = (json["Scheme"] as? String ?? "").uppercased()
                let tier = (json["CardTier"] as? String ?? "").uppercased()
                let issuer = (json["Issuer"] as? String ?? "").uppercased()
                // tuple we want
                return (network, tier, issuer)
            }
        } catch {
            print("HandyAPI error: \(error.localizedDescription)")
        }
        return nil

    }
}
