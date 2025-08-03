//
//  UserCardCell.swift
//  CardlyApp
//
//  Created by Hamzah Yousuf on 7/31/25.
//

import SwiftUI

struct UserCardCell: View {
    let userCard: UserCardResponse

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(userCard.allCard.name)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text("**** \(userCard.last4)")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(GradientHelper.gradientColor(for: userCard.allCard.issuer, tier: userCard.allCard.tier))
                .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
}
