//
//  CardCell.swift
//  CardlyApp
//
//  Created by Hamzah Yousuf on 7/12/25.
//

import Foundation
import SwiftUI

struct CardCell: View {
    let userCard: UserCardResponse

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(userCard.allCard.name)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            // ✅ Display last4 from userCard
            Text("**** \(userCard.last4)")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            
            // ✅ Show issuer/network info from embedded allCard
            Text("\(userCard.allCard.network) • \(userCard.allCard.issuer)")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.7))
            
            Text("\(userCard.allCard.tier) – \(userCard.allCard.rewardsType)")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(GradientHelper.gradientColor(for: userCard.allCard.rewardsType))
                .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
}

