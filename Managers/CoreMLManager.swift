//
//  CoreMLManager.swift
//  SmartMediaAnalyzer
//
//  Created by Sahil ChowKekar on 10/29/25.
//

import CoreML
import Vision
import UIKit

actor CoreMLManager {
    private var model: VNCoreMLModel?

    init() {
        loadModel()
    }

    private func loadModel() {
        guard let model = try? VNCoreMLModel(for: MobileNetV2(configuration: MLModelConfiguration()).model) else {
            print("Failed to load MobileNetV2 model")
            return
        }
        self.model = model
    }

    func classify(image: UIImage) async throws -> ImageClassificationResult {
        guard let model = model else {
            throw AppError.modelLoadFailed
        }
        guard let cgImage = image.cgImage else {
            throw AppError.invalidImage
        }

        let request = VNCoreMLRequest(model: model)
        let handler = VNImageRequestHandler(cgImage: cgImage)

        do {
            try handler.perform([request])
        } catch {
            throw AppError.classificationFailed
        }

        guard let observation = request.results?.first as? VNClassificationObservation else {
            throw AppError.noPrediction
        }

        return ImageClassificationResult(label: observation.identifier, confidence: Double(observation.confidence))
    }
}
