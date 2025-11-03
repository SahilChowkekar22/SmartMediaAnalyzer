//
//  CoreMLManager.swift
//  SmartMediaAnalyzer
//
//  Created by Sahil ChowKekar on 10/29/25.
//

import CoreML
import Vision
import UIKit
import Combine

@MainActor
final class CoreMLManager: ObservableObject {
    private var model: VNCoreMLModel?

    init() {
        Task { await loadModel() }
    }

    private func loadModel() async {
        do {
            let configuration = MLModelConfiguration()
            // Entire CoreML initialization on main actor
            let coreMLModel = try await MobileNetV2(configuration: configuration).model
            let vnModel = try VNCoreMLModel(for: coreMLModel)
            self.model = vnModel
        } catch {
            print("Failed to load MobileNetV2 model: \(error)")
            self.model = nil
        }
    }

    func classify(image: UIImage) async throws -> ImageClassificationResult {
        guard let model = model else {
            throw AppError.modelLoadFailed
        }

        guard let cgImage = image.cgImage else {
            throw AppError.invalidImage
        }

        let request = VNCoreMLRequest(model: model)
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try handler.perform([request])

        guard let best = (request.results as? [VNClassificationObservation])?.first else {
            throw AppError.noPrediction
        }

        return ImageClassificationResult(label: best.identifier, confidence: Double(best.confidence))
    }
}

