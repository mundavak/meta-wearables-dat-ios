# CameraAccess with AI Analysis - iOS

An enhanced version of the Meta Wearables Device Access Toolkit CameraAccess sample app with **AI-powered image analysis** using Claude and Gemini.

## 🎯 What This App Does

1. **Connect to Meta Smart Glasses** (Ray-Ban Meta, Oakley Meta HST)
2. **Stream Live Video** from the glasses camera at 24 FPS
3. **Capture Photos** hands-free from your point of view
4. **Analyze Images with AI** - Get instant descriptions of what your glasses see
5. **Share Photos** via iOS share sheet

## 🆕 AI Analysis Features

This enhanced version adds:

- **Claude (Anthropic)** integration for vision analysis
- **Gemini (Google)** integration as alternative AI provider
- **Provider switching** - choose between Claude and Gemini
- **Real-time analysis** of captured photos
- **Beautiful UI overlay** showing AI results

### Example Use Cases

- **Accessibility**: Describe surroundings for visually impaired users
- **Learning**: Identify objects, plants, landmarks while exploring
- **Shopping**: Get product information from photos
- **Translation**: Read and translate signs/text in real-time
- **Navigation**: Understand complex scenes and environments

## 📋 Prerequisites

### Hardware & Software

- **Mac** with Xcode 14+ installed
- **iPhone** running iOS 17.0+
- **Meta Smart Glasses** (Ray-Ban Meta or Oakley Meta HST)
- **Meta AI app** installed on iPhone with Developer Mode enabled

### API Keys (for AI analysis)

You'll need at least one:

