//
//  CardScanView.swift
//  CardlyApp
//
//  Created by Hamzah Yousuf on 7/13/25.
//

import SwiftUI

struct CardScannerView: View {
    
    @Binding var showScanner: Bool
    @State private var navigateToFiltered = false
    
    @State private var detectedCard: String = ""
    @State private var formattedCardNumber: String = ""
    @State private var showInfo = false
    @State private var isKeyboardVisible = false

    @State private var scannedBin = ""
    @State private var last4 = ""
    
    @State private var binMetadata: (scheme: String, tier: String, issuer: String)?

    
    var body: some View {
        Spacer()
        VStack(alignment: .leading, spacing: 16) {
            if !isKeyboardVisible {
                Text("Please focus your card and ensure you use a white background.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            CameraScannerView(detectedCard: $detectedCard)
                .frame(height: 400)
                .cornerRadius(12)
                .shadow(radius: 4)
            
            // decided based on scanned thing
            TextField("Card Number", text: $formattedCardNumber)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: detectedCard) {
                    formattedCardNumber = detectedCard
                        .chunked(by: 4)
                        .joined(separator: " ")
                }
                // user enters input into what was already populated
                .onChange(of: formattedCardNumber) {
                    let rawNumber = formattedCardNumber.replacingOccurrences(of: " ", with: "")
                    last4 = String(rawNumber.suffix(4))
                    formattedCardNumber = rawNumber.chunked(by: 4).joined(separator: " ")
                    triggerBINLookup(from: rawNumber)
                }
            

            Spacer()
            
            if !isKeyboardVisible {
                Button(action:  {
                    guard !scannedBin.isEmpty else { return } // prevents empty nav
                    navigateToFiltered = true
                }) {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                }
                .disabled(scannedBin.isEmpty) // disables until a valid BIN
                .frame(maxWidth: .infinity)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Scan Your Card")
        .onTapGesture {
            hideKeyboard()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            isKeyboardVisible = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            isKeyboardVisible = false
        }
        .navigationDestination(isPresented: $navigateToFiltered) {
            FilteredAllCardsView(
                bin: scannedBin,
                binMetadata: binMetadata,
                last4: last4,
                showScanner: $showScanner,       // pass binding down
                navigateToFiltered: $navigateToFiltered // also pass this
            )
        }
    }
    func triggerBINLookup(from rawCard: String) {
        guard rawCard.count >= 6 else { return }
        scannedBin = String(rawCard.prefix(6))
        Task {
            if let (network, tier, issuer) = await HandyAPI.lookupBIN(scannedBin) {
                binMetadata = (network, tier, issuer)
                showInfo = true
                print("Network: \(network), Tier: \(tier), Issuer: \(issuer)")
            }
        }
    }
}


extension String {
    // Splits the string into chunks of the given size, e.g. "2412751234123456".chunked(by: 4) -> ["2412", "7512", "3412", "3456"]
    func chunked(by length: Int) -> [String] {
        stride(from: 0, to: count, by: length).map {
            let start = index(startIndex, offsetBy: $0)
            let end = index(start, offsetBy: length, limitedBy: endIndex) ?? endIndex
            return String(self[start..<end])
        }
    }
}
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}

#Preview {
    CardScannerView(showScanner: .constant(true))
}

