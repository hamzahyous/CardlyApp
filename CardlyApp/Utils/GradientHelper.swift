//
//  GradientHelper.swift
//  CardlyApp
//
//  Created by Hamzah Yousuf on 7/12/25.
//

import SwiftUI
import Foundation

enum GradientHelper {
    static func gradientColor(for category: String) -> LinearGradient {
        switch category.lowercased() {
        case "dining":
            return LinearGradient(colors: [.green.opacity(0.6), .green], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "travel":
            return LinearGradient(colors: [.blue.opacity(0.6), .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "groceries":
            return LinearGradient(colors: [.orange.opacity(0.6), .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
        default:
            return LinearGradient(colors: [.gray.opacity(0.6), .gray], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}
