# AI Image Analysis Setup Guide

This enhanced CameraAccess app includes AI-powered image analysis using Claude (Anthropic) and Gemini (Google) APIs.

## Features

- **Live Camera Streaming** from Ray-Ban Meta / Oakley Meta glasses
- **Photo Capture** from glasses camera
- **AI Analysis** of captured photos using Claude or Gemini
- **Provider Switching** between different AI models

## Setup Instructions

### 1. Get API Keys

#### Claude (Anthropic)
1. Go to https://console.anthropic.com/
2. Create an account or sign in
3. Navigate to **API Keys**
4. Click **Create Key**
5. Copy your API key (starts with `sk-ant-...`)

#### Gemini (Google)
1. Go to https://aistudio.google.com/apikey
2. Sign in with your Google account
3. Click **Get API key** or **Create API key**
4. Copy your API key

### 2. Configure API Keys in Xcode

You have two options:

#### Option A: Add to Info.plist (Recommended for development)

1. Open `CameraAccess/Info.plist` in Xcode
2. Right-click in the property list → **Add Row**
3. Add your keys:

```xml
<key>CLAUDE_API_KEY</key>
<string>YOUR_CLAUDE_API_KEY_HERE</string>
<key>GEMINI_API_KEY</key>
<string>YOUR_GEMINI_API_KEY_HERE</string>
```

**⚠️ Important**: Never commit API keys to version control. Add `Info.plist` to `.gitignore` or use environment variables for production.

#### Option B: Use Environment Variables (Recommended for production)

1. In Xcode, go to **Product → Scheme → Edit Scheme...**
2. Select **Run** → **Arguments** tab
3. Under **Environment Variables**, add:
   - `CLAUDE_API_KEY` = `your_claude_key`
   - `GEMINI_API_KEY` = `your_gemini_key`

### 3. Build and Run

1. Open `CameraAccess.xcodeproj` in Xcode
2. Select your development team in **Signing & Capabilities**
3. Connect your iPhone
4. Build and run (⌘R)

## Usage

### Capturing and Analyzing Photos

1. **Connect Glasses**:
   - Tap "Connect my glasses"
   - Follow the Meta AI app flow to register

2. **Start Streaming**:
   - Tap "Start streaming"
   - Grant camera permission when prompted
   - Live video from your glasses appears

3. **Capture Photo**:
   - Tap the camera button while streaming
   - Photo preview appears automatically

4. **Analyze with AI**:
   - In photo preview, tap **"Analyze"**
   - Select AI provider (Claude or Gemini) if both are configured
   - Tap **"Analyze with [Provider]"**
   - Wait for AI analysis result

5. **Share**:
   - Tap **"Share"** to use iOS share sheet

## API Costs

### Claude (Anthropic)
- **Model**: claude-3-5-sonnet-20241022
- **Cost**: ~$3 per 1M input tokens, ~$15 per 1M output tokens
- **Image**: ~1,600 tokens per image (resized to 1024px)
- **Estimated**: ~$0.005 per image analysis

### Gemini (Google)
- **Model**: gemini-2.0-flash-exp
- **Cost**: Free tier available, then ~$0.075 per 1M tokens
- **Estimated**: ~$0.0001 per image analysis

## Troubleshooting

### "No API keys configured"
- Ensure you added at least one API key to Info.plist or environment variables
- Rebuild the app after adding keys

### "API error: HTTP 401"
- Your API key is invalid or expired
- Check that you copied the full key correctly
- Verify the key is active in the provider's console

### "Network error"
- Check your internet connection
- Ensure your firewall allows HTTPS requests
- Try switching to a different network

### "Invalid image format"
- The captured photo couldn't be processed
- Try capturing a new photo

## Architecture

### Files Added

```
CameraAccess/
├── Services/
│   └── ImageAnalyzer.swift          # AI analyzer protocols and implementations
├── ViewModels/
│   └── AnalysisViewModel.swift      # Analysis state management
└── Views/
    └── Components/
        └── AnalysisOverlay.swift    # AI analysis UI overlay
```

### Key Classes

- **`ImageAnalyzer`** protocol: Defines AI analyzer interface
- **`ClaudeAnalyzer`**: Anthropic Claude API integration
- **`GeminiAnalyzer`**: Google Gemini API integration
- **`AnalysisViewModel`**: Manages analysis state and provider selection
- **`AnalysisOverlay`**: Full-screen UI for analysis results

## Privacy & Security

- API keys are stored locally on device
- Images are sent to third-party AI services (Claude/Gemini)
- No images are stored on Meta's servers beyond standard DAT SDK operation
- Review each provider's privacy policy:
  - [Anthropic Privacy Policy](https://www.anthropic.com/privacy)
  - [Google Privacy Policy](https://policies.google.com/privacy)

## Support

- **Meta Wearables DAT**: https://wearables.developer.meta.com/
- **Claude API**: https://docs.anthropic.com/
- **Gemini API**: https://ai.google.dev/docs

## License

This sample code is licensed under the same license as the Meta Wearables DAT SDK.
See the LICENSE file in the root directory.
