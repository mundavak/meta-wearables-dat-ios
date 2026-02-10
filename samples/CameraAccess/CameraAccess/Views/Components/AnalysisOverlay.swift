/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

//
// AnalysisOverlay.swift
//
// UI overlay for displaying AI analysis results on captured photos.
// Shows analysis text, provider info, and allows switching between AI providers.
//

import SwiftUI

struct AnalysisOverlay: View {
  @ObservedObject var viewModel: AnalysisViewModel
  let image: UIImage
  let onClose: () -> Void
  
  var body: some View {
    ZStack {
      // Background image
      Image(uiImage: image)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
      
      // Dark overlay
      Color.black.opacity(0.4)
        .ignoresSafeArea()
      
      VStack(spacing: 0) {
        // Top bar with close button
        HStack {
          Spacer()
          Button(action: onClose) {
            Image(systemName: "xmark.circle.fill")
              .font(.title2)
              .foregroundColor(.white)
              .padding()
          }
        }
        
        Spacer()
        
        // Analysis result card
        VStack(spacing: 16) {
          if viewModel.isAnalyzing {
            ProgressView()
              .progressViewStyle(CircularProgressViewStyle(tint: .white))
              .scaleEffect(1.5)
            Text("Analyzing...")
              .font(.headline)
              .foregroundColor(.white)
          } else if let result = viewModel.analysisResult {
            // Provider badge
            HStack {
              Image(systemName: "sparkles")
                .foregroundColor(.yellow)
              Text(result.provider)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.8))
              Spacer()
              Text(result.timestamp, style: .time)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.6))
            }
            .padding(.horizontal)
            
            // Analysis text
            ScrollView {
              Text(result.text)
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .padding()
            }
            .frame(maxHeight: 200)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)
          } else {
            // Initial state - show analyze button
            VStack(spacing: 12) {
              Image(systemName: "eye.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.white.opacity(0.8))
              
              Text("AI Image Analysis")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
              
              Text("Analyze what your glasses see")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
              
              if viewModel.hasAPIKeys {
                // Provider picker
                if viewModel.availableProviders.count > 1 {
                  Picker("Provider", selection: $viewModel.selectedProvider) {
                    ForEach(viewModel.availableProviders, id: \.self) { provider in
                      Text(provider.rawValue).tag(provider)
                    }
                  }
                  .pickerStyle(SegmentedPickerStyle())
                  .padding(.horizontal, 40)
                }
                
                Button(action: {
                  Task {
                    await viewModel.analyzeImage(image)
                  }
                }) {
                  HStack {
                    Image(systemName: "sparkles")
                    Text("Analyze with \(viewModel.selectedProvider.rawValue)")
                  }
                  .font(.headline)
                  .foregroundColor(.white)
                  .padding(.horizontal, 24)
                  .padding(.vertical, 12)
                  .background(Color.blue)
                  .cornerRadius(25)
                }
                .padding(.top, 8)
              } else {
                Text("⚠️ No API keys configured")
                  .font(.caption)
                  .foregroundColor(.yellow)
                  .padding(.top, 8)
                
                Text("Add CLAUDE_API_KEY or GEMINI_API_KEY to Info.plist")
                  .font(.caption2)
                  .foregroundColor(.white.opacity(0.6))
                  .multilineTextAlignment(.center)
                  .padding(.horizontal, 40)
              }
            }
          }
        }
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 20)
            .fill(Color.black.opacity(0.8))
        )
        .padding()
        
        Spacer()
      }
    }
    .alert("Error", isPresented: $viewModel.showError) {
      Button("OK") {
        viewModel.dismissError()
      }
    } message: {
      Text(viewModel.errorMessage)
    }
  }
}

#Preview {
  AnalysisOverlay(
    viewModel: AnalysisViewModel(),
    image: UIImage(systemName: "photo")!,
    onClose: {}
  )
}
