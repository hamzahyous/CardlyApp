//
//  AddCardView.swift
//  CardlyApp
//
//  Created by Hamzah Yousuf on 7/12/25.
//

import SwiftUI

struct ManualCardEntryView: View {
    
    // Values passed from BIN API (if detected)
    var prefilledIssuer: String?
    var prefilledNetwork: String?
    var last4: String
    var bin: String
    @Binding var showScanner: Bool
    @Binding var navigateToFiltered: Bool
    
    private let rewardsTypes = ["Cashback", "Points"]
    private let tiers = ["Entry", "Mid", "Premium"]
    private let networks = ["Visa", "Mastercard", "American Express", "Discover"]
    
    // MARK: - State
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var issuer = ""
    @State private var rewardsType = "Cashback"
    @State private var selectedNetwork = "Visa"
    @State private var tier = "Entry"
    @State private var multiplier = ""
    @State private var customCategory = "Travel"
    @State private var customValue = ""
    @State private var categoryMultipliers: [String: Double] = [:]
    private let allowedCategories = [
        "Travel",
        "Dining",
        "Groceries",
        "Gas",
        "Other",
        "Everything"
    ]


    // Initialize with prefilled values from scanner and passed from prev view
    init(
        prefilledIssuer: String? = nil,
        prefilledNetwork: String? = nil,
        last4: String,
        bin: String,
        showScanner: Binding<Bool>,
        navigateToFiltered: Binding<Bool>
    ) {
        self.prefilledIssuer = prefilledIssuer
        self.prefilledNetwork = prefilledNetwork
        self.last4 = last4
        self.bin = bin
        self._showScanner = showScanner
        self._navigateToFiltered = navigateToFiltered
        
        _issuer = State(initialValue: {
            if let prefilled = prefilledIssuer {
                return prefilled
                    .lowercased()
                    .split(separator: " ")
                    .map { $0.capitalized }
                    .joined(separator: " ")
            } else { return "" }
        }())
        
        _selectedNetwork = State(initialValue: {
            if let prefilled = prefilledNetwork?.capitalized {
                return networks.first(where: { $0.caseInsensitiveCompare(prefilled) == .orderedSame }) ?? "Visa"
            } else { return "Visa" }
        }())
    }
    
    var body: some View {
        Form {
            // Card Details
            Section(header: Text("Card Details")) {
                TextField("Card Name", text: $name)
                TextField("Issuer", text: $issuer)
                
                Picker("Network", selection: $selectedNetwork) {
                    ForEach(networks, id: \.self) { Text($0).tag($0) }
                }
                .pickerStyle(.menu)
                
                Picker("Tier", selection: $tier) {
                    ForEach(tiers, id: \.self) { Text($0).tag($0) }
                }
                .pickerStyle(.menu)
                
                Picker("Rewards Type", selection: $rewardsType) {
                    ForEach(rewardsTypes, id: \.self) { Text($0).tag($0) }
                }
                .pickerStyle(.segmented)
            }
            
            // Category Multipliers
            Section(header: Text("Add Category Multiplier")) {
                Picker("Category", selection: $customCategory) {
                    ForEach(allowedCategories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(.menu)

                TextField("Multiplier", text: $multiplier)
                    .keyboardType(.decimalPad)
                
                Button("Add") {
                    if let value = Double(multiplier), !customCategory.isEmpty {
                        categoryMultipliers[customCategory] = value
                        multiplier = ""
                    }
                }
                .disabled(Double(multiplier) == nil || customCategory.isEmpty)
                .opacity(Double(multiplier) == nil || customCategory.isEmpty ? 0.5 : 1.0)

            }
            
            // Current Multipliers
            Section(header: Text("Current Multipliers")) {
                if categoryMultipliers.isEmpty {
                    Text("No multipliers added yet")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 4)
                } else {
                    ForEach(categoryMultipliers.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        HStack {
                            Text(key)
                            Spacer()
                            Text(String(format: "%.1f", value))
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let key = Array(categoryMultipliers.keys.sorted())[index]
                            categoryMultipliers.removeValue(forKey: key)
                        }
                    }
                }
            }

            
            // Last 4 Digits
            Section(header: Text("Last 4 Digits")) {
                Text(last4).foregroundColor(.secondary)
            }
        }
        .navigationTitle("Manual Entry")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveCard()
                    navigateToFiltered = false
                    showScanner = false
                    
                }
                .disabled(!isFormValid)
            }
        }
    }
    
    // Validation
    private var isFormValid: Bool {
        !name.isEmpty && !issuer.isEmpty && !categoryMultipliers.isEmpty
    }
    
    // Save Logic
    private func saveCard() {
        // 1. Build the request for AllCards
        let parsedMultipliers = categoryMultipliers.compactMapValues { Double($0) }
        let allCardRequest = CreateAllCardRequest(
            name: name,
            issuer: issuer,
            network: selectedNetwork,
            tier: tier,
            binPrefixes: [bin],
            rewardsType: rewardsType,
            categoryMultipliers: parsedMultipliers,
            verified: false // manual cards are unverified
        )

        // 2. Create AllCard
        CardService.shared.createAllCard(allCardRequest) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let allCardResponse):
                    // 3. Link UserCard after AllCard is created (nested)
                    let userRequest = CreateUserCardRequest(
                        allCardId: allCardResponse.id,
                        last4: last4
                    )
                    CardService.shared.addUserCard(userRequest) { userResult in
                        DispatchQueue.main.async {
                            switch userResult {
                            case .success:
                                NotificationCenter.default.post(name: .didAddCard, object: nil)
                                dismiss()
                            case .failure(let error):
                                print("Failed to link user card: \(error)")
                            }
                        }
                    }

                case .failure(let error):
                    print("Failed to create AllCard: \(error)")
                }
            }
        }
    }

}

#Preview {
    NavigationStack {
        ManualCardEntryView(
            prefilledIssuer: "Chase",
            prefilledNetwork: "Visa",
            last4: "1234",
            bin: "414720",  // ✅ sample BIN for preview
            showScanner: .constant(true),
            navigateToFiltered: .constant(true)
        )
    }
}
