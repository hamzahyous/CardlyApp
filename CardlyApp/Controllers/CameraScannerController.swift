//
//  CameraScannerController.swift
//  CardlyApp
//
//  Created by Hamzah Yousuf on 7/14/25.
//

import UIKit
import AVFoundation
import Vision

// protocol where we confirm we did get numbers (to send to view)
protocol CameraScannerDelegate: AnyObject {
    func didDetect(cardNumber: String)
}

class CameraScannerController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    weak var delegate: CameraScannerDelegate? // callbacks to swiftUI + dealloc
    
    private let session = AVCaptureSession() // controls camfera feed
    private let textRequest = VNRecognizeTextRequest() // set up vision OCR
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var lastDetectedNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupVision()
    }

    private func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            print("Failed to access camera")
            return
        }
        
        session.addInput(input)

        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera.frame.processing"))
        session.addOutput(output)

        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)

        session.startRunning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }
        
    // Speed matters, not grammar (just numbers)
    private func setupVision() {
        textRequest.recognitionLevel = .accurate
        textRequest.usesLanguageCorrection = false
        textRequest.recognitionLanguages = ["en-US"]
        textRequest.minimumTextHeight = 0.02
    }
    
    
    // Called automatically on each camera frame
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        do {
            try requestHandler.perform([textRequest])

            guard let observations = textRequest.results as? [VNRecognizedTextObservation] else { return }

            for observation in observations {
                let candidate = observation.topCandidates(1).first?.string ?? ""

                // Improved regex: captures 4 groups of 4+ digits, optionally with space or dash
                let regexPattern = "(\\d{4}[\\s-]?){3,4}\\d{4}"
                if let regex = try? NSRegularExpression(pattern: regexPattern),
                   let match = regex.firstMatch(in: candidate, range: NSRange(candidate.startIndex..., in: candidate)) {

                    let matchedString = (candidate as NSString).substring(with: match.range)
                    let cleaned = matchedString.replacingOccurrences(of: "\\s|-", with: "", options: .regularExpression)

                    if cleaned != lastDetectedNumber {
                        lastDetectedNumber = cleaned
                        DispatchQueue.main.async {
                            self.delegate?.didDetect(cardNumber: cleaned)
                        }
                    }
                    break
                }
            }

        } catch {
            // optionally handle error
        }
    }

    
    
}
