//
//  SentimentAnalyzerTests.swift
//  SmartMediaAnalyzerTests
//
//  Created by Sahil ChowKekar on 10/29/25.
//

import XCTest
@testable import SmartMediaAnalyzer

final class SentimentAnalyzerTests: XCTestCase {
    
    var analyzer: SentimentAnalyzer!
    var viewModel: SentimentViewModel!
    
    @MainActor
    override func setUp() async throws {
        analyzer = SentimentAnalyzer()
        viewModel = await SentimentViewModel()
    }
    
    @MainActor
    override func tearDown() async throws {
        analyzer = nil
        viewModel = nil
    }
    
    // Test positive text detection
    func testPositiveSentiment() async throws {
        let result = try await analyzer.analyze(text: "I love SwiftUI so much!")
        let sentiment = await result.sentiment.lowercased()
        XCTAssertEqual(sentiment, "positive", "Expected positive sentiment for positive text.")
    }
    
    // Test negative text detection
    func testNegativeSentiment() async throws {
        let result = try await analyzer.analyze(text: "I hate bugs in my app.")
        let sentiment = await result.sentiment.lowercased()
        XCTAssertEqual(sentiment, "negative", "Expected negative sentiment for negative text.")
    }
    
    
    // Sentiment confidence within valid range
    func testConfidenceRange() async throws {
        let result = try await analyzer.analyze(text: "Great product, amazing UX!")
        let confidence = await result.confidence
        XCTAssert(confidence >= 0 && confidence <= 1.0, "Confidence should be within [0,1]")
    }
    
    // Test ViewModel updates published sentiment
    @MainActor
    func testViewModelAnalyzesTextAndPublishes() async throws {
        viewModel.textInput = "This is an awesome project!"
        await viewModel.analyzeText()
        
        try await Task.sleep(nanoseconds: 300_000_000)
        XCTAssertNotNil(viewModel.sentiment, "Sentiment should update after analysis.")
    }
}

