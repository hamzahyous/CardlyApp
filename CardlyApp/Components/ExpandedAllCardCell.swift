//
//  ExpandedAllCardCell.swift
//  CardlyApp
//
//  Created by Hamzah Yousuf on 8/3/25.
//
import SwiftUI

struct ExpandedAllCardCell: View {
    let card: AllCardResponse
    
    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 15)
                .fill(GradientHelper.gradientColor(for: card.issuer, tier: card.tier))
                .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 5)
            
            VStack(alignment: .leading, spacing: 10) {
                // 🔹 Top Row: Card Name + Logo
                HStack {
                    Text(card.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Spacer()
                    
                    if let logo = networkLogoName(for: card.network) {
                        Image(logo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 18) // ✅ smaller, consistent
                            .padding(.trailing, 4)
                    }
                }
                
                // 🔹 Network · Issuer · Tier
                Text("\(card.network) · \(card.issuer) · \(card.tier)")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))
                
                // 🔹 Rewards Pills
                if !card.categoryMultipliers.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(card.categoryMultipliers.keys.sorted(), id: \.self) { category in
                            Text(category)
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.white.opacity(0.15))
                                .clipShape(Capsule())
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading)
        .padding(.horizontal)
    }
    
    // Helper to map network to an asset name
    func networkLogoName(for network: String) -> String? {
        switch network.lowercased() {
        case "visa":
            return "visa"
        case "mastercard":
            return "mastercard"
        case "american express", "amex":
            return "amex"
        case "discover":
            return "discover"
        default:
            return nil // fallback: no logo
        }
    }

}
