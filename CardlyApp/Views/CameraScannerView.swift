//
//  CameraScannerView.swift
//  CardlyApp
//
//  Created by Hamzah Yousuf on 7/14/25.
//

import SwiftUI
import AVFoundation
import Vision

struct CameraScannerView: UIViewControllerRepresentable {
    @Binding var detectedCard: String
    
    func makeUIViewController(context: Context) -> CameraScannerController {
        let controller = CameraScannerController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraScannerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, CameraScannerDelegate {
        var parent: CameraScannerView
        init(_ parent: CameraScannerView) {
            self.parent = parent
        }
        func didDetect(cardNumber: String) {
            DispatchQueue.main.async {
                self.parent.detectedCard = cardNumber
            }
        }
    }
    
    
}
