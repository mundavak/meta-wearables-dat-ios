/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

//
// ImageAnalyzer.swift
//
// Protocol and implementations for AI-powered image analysis from captured photos.
// Supports multiple AI providers (Claude, Gemini) for analyzing what the glasses see.
//

import Foundation
import UIKit

/// Result of an AI image analysis
struct AnalysisResult {
  let text: String
  let provider: String
  let timestamp: Date
}

/// Protocol for AI image analyzers
protocol ImageAnalyzer {
  var providerName: String { get }
  func analyze(image: UIImage) async throws -> AnalysisResult
}

/// Errors that can occur during image analysis
enum AnalysisError: LocalizedError {
  case invalidImage
  case networkError(Error)
  case apiError(String)
  case missingAPIKey
  case invalidResponse
  
  var errorDescription: String? {
    switch self {
    case .invalidImage:
      return "Invalid image format"
    case .networkError(let error):
      return "Network error: \(error.localizedDescription)"
    case .apiError(let message):
      return "API error: \(message)"
    case .missingAPIKey:
      return "API key not configured"
    case .invalidResponse:
      return "Invalid response from AI service"
    }
  }
}

/// Claude (Anthropic) image analyzer
class ClaudeAnalyzer: ImageAnalyzer {
  let providerName = "Claude"
  private let apiKey: String
  private let model: String
  private let maxTokens: Int
  
  init(apiKey: String, model: String = "claude-3-5-sonnet-20241022", maxTokens: Int = 1024) {
    self.apiKey = apiKey
    self.model = model
    self.maxTokens = maxTokens
  }
  
  func analyze(image: UIImage) async throws -> AnalysisResult {
    guard !apiKey.isEmpty else {
      throw AnalysisError.missingAPIKey
    }
    
    // Resize image to 1024px max dimension for API efficiency
    guard let resizedImage = image.resized(maxDimension: 1024),
          let imageData = resizedImage.jpegData(compressionQuality: 0.8) else {
      throw AnalysisError.invalidImage
    }
    
    let base64Image = imageData.base64EncodedString()
    
    let requestBody: [String: Any] = [
      "model": model,
      "max_tokens": maxTokens,
      "messages": [
        [
          "role": "user",
          "content": [
            [
              "type": "image",
              "source": [
                "type": "base64",
                "media_type": "image/jpeg",
                "data": base64Image
              ]
            ],
            [
              "type": "text",
              "text": "Describe what you see in this image captured from smart glasses. Be concise and focus on the most important elements."
            ]
          ]
        ]
      ]
    ]
    
    guard let url = URL(string: "https://api.anthropic.com/v1/messages") else {
      throw AnalysisError.invalidResponse
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
    request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
    request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw AnalysisError.invalidResponse
    }
    
    guard httpResponse.statusCode == 200 else {
      let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
      throw AnalysisError.apiError("HTTP \(httpResponse.statusCode): \(errorMessage)")
    }
    
    guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
          let content = json["content"] as? [[String: Any]],
          let firstContent = content.first,
          let text = firstContent["text"] as? String else {
      throw AnalysisError.invalidResponse
    }
    
    return AnalysisResult(
      text: text,
      provider: providerName,
      timestamp: Date()
    )
  }
}

/// Gemini (Google) image analyzer
class GeminiAnalyzer: ImageAnalyzer {
  let providerName = "Gemini"
  private let apiKey: String
  private let model: String
  
  init(apiKey: String, model: String = "gemini-2.0-flash-exp") {
    self.apiKey = apiKey
    self.model = model
  }
  
  func analyze(image: UIImage) async throws -> AnalysisResult {
    guard !apiKey.isEmpty else {
      throw AnalysisError.missingAPIKey
    }
    
    // Resize image for API
    guard let resizedImage = image.resized(maxDimension: 1024),
          let imageData = resizedImage.jpegData(compressionQuality: 0.8) else {
      throw AnalysisError.invalidImage
    }
    
    let base64Image = imageData.base64EncodedString()
    
    let requestBody: [String: Any] = [
      "contents": [
        [
          "parts": [
            [
              "text": "Describe what you see in this image captured from smart glasses. Be concise and focus on the most important elements."
            ],
            [
              "inline_data": [
                "mime_type": "image/jpeg",
                "data": base64Image
              ]
            ]
          ]
        ]
      ]
    ]
    
    guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent?key=\(apiKey)") else {
      throw AnalysisError.invalidResponse
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw AnalysisError.invalidResponse
    }
    
    guard httpResponse.statusCode == 200 else {
      let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
      throw AnalysisError.apiError("HTTP \(httpResponse.statusCode): \(errorMessage)")
    }
    
    guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
          let candidates = json["candidates"] as? [[String: Any]],
          let firstCandidate = candidates.first,
          let content = firstCandidate["content"] as? [String: Any],
          let parts = content["parts"] as? [[String: Any]],
          let firstPart = parts.first,
          let text = firstPart["text"] as? String else {
      throw AnalysisError.invalidResponse
    }
    
    return AnalysisResult(
      text: text,
      provider: providerName,
      timestamp: Date()
    )
  }
}

// MARK: - UIImage Extension for Resizing
extension UIImage {
  func resized(maxDimension: CGFloat) -> UIImage? {
    let scale = maxDimension / max(size.width, size.height)
    if scale >= 1 { return self }
    
    let newSize = CGSize(width: size.width * scale, height: size.height * scale)
    let renderer = UIGraphicsImageRenderer(size: newSize)
    
    return renderer.image { _ in
      self.draw(in: CGRect(origin: .zero, size: newSize))
    }
  }
}
