//
//  ImageClassifierViewModel.swift
//  SmartMediaAnalyzer
//
//  Created by Sahil ChowKekar on 10/29/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class ImageClassifierViewModel: ObservableObject {
    @Published var result: ImageClassificationResult?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let coreMLManager = CoreMLManager()

    func classify(image: UIImage) async {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await coreMLManager.classify(image: image)
            self.result = result
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

