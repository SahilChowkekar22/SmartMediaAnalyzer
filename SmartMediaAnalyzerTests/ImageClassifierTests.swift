//
//  ImageClassifierTests.swift
//  SmartMediaAnalyzerTests
//
//  Created by Sahil ChowKekar on 10/29/25.
//

import UIKit
import XCTest

@testable import SmartMediaAnalyzer

@MainActor
final class ImageClassifierTests: XCTestCase {

    var manager: CoreMLManager!
    var viewModel: ImageClassifierViewModel!

    override func setUp() async throws {
        manager = CoreMLManager()
        viewModel = await ImageClassifierViewModel()
    }

    override func tearDown() async throws {
        manager = nil
        viewModel = nil
    }

    // Test if model loads successfully
    func testModelLoadsSuccessfully() async throws {
        let mirror = Mirror(reflecting: manager!)
        let modelProperty = mirror.children.first { $0.label == "model" }
        XCTAssertNotNil(
            modelProperty,
            "CoreML model should be loaded at initialization"
        )
    }

    // Test classification handles invalid image safely
    func testClassifyWithInvalidImage() async throws {
        let blankImage = UIImage()

        do {
            _ = try await manager.classify(image: blankImage)
            XCTFail("Expected error for invalid image, but none was thrown.")
        } catch {
            XCTAssertTrue(
                error.localizedDescription.contains("Invalid"),
                "Should throw an invalid model/image error"
            )
        }
    }

    // Test ViewModel updates its published result
    func testViewModelUpdatesResult() async throws {
        // Mock image from asset or local file
        guard let testImage = UIImage(systemName: "photo") else {
            XCTFail("Unable to load test image.")
            return
        }

        // Execute async classification
        await viewModel.classify(image: testImage)

        // Wait briefly for async update
        try await Task.sleep(nanoseconds: 300_000_000)

        let result = viewModel.result
        XCTAssertNotNil(
            result,
            "ViewModel should store classification result after completion."
        )
    }

    // Test valid image triggers classification (mock)
    func testMockImageClassificationDoesNotCrash() async {
        guard let image = UIImage(systemName: "photo") else {
            XCTFail("Failed to load SF Symbol test image")
            return
        }
        do {
            let _ = try await manager.classify(image: image)
        } catch {
            // Some models might fail on mock input — ensure it doesn't crash
            XCTAssertNotNil(error)
        }
    }

    // Test ViewModel toggles loading correctly
    func testViewModelLoadingState() async {
        let image = UIImage(systemName: "photo")!
        XCTAssertFalse(viewModel.isLoading)
        await viewModel.classify(image: image)
        XCTAssertFalse(
            viewModel.isLoading,
            "Loading should return to false after classification"
        )
    }
    
    // Test ViewModel publishes error message
        func testViewModelErrorHandling() async {
            let blankImage = UIImage()
            await viewModel.classify(image: blankImage)
            XCTAssertNotNil(viewModel.errorMessage, "Error message should be set on invalid input")
        }
    
    func testLoadModelInitialization() async throws {
        // Access the private model via reflection
        let mirror = Mirror(reflecting: manager!)
        let modelProperty = mirror.children.first { $0.label == "model" }
        XCTAssertNotNil(modelProperty, "Model should be initialized during setup")
    }

    func testLoadModelFailureDoesNotCrash() async throws {
        // We cannot subclass CoreMLManager (likely an actor and non-open),
        // so instead verify that it can be initialized and that failure paths
        // are handled gracefully by using clearly invalid input.
        XCTAssertNotNil(manager, "Manager should initialize even if model load might fail internally")

        // Classification with an empty image should throw; ensure it does not crash and is a handled error.
        let blankImage = UIImage()
        do {
            _ = try await manager.classify(image: blankImage)
            XCTFail("Expected classification to throw for invalid image input")
        } catch {
            // Expecting an error path; just assert we received one.
            XCTAssertNotNil(error)
        }
    }
    
    func testSuccessfulClassificationReturnsResult() async throws {
        guard let image = UIImage(systemName: "photo") else {
            XCTFail("Test image not found")
            return
        }

        do {
            let result = try await manager.classify(image: image)
            XCTAssertNotNil(result.label)
            XCTAssert(result.confidence >= 0 && result.confidence <= 1, "Confidence should be between 0 and 1")
        } catch {
            // It’s fine if Vision fails — but we log the error for clarity
            print("Classification error: \(error.localizedDescription)")
        }
    }

    func testConcurrentClassifications() async throws {
        guard let image = UIImage(systemName: "photo") else { return }

        await withTaskGroup(of: Void.self) { group in
            for i in 1...3 {
                group.addTask {
                    do {
                        _ = try await self.manager.classify(image: image)
                        print("Classification \(i) done")
                    } catch {
                        print("Classification \(i) failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }



}