- **Claude API key** from [Anthropic Console](https://console.anthropic.com/)
- **Gemini API key** from [Google AI Studio](https://aistudio.google.com/apikey)

> **Note**: The app works without API keys, but AI analysis will be disabled.

## 🚀 Quick Start

### 1. Clone and Open Project

```bash
cd "f:/Meta project/meta-wearables-dat-ios/samples/CameraAccess"
open CameraAccess.xcodeproj
```

### 2. Configure API Keys

**Option A: Info.plist (Development)**

1. Open `CameraAccess/Info.plist`
2. Uncomment and add your keys:

```xml
<key>CLAUDE_API_KEY</key>
<string>sk-ant-your-key-here</string>
<key>GEMINI_API_KEY</key>
<string>your-gemini-key-here</string>
```

**Option B: Environment Variables (Recommended)**

1. **Product → Scheme → Edit Scheme...**
2. **Run → Arguments → Environment Variables**
3. Add:
   - `CLAUDE_API_KEY` = `your_key`
   - `GEMINI_API_KEY` = `your_key`

### 3. Configure Signing

1. Select **CameraAccess** target
2. **Signing & Capabilities** tab
3. Choose your **Team**
4. Xcode will auto-generate a Bundle ID

### 4. Build and Run

1. Connect your iPhone
2. Select it as the run destination
3. Press **⌘R** or click **Run**

### 5. Pair Your Glasses

1. In the app, tap **"Connect my glasses"**
2. Follow the Meta AI app flow
3. Grant camera permission when prompted

## 📱 How to Use

### Basic Streaming

1. **Start Streaming**: Tap "Start streaming" button
2. **View Live Feed**: See real-time video from your glasses
3. **Capture Photo**: Tap camera button while streaming
4. **Stop Streaming**: Tap "Stop streaming"

### AI Analysis Workflow

1. **Capture a Photo** while streaming
2. Photo preview appears with two buttons:
   - **Analyze** (blue) - AI analysis
   - **Share** (green) - iOS share sheet
3. **Tap "Analyze"**
4. **Select AI Provider** (if both configured)
5. **Tap "Analyze with [Provider]"**
6. Wait 2-5 seconds for analysis
7. **View Results** - AI description of the image
8. **Close** to return to streaming

## 🏗️ Architecture

### New Files Added

```
CameraAccess/
├── Services/
│   └── ImageAnalyzer.swift          # AI analyzer implementations
├── ViewModels/
│   └── AnalysisViewModel.swift      # Analysis state management
└── Views/
    └── Components/
        └── AnalysisOverlay.swift    # AI analysis UI
```

### Modified Files

- `PhotoPreviewView.swift` - Added AI analysis button and integration
- `Info.plist` - Added API key placeholders

### Key Components

#### ImageAnalyzer Protocol

```swift
protocol ImageAnalyzer {
  var providerName: String { get }
  func analyze(image: UIImage) async throws -> AnalysisResult
}
```

#### ClaudeAnalyzer

- Uses Claude 3.5 Sonnet model
- Resizes images to 1024px for efficiency
- Sends as base64-encoded JPEG
- Returns natural language description

#### GeminiAnalyzer

- Uses Gemini 2.0 Flash model
- Similar image preprocessing
- Google's vision API format
- Fast and cost-effective

#### AnalysisViewModel

- Manages analyzer selection
- Handles API key loading
- Coordinates async analysis
- Error handling and state

## 🎨 UI/UX Features

- **Full-screen analysis overlay** with dark theme
- **Loading indicator** during analysis
- **Provider badge** showing which AI was used
- **Timestamp** for each analysis
- **Scrollable results** for long descriptions
- **Error alerts** with helpful messages
- **Smooth animations** and transitions

## 💰 Cost Estimates

### Claude (Anthropic)

- **Model**: claude-3-5-sonnet-20241022
- **Input**: ~$3 per 1M tokens
- **Output**: ~$15 per 1M tokens
- **Per Image**: ~$0.005 (half a cent)

### Gemini (Google)

- **Model**: gemini-2.0-flash-exp
- **Cost**: Free tier, then ~$0.075 per 1M tokens
- **Per Image**: ~$0.0001 (negligible)

> **Recommendation**: Start with Gemini for testing (free tier), use Claude for production quality.

## 🔒 Privacy & Security

### Data Flow

1. Photo captured on iPhone from glasses
2. Image resized locally (1024px max)
3. Sent via HTTPS to AI provider
4. Analysis returned as text
5. No data stored on Meta servers (beyond standard DAT operation)

### Best Practices

- ⚠️ **Never commit API keys** to version control
- Use environment variables for production
- Review AI provider privacy policies
- Inform users that images are sent to third parties
- Consider adding opt-in consent flow

### Provider Privacy

- [Anthropic Privacy Policy](https://www.anthropic.com/privacy)
- [Google Privacy Policy](https://policies.google.com/privacy)

## 🐛 Troubleshooting

### "No API keys configured"

**Solution**: Add at least one API key to Info.plist or environment variables, then rebuild.

### "API error: HTTP 401 Unauthorized"

**Causes**:
- Invalid or expired API key
- Key not copied correctly (check for extra spaces)
- Key not active in provider console

**Solution**: Regenerate key and update configuration.

### "Network error"

**Causes**:
- No internet connection
- Firewall blocking HTTPS
- VPN interfering

**Solution**: Check network, try different connection.

### Analysis Takes Too Long

**Causes**:
- Large image size
- Slow network
- API rate limiting

**Solution**: 
- App auto-resizes to 1024px
- Check network speed
- Wait for rate limit reset

### App Crashes on Analysis

**Causes**:
- Memory pressure from large images
- Invalid API response

**Solution**:
- Check Xcode console for errors
- Verify API key format
- Try different image

## 📊 Comparison: Android vs iOS

| Feature | Android APK | This iOS App |
|---------|------------|--------------|
| Live Streaming | ✅ 24 FPS, MEDIUM quality | ✅ 24 FPS, LOW quality |
| Photo Capture | ✅ | ✅ |
| Claude Analysis | ✅ | ✅ |
| Gemini Analysis | ✅ | ✅ |
| Provider Switching | ✅ | ✅ |
| Mock Device Kit | ✅ | ✅ (Debug builds) |
| UI Framework | Jetpack Compose | SwiftUI |
| Language | Kotlin | Swift |

## 🔧 Advanced Configuration

### Change Streaming Quality

Edit `StreamSessionViewModel.swift`:

```swift
let config = StreamSessionConfig(
  videoCodec: VideoCodec.raw,
  resolution: StreamingResolution.medium,  // low, medium, high
  frameRate: 30)  // 24 or 30
```

### Customize AI Prompts

Edit `ImageAnalyzer.swift` in each analyzer's `analyze()` method:

```swift
"text": "Your custom prompt here. Describe the image..."
```

### Add More AI Providers

1. Create new class conforming to `ImageAnalyzer`
2. Implement `analyze(image:)` method
3. Add to `AnalyzerProvider` enum
4. Update `AnalysisViewModel` initialization

## 📚 Resources

- [Meta Wearables DAT Docs](https://wearables.developer.meta.com/docs)
- [Claude API Docs](https://docs.anthropic.com/)
- [Gemini API Docs](https://ai.google.dev/docs)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)

## 🤝 Contributing

This is a sample app demonstrating Meta Wearables DAT integration. For production use:

1. Add proper error recovery
2. Implement retry logic
3. Add analytics/logging
4. Optimize image compression
5. Cache analysis results
6. Add user preferences
7. Implement rate limiting

## 📄 License

This sample code is licensed under the same license as the Meta Wearables Device Access Toolkit SDK. See the LICENSE file in the root directory.

---

**Built with**:
- Meta Wearables Device Access Toolkit 0.4.0
- Claude 3.5 Sonnet (Anthropic)
- Gemini 2.0 Flash (Google)
- SwiftUI & iOS 17+
