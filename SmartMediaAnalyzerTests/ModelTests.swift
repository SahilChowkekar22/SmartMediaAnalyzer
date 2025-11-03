//
//  ModelTests.swift
//  SmartMediaAnalyzerTests
//
//  Created by Sahil ChowKekar on 10/29/25.
//

import XCTest
@testable import SmartMediaAnalyzer

@MainActor
final class ModelTests: XCTestCase {
    

    
    func testImageClassificationResultInitialization() throws {
        let result = ImageClassificationResult(label: "Cat", confidence: 0.95)
        
        XCTAssertEqual(result.label, "Cat")
        XCTAssertEqual(result.confidence, 0.95, accuracy: 0.0001)
    }
    
    func testImageClassificationResultHasUniqueID() throws {
        let first = ImageClassificationResult(label: "Dog", confidence: 0.80)
        let second = ImageClassificationResult(label: "Dog", confidence: 0.80)
        
        XCTAssertNotEqual(first.id, second.id, "Each result should have a unique UUID.")
    }
    
    func testImageClassificationConfidenceRange() throws {
        let result = ImageClassificationResult(label: "Bird", confidence: 1.0)
        XCTAssertTrue(result.confidence >= 0 && result.confidence <= 1.0, "Confidence should be within valid range.")
    }
    
    
    func testSentimentResultInitialization() throws {
        let result = SentimentResult(sentiment: "Positive", confidence: 0.88)
        
        XCTAssertEqual(result.sentiment, "Positive")
        XCTAssertEqual(result.confidence, 0.88, accuracy: 0.0001)
    }
    
    func testSentimentConfidenceRange() throws {
        let result = SentimentResult(sentiment: "Negative", confidence: 0.45)
        XCTAssertTrue(result.confidence >= 0 && result.confidence <= 1.0, "Confidence should be within valid range.")
    }
    
    func testSentimentValuesDifferentForDifferentInputs() throws {
        let positive = SentimentResult(sentiment: "Positive", confidence: 0.9)
        let negative = SentimentResult(sentiment: "Negative", confidence: 0.1)
        
        XCTAssertNotEqual(positive.sentiment, negative.sentiment)
        XCTAssertNotEqual(positive.confidence, negative.confidence)
    }
}

