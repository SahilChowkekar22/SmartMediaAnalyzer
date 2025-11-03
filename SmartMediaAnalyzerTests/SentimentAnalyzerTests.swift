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
        let result = await analyzer.analyze(text: "I love SwiftUI so much!")
        XCTAssertEqual(result.sentiment.lowercased(), "positive", "Expected positive sentiment for positive text.")
    }
    
    // Test negative text detection
    func testNegativeSentiment() async throws {
        let result = await analyzer.analyze(text: "I hate bugs in my app.")
        XCTAssertEqual(result.sentiment.lowercased(), "negative", "Expected negative sentiment for negative text.")
    }
    
    // Test neutral/empty text handling
    func testNeutralOrEmptyText() async throws {
        let result = await analyzer.analyze(text: "")
        XCTAssertNotNil(result)
        XCTAssertTrue(result.sentiment.isEmpty == false, "Analyzer should still return a valid SentimentResult struct.")
    }
    
    // ✅ Sentiment confidence within valid range
        func testConfidenceRange() async {
            let result = await analyzer.analyze(text: "Great product, amazing UX!")
            XCTAssert(result.confidence >= 0 && result.confidence <= 1.0, "Confidence should be within [0,1]")
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

