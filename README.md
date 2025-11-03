# SmartMediaAnalyzer

A **CoreML-powered SwiftUI application** that analyzes **images** and **text sentiment** using Apple's machine learning frameworks, all running **asynchronously** with clean **MVVM architecture** and **error handling**.

## Overview

**Smart Media Analyzer** demonstrates how to integrate **multiple CoreML models** within a SwiftUI app using modern Swift concurrency (`async/await`).  
It performs:

- **Image Classification** — Identifies objects using `MobileNetV2`  
- **Text Sentiment Analysis** — Detects sentiment using Apple’s `NaturalLanguage` framework  
- **Asynchronous Inference** — Ensures no UI freezes during processing  
- **Robust Error Handling** — Clear, user-friendly alerts for every failure scenario  
- **Unit Tests** — >60% test coverage for core logic  

This project is part of the **CoreML – Smart Media Analyzer Phase 1** learning module.

## Tech Stack

- Swift 6 / Swift Concurrency (async/await, actors)
- iOS (and compatible Apple platforms)
- Natural Language framework for sentiment analysis
- SwiftUI for UI (if applicable in your project)
- Foundation for core utilities
- Swift Testing or XCTest for automated tests

## Architecture

The app follows a **clean MVVM structure** with clear separation of concerns.

## Project Structure

- AppError  
- Resources  
- Managers  
  - CoreMLManager.swift  
  - SentimentAnalyzer.swift  
- Views  
  - ImageClassifierView.swift  
  - SentimentAnalyzerView.swift  
- Models  
  - ImageClassificationResult.swift  
  - SentimentResult.swift  
- ViewModels  
  - ImageClassifierViewModel.swift  
  - SentimentViewModel.swift  
- SmartMediaAnalyzer  
  - Assets.xcassets  
  - ContentView.swift  
  - SmartMediaAnalyzerApp.swift  
- SmartMediaAnalyzerTests  
- SmartMediaAnalyzerUITests





## Layer Responsibilities

**Models**  
Define data structures like `ImageClassificationResult` and `SentimentResult`.

**Managers**  
Contain CoreML and NaturalLanguage logic (no UI).

**ViewModels**  
Bridge business logic and views, handle state and errors.

**Views**  
Display SwiftUI interface and react to state changes.

**Utils**  
Centralized error handling via `AppError` enum.


---

## Features

### Image Classification
- Powered by **MobileNetV2**
- Uses **Vision + CoreML**
- Displays top classification label and confidence score
- Supports **PhotosPicker** for selecting any image
- Handles **unsupported formats gracefully**

### Sentiment Analysis
- Uses **Apple’s SentimentPolarity.mlmodel**
- Detects whether text is *Positive*, *Negative*, or *Neutral*
- Instant feedback with confidence estimation

### Async Processing
- Both ML tasks run asynchronously
- Smooth UI with `ProgressView` indicators
- Thread-safe model inference using Swift’s **actors**

### Error Handling
- Custom `AppError` enum for all CoreML/NLP errors  
- Descriptive alerts for user feedback  
- Centralized logging for debug builds  

### Testing
- Over **60% test coverage**
- Unit tests for ML and NLP pipelines
- Independent tests for view models

---

## Example Usage

### Image Classification
```swift
let manager = CoreMLManager()
Task {
    let result = try await manager.classify(image: UIImage(named: "cat")!)
    print(result.label)       // e.g. "Tabby Cat"
    print(result.confidence)  // e.g. 0.93
}
```

### Sentiment Analysis
```swift
let sentimentAnalyzer = SentimentAnalyzer()
let sentiment = try sentimentAnalyzer.analyze(text: "I love SwiftUI!")
print(sentiment.sentiment)   // "Positive"
```

### Testing
Test Coverage Goals

- CoreMLManager classification pipeline

- SentimentAnalyzer model predictions

- ViewModel state handling and error propagation

## UI Preview

### Image Analyzer
Select an image → classify object → show confidence.

### Text Sentiment
Enter text → analyze sentiment → display results.

### TabView
Two clean sections for Image & Text analysis.

## How to Run

1. **Clone this repository**
   ```bash
   git clone https://github.com/YourUsername/SmartMediaAnalyzer.git
   cd SmartMediaAnalyzer
   ```
2. **Open the project**
   - Open ```SmartMediaAnalyzer.xcodeproj``` in Xcode.
3. **Build and Run**
   - Select an iOS Simulator or connect a real device.
   - Press **Cmd + R** or click **Run**.
4. **Allow Permissions**
   - When prompted, allow **Photos access**.
   - Select an image to test classification and sentiment analysis.

## References

- [Apple Core ML Documentation](https://developer.apple.com/documentation/coreml)
- [Vision Framework Guide](https://developer.apple.com/documentation/vision)
- [Natural Language Framework](https://developer.apple.com/documentation/naturallanguage)
- [MobileNetV2 Model](https://developer.apple.com/machine-learning/models/)
- [Swift Concurrency](https://developer.apple.com/documentation/swift/concurrency)

