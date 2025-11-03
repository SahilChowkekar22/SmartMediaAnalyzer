//
//  SentimentAnalyzer.swift
//  SmartMediaAnalyzer
//
//  Created by Sahil ChowKekar on 10/29/25.
//

import NaturalLanguage

actor SentimentAnalyzer {
    func analyze(text: String) throws -> SentimentResult {
        // Validate input
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AppError.emptyInput
        }

        // Use NaturalLanguage's built-in sentiment scoring via NLTagger
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text

        // Retrieve sentiment score for the full range
        let range = text.startIndex..<text.endIndex
        let nsRange = NSRange(range, in: text)
        let (tag, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)

        guard let scoreString = tag?.rawValue, let score = Double(scoreString) else {
            throw AppError.noPrediction
        }

        // Map score (-1.0 ... 1.0) to label and confidence
        let sentiment: String
        if score > 0.1 {
            sentiment = "Positive"
        } else if score < -0.1 {
            sentiment = "Negative"
        } else {
            sentiment = "Neutral"
        }

        // Confidence heuristic: magnitude of score normalized to [0,1]
        let confidence = min(1.0, max(0.0, abs(score)))

        return SentimentResult(sentiment: sentiment, confidence: confidence)
    }
}
