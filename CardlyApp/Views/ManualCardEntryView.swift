//
//  AddCardView.swift
//  CardlyApp
//
//  Created by Hamzah Yousuf on 7/12/25.
//
import SwiftUI

enum CardCategory: String, CaseIterable {
    case dining = "Dining"
    case travel = "Travel"
    case groceries = "Groceries"
    case other = "Other..."
}

struct ManualCardEntryView: View {

    // MARK: - State
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var lastFour = ""
    @State private var selectedCategory: CardCategory = .dining
    @State private var customCategory = ""
    @State private var multiplier = ""

    var body: some View {
        Form {
            Section(header: Text("Card Details")) {
                TextField("Name", text: $name)

                TextField("Last Four Digits", text: $lastFour)
                    .keyboardType(.numberPad)

                Picker("Category", selection: $selectedCategory) {
                    ForEach(CardCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .pickerStyle(.menu)

                if selectedCategory == .other {
                    TextField("Enter custom category", text: $customCategory)
                }

                TextField("Multiplier", text: $multiplier)
                    .keyboardType(.decimalPad)
            }
        }
        .navigationTitle("Manual Entry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveCard()
                }
                .disabled(!isFormValid)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }

    // MARK: - Validation
    private var isFormValid: Bool {
        !name.isEmpty && lastFour.count == 4 && Double(multiplier) != nil
    }

    // MARK: - Save Logic
    private func saveCard() {
        // ✅ Placeholder for backend call
        // In the future: use CardService.shared.addUserCard(...)
        print("Saving card: \(name) (\(lastFour)), \(selectedCategory.rawValue), multiplier: \(multiplier)")

        // After saving, dismiss view
        dismiss()
    }
}

#Preview {
    NavigationStack {
        ManualCardEntryView()
    }
}
