# Quick Start Checklist ✅

Get your AI-enhanced CameraAccess app running in **15 minutes**.

## Prerequisites

- [ ] Mac with Xcode 14+ installed
- [ ] iPhone with iOS 17+
- [ ] Meta smart glasses (Ray-Ban Meta or Oakley Meta HST)
- [ ] Meta AI app installed on iPhone
- [ ] At least one AI API key (Claude or Gemini)

---

## Step 1: Get API Keys (5 min)

### Option A: Claude (Anthropic)
1. Go to https://console.anthropic.com/
2. Sign up or log in
3. Navigate to **API Keys**
4. Click **Create Key**
5. Copy key (starts with `sk-ant-...`)

### Option B: Gemini (Google)
1. Go to https://aistudio.google.com/apikey
2. Sign in with Google
3. Click **Get API key**
4. Copy key

---

## Step 2: Open Project (1 min)

```bash
cd "f:/Meta project/meta-wearables-dat-ios/samples/CameraAccess"
open CameraAccess.xcodeproj
```

Wait for Xcode to open and resolve packages.

---

## Step 3: Add Files to Xcode (3 min)

### Create Services Folder
1. Right-click **CameraAccess** folder in Project Navigator
2. **New Group** → Name it `Services`

### Add ImageAnalyzer.swift
1. Right-click **Services** folder
2. **Add Files to "CameraAccess"...**
3. Select `CameraAccess/Services/ImageAnalyzer.swift`
4. Uncheck "Copy items if needed"
5. Check "CameraAccess" target
6. **Add**

### Add AnalysisViewModel.swift
1. Right-click **ViewModels** folder
2. **Add Files to "CameraAccess"...**
3. Select `CameraAccess/ViewModels/AnalysisViewModel.swift`
4. **Add**

### Add AnalysisOverlay.swift
1. Right-click **Views/Components** folder
2. **Add Files to "CameraAccess"...**
3. Select `CameraAccess/Views/Components/AnalysisOverlay.swift`
4. **Add**

---

## Step 4: Configure API Keys (2 min)

### Method 1: Info.plist (Quick)

1. Open `CameraAccess/Info.plist`
2. Add before `</dict>`:

```xml
<key>CLAUDE_API_KEY</key>
<string>YOUR_CLAUDE_KEY_HERE</string>
<key>GEMINI_API_KEY</key>
<string>YOUR_GEMINI_KEY_HERE</string>
```

### Method 2: Environment Variables (Recommended)

1. **Product → Scheme → Edit Scheme...**
2. **Run → Arguments → Environment Variables**
3. Click **+** and add:
   - Name: `CLAUDE_API_KEY`, Value: `your_key`
   - Name: `GEMINI_API_KEY`, Value: `your_key`

---

## Step 5: Configure Signing (1 min)

1. Select **CameraAccess** target
2. **Signing & Capabilities** tab
3. Choose your **Team**
4. Xcode auto-generates Bundle ID

---

## Step 6: Build & Run (1 min)

1. Connect your iPhone via cable
2. Select iPhone as run destination (top toolbar)
3. Press **⌘R** or click **Run** ▶️
4. Wait for build and install

---

## Step 7: Enable Developer Mode (1 min)

**On iPhone:**
1. Open **Meta AI** app
2. Go to **Settings**
3. Find **Developer Mode**
4. Toggle **ON**

---

## Step 8: Pair Glasses (1 min)

**In CameraAccess app:**
1. Tap **"Connect my glasses"**
2. Follow Meta AI app flow
3. Approve connection
4. Return to CameraAccess

---

## Step 9: Test Streaming (30 sec)

1. Tap **"Start streaming"**
2. Grant camera permission
3. See live video from glasses
4. Tap camera button to capture

---

## Step 10: Test AI Analysis (30 sec)

1. After capturing photo, tap **"Analyze"**
2. Select AI provider (Claude or Gemini)
3. Tap **"Analyze with [Provider]"**
4. Wait 2-5 seconds
5. View AI description

---

## ✅ Success!

You now have a working AI-enhanced camera app for Meta smart glasses!

---

## Troubleshooting

### Build Fails
- **Clean**: Product → Clean Build Folder (⇧⌘K)
- **Packages**: File → Packages → Resolve Package Versions
- **Rebuild**: ⌘B

### "No API keys configured"
- Check Info.plist or environment variables
- Rebuild after adding keys

### Glasses Won't Connect
- Enable Developer Mode in Meta AI app
- Pair glasses in Meta AI app first
- Restart both apps

### Analysis Fails
- Check internet connection
- Verify API key is valid
- Try different provider

---

## Next Steps

- **Read full docs**: `README_AI_ENHANCED.md`
- **Customize**: Change streaming quality, AI prompts
- **Deploy**: Build for TestFlight or App Store

---

## Quick Reference

| Action | Shortcut |
|--------|----------|
| Build | ⌘B |
| Run | ⌘R |
| Clean | ⇧⌘K |
| Stop | ⌘. |

**Need help?** Check `SUMMARY.md` for detailed information.
