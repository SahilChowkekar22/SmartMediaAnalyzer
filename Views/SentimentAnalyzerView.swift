//
//  SentimentAnalyzerView.swift
//  SmartMediaAnalyzer
//
//  Created by Sahil ChowKekar on 10/29/25.
//

import SwiftUI

struct SentimentAnalyzerView: View {
    @StateObject private var viewModel = SentimentViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    
                    VStack(spacing: 6) {
                        Text("Smart Sentiment Analyzer")
                            .font(.title2.bold())
                            .foregroundStyle(.primary)
                        Text("Analyze emotions behind your text using Natural Language")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                    .padding(.top, 30)
                    
                    //Input Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Enter text to analyze")
                            .font(.headline)
                        
                        TextField("Type something like 'I love SwiftUI'",
                                  text: $viewModel.textInput,
                                  axis: .vertical)
                        .lineLimit(3...6)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal)
                    
                    //Analyze Button
                    Button {
                        viewModel.analyzeText()
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    } label: {
                        Label("Analyze Sentiment", systemImage: "brain.head.profile")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(colors: [.blue.opacity(0.9), .purple.opacity(0.8)],
                                               startPoint: .leading,
                                               endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal)
                    
                    //Results Section
                    if let sentiment = viewModel.sentiment {
                        VStack(spacing: 8) {
                            Text("Sentiment Result")
                                .font(.headline)
                                .foregroundStyle(.primary)
                            
                            Text(sentiment.sentiment)
                                .font(.title2.bold())
                                .foregroundColor(colorForSentiment(sentiment.sentiment))
                                .transition(.opacity.combined(with: .scale))
                                .animation(.spring(), value: sentiment.sentiment)
                            
                            Text("Confidence: \(String(format: "%.2f", sentiment.confidence * 100))%")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(14)
                        .shadow(radius: 4)
                        .padding(.horizontal)
                    } else {
                        Text("Enter a sentence and tap **Analyze** to see its mood.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Text Sentiment")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    

    private func colorForSentiment(_ sentiment: String) -> Color {
        switch sentiment.lowercased() {
        case "positive":
            return .green
        case "negative":
            return .red
        case "neutral":
            return .gray
        default:
            return .blue
        }
    }
}

#Preview {
    SentimentAnalyzerView()
}
