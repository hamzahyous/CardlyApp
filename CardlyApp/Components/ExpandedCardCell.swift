//
//  CardCell.swift
//  CardlyApp
//
//  Created by Hamzah Yousuf on 7/12/25.
//

import SwiftUI

struct ExpandedUserCardCell: View {
    let name: String
    let last4: String?
    let issuer: String
    let tier: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Card name
            Text(name)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            // Last 4 digits if available
            if let last4 = last4 {
                Text("**** \(last4)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }

            // Issuer
            Text(issuer)
                .font(.footnote)
                .foregroundColor(.white.opacity(0.7))

            // Tier
            Text(tier)
                .font(.footnote)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(GradientHelper.gradientColor(for: issuer, tier: tier))
                .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
}


