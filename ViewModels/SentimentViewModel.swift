//
//  SentimentViewModel.swift
//  SmartMediaAnalyzer
//
//  Created by Sahil ChowKekar on 10/29/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class SentimentViewModel: ObservableObject {
    @Published var sentiment: SentimentResult?
    @Published var textInput: String = ""

    private let analyzer = SentimentAnalyzer()

    func analyzeText() {
        // Convenience wrapper for callers that can't use async/await.
        Task { [textInput] in
            await analyzeTextAsync(input: textInput)
        }
    }

    func analyzeTextAsync(input: String? = nil) async {
        let inputToUse = input ?? textInput
        let result = await analyzer.analyze(text: inputToUse)
        sentiment = result
    }
}
