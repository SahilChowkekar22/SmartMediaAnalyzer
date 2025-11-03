//
//  ContentView.swift
//  SmartMediaAnalyzer
//
//  Created by Sahil ChowKekar on 10/29/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ImageClassifierView()
                .tabItem {
                    Label("Image", systemImage: "photo")
                }

            SentimentAnalyzerView()
                .tabItem {
                    Label("Text", systemImage: "text.quote")
                }
        }
    }
}

#Preview {
    ContentView()
}
