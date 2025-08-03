//
//  GradientHelper.swift
//  CardlyApp
//
//  Created by Hamzah Yousuf on 7/12/25.
//

import SwiftUI
import Foundation

enum GradientHelper {
    static func gradientColor(for issuer: String, tier: String? = nil) -> LinearGradient {
        let baseColor: Color
        
        switch issuer.lowercased() {
        case "chase":
            baseColor = Color(hex: "#0F3D91") // Chase blue
        case "american express", "amex":
            baseColor = Color(hex: "#4E8EC2") // Amex blue
        case "capital one":
            baseColor = Color(hex: "#B22222") // Capital One red
        case "citi":
            baseColor = Color(hex: "#1A73E8") // Citi blue
        default:
            baseColor = .gray
        }
        
        // Optionally darken for premium tiers
        let secondaryColor: Color = (tier?.lowercased() == "premium") ? baseColor.opacity(0.8) : baseColor.opacity(0.6)
        
        return LinearGradient(colors: [secondaryColor, baseColor], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6: // RGB
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
}
