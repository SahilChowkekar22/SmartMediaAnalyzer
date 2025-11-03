//
//  ViewModelIntegrationTests.swift
//  SmartMediaAnalyzerTests
//
//  Created by Sahil ChowKekar on 10/29/25.
//

import UIKit
import XCTest

@testable import SmartMediaAnalyzer

@MainActor
final class ViewModelIntegrationTests: XCTestCase {

    // Integration: classify image + check state transition
    func testImageClassifierIntegrationFlow() async {
        let vm = ImageClassifierViewModel()
        guard let image = UIImage(systemName: "photo") else {
            XCTFail("Missing image resource")
            return
        }

        // Start test
        XCTAssertNil(vm.result)
        await vm.classify(image: image)
        try? await Task.sleep(nanoseconds: 200_000_000)

        XCTAssertNotNil(
            vm.result ?? vm.errorMessage,
            "Either a result or error must be produced."
        )
        XCTAssertFalse(
            vm.isLoading,
            "Loading state must reset to false after processing."
        )
    }

    // Integration: Sentiment analyzer view model with various inputs
    func testSentimentFlowDifferentTexts() async {
        let vm: SentimentViewModel = await MainActor.run {
            SentimentViewModel()
        }
        let inputs = [
            "I adore coding in SwiftUI",
            "This app is bad and slow",
            "It's fine.",
            "",
        ]

        for input in inputs {
            await MainActor.run {
                vm.textInput = input
            }
            await vm.analyzeTextAsync()

            if input.isEmpty {
                XCTAssertNil(
                    vm.sentiment,
                    "Sentiment should be nil for empty input"
                )
            } else {
                XCTAssertNotNil(
                    vm.sentiment,
                    "Sentiment should not be nil for input: \(input)"
                )
                XCTAssert(vm.sentiment?.confidence ?? 0 >= 0)
            }
        }

    }

    // Regression: ensure no UI freeze or async crash
    func testAsyncSafetyUnderStress() async {
        let vm: ImageClassifierViewModel = await MainActor.run {
            ImageClassifierViewModel()
        }
        guard let image = UIImage(systemName: "photo") else { return }

        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<10 {
                group.addTask {
                    await vm.classify(image: image)
                }
            }
        }
        XCTAssertFalse(vm.isLoading)
    }
}
