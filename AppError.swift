//
//  AppError.swift
//  SmartMediaAnalyzer
//
//  Created by Sahil ChowKekar on 10/29/25.
//

import Foundation

enum AppError: LocalizedError, Identifiable {
    var id: String { localizedDescription }

    case modelLoadFailed
    case invalidImage
    case classificationFailed
    case sentimentModelFailed
    case noPrediction
    case emptyInput
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .modelLoadFailed:
            return "The ML model failed to load. Please restart the app."
        case .invalidImage:
            return "Invalid image format. Please choose a different image."
        case .classificationFailed:
            return "Could not classify the image. Try again with another one."
        case .sentimentModelFailed:
            return "The sentiment model is not available. Please check your configuration."
        case .noPrediction:
            return "Unable to get a valid prediction from the model."
        case .emptyInput:
            return "Please enter text to analyze sentiment."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

