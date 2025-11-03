//
//  ImageClassifierView.swift
//  SmartMediaAnalyzer
//
//  Created by Sahil ChowKekar on 10/29/25.
//

import SwiftUI
import PhotosUI

struct ImageClassifierView: View {
    @StateObject private var viewModel = ImageClassifierViewModel()
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    VStack(spacing: 6) {
                        Text("Smart Image Classifier")
                            .font(.title2.bold())
                            .foregroundStyle(.primary)
                        Text("Select an image to analyze using Core ML")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 30)
                    
                    //Image Picker Button
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Label("Select Image", systemImage: "photo.on.rectangle")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(colors: [.blue.opacity(0.8), .purple.opacity(0.8)],
                                               startPoint: .leading, endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    
                    //Image Preview
                    if let image = selectedImage {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.secondarySystemBackground))
                                .shadow(radius: 5)
                            
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(16)
                                .padding()
                        }
                        .frame(height: 250)
                        .padding(.horizontal)
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "photo")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.6))
                            Text("No image selected")
                                .foregroundColor(.secondary)
                        }
                        .frame(height: 250)
                        .frame(maxWidth: .infinity)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(16)
                        .padding(.horizontal)
                    }
                    
                    //Result Section
                    VStack(spacing: 12) {
                        if viewModel.isLoading {
                            ProgressView("Analyzing Image…")
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .font(.headline)
                                .padding(.top, 10)
                        } else if let result = viewModel.result {
                            VStack(spacing: 8) {
                                Text("Result")
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                
                                Text(result.label.capitalized)
                                    .font(.title2.bold())
                                    .foregroundStyle(.blue)
                                
                                Text("Confidence: \(String(format: "%.2f", result.confidence * 100))%")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .shadow(radius: 3)
                        } else {
                            Text("Select an image to start classification.")
                                .foregroundColor(.secondary)
                                .padding()
                        }
                        
                        //Error
                        if let error = viewModel.errorMessage {
                            Text("\(error)")
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding(.top, 8)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Image Analyzer")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                        await viewModel.classify(image: uiImage)
                    }
                }
            }
        }
    }
}

#Preview {
    ImageClassifierView()
}
