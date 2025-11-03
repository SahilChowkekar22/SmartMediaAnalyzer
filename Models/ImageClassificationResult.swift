//
//  ImageClassificationResult.swift
//  SmartMediaAnalyzer
//
//  Created by Sahil ChowKekar on 10/29/25.
//

import Foundation

struct ImageClassificationResult: Identifiable {
    let id = UUID()
    let label: String
    let confidence: Double
}

