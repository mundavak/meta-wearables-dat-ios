/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

//
// AnalysisViewModel.swift
//
// View model for managing AI image analysis from captured photos.
// Supports switching between Claude and Gemini analyzers.
//

import Foundation
import UIKit

enum AnalyzerProvider: String, CaseIterable {
  case claude = "Claude"
  case gemini = "Gemini"
}

@MainActor
class AnalysisViewModel: ObservableObject {
  @Published var isAnalyzing: Bool = false
  @Published var analysisResult: AnalysisResult?
  @Published var showError: Bool = false
  @Published var errorMessage: String = ""
  @Published var selectedProvider: AnalyzerProvider = .claude
  
  private var claudeAnalyzer: ClaudeAnalyzer?
  private var geminiAnalyzer: GeminiAnalyzer?
  
  init() {
    // Load API keys from environment or Info.plist
    if let claudeKey = ProcessInfo.processInfo.environment["CLAUDE_API_KEY"] ?? 
                       Bundle.main.object(forInfoDictionaryKey: "CLAUDE_API_KEY") as? String,
       !claudeKey.isEmpty {
      claudeAnalyzer = ClaudeAnalyzer(apiKey: claudeKey)
    }
    
    if let geminiKey = ProcessInfo.processInfo.environment["GEMINI_API_KEY"] ?? 
                       Bundle.main.object(forInfoDictionaryKey: "GEMINI_API_KEY") as? String,
       !geminiKey.isEmpty {
      geminiAnalyzer = GeminiAnalyzer(apiKey: geminiKey)
    }
  }
  
  func analyzeImage(_ image: UIImage) async {
    isAnalyzing = true
    analysisResult = nil
    
    defer {
      isAnalyzing = false
    }
    
    do {
      let analyzer: ImageAnalyzer
      
      switch selectedProvider {
      case .claude:
        guard let claudeAnalyzer = claudeAnalyzer else {
          throw AnalysisError.missingAPIKey
        }
        analyzer = claudeAnalyzer
        
      case .gemini:
        guard let geminiAnalyzer = geminiAnalyzer else {
          throw AnalysisError.missingAPIKey
        }
        analyzer = geminiAnalyzer
      }
      
      let result = try await analyzer.analyze(image: image)
      analysisResult = result
      
    } catch {
      showError(error.localizedDescription)
    }
  }
  
  func clearAnalysis() {
    analysisResult = nil
  }
  
  func showError(_ message: String) {
    errorMessage = message
    showError = true
  }
  
  func dismissError() {
    showError = false
    errorMessage = ""
  }
  
  var hasAPIKeys: Bool {
    claudeAnalyzer != nil || geminiAnalyzer != nil
  }
  
  var availableProviders: [AnalyzerProvider] {
    var providers: [AnalyzerProvider] = []
    if claudeAnalyzer != nil {
      providers.append(.claude)
    }
    if geminiAnalyzer != nil {
      providers.append(.gemini)
    }
    return providers
  }
}
