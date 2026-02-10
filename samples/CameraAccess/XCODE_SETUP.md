# Adding AI Analysis Files to Xcode Project

Follow these steps to add the new AI analysis files to your CameraAccess Xcode project.

## Files to Add

You have 4 new files to add:

1. `Services/ImageAnalyzer.swift`
2. `ViewModels/AnalysisViewModel.swift`
3. `Views/Components/AnalysisOverlay.swift`
4. Modified: `Views/PhotoPreviewView.swift` (already updated)

## Step-by-Step Instructions

### 1. Open Xcode Project

```bash
cd "f:/Meta project/meta-wearables-dat-ios/samples/CameraAccess"
open CameraAccess.xcodeproj
```

### 2. Create Services Folder

1. In Xcode's **Project Navigator** (left sidebar)
2. Right-click on **CameraAccess** folder (blue icon)
3. Select **New Group**
4. Name it `Services`

### 3. Add ImageAnalyzer.swift

1. Right-click on the new **Services** folder
2. Select **Add Files to "CameraAccess"...**
3. Navigate to: `CameraAccess/Services/ImageAnalyzer.swift`
4. Ensure **"Copy items if needed"** is **unchecked** (file is already in correct location)
5. Ensure **"CameraAccess" target** is **checked**
6. Click **Add**

### 4. Add AnalysisViewModel.swift

1. Right-click on **ViewModels** folder
2. Select **Add Files to "CameraAccess"...**
3. Navigate to: `CameraAccess/ViewModels/AnalysisViewModel.swift`
4. Ensure target is checked
5. Click **Add**

### 5. Add AnalysisOverlay.swift

1. Right-click on **Views/Components** folder
2. Select **Add Files to "CameraAccess"...**
3. Navigate to: `CameraAccess/Views/Components/AnalysisOverlay.swift`
4. Ensure target is checked
5. Click **Add**

### 6. Verify File Structure

Your project structure should now look like:

```
CameraAccess/
├── CameraAccessApp.swift
├── Services/                          ← NEW
│   └── ImageAnalyzer.swift           ← NEW
├── ViewModels/
│   ├── WearablesViewModel.swift
│   ├── StreamSessionViewModel.swift
│   ├── AnalysisViewModel.swift       ← NEW
│   └── ...
├── Views/
│   ├── Components/
│   │   ├── AnalysisOverlay.swift     ← NEW
│   │   ├── PhotoPreviewView.swift    ← MODIFIED
│   │   └── ...
│   └── ...
└── Info.plist                         ← MODIFIED
```

### 7. Build the Project

1. Press **⌘B** or **Product → Build**
2. Fix any errors (should compile cleanly)

## Common Issues

### "No such module 'MWDATCamera'"

**Solution**: The Meta Wearables DAT package isn't resolved.

1. **File → Packages → Resolve Package Versions**
2. Wait for Swift Package Manager to fetch dependencies
3. Rebuild

### "Cannot find 'ImageAnalyzer' in scope"

**Solution**: File not added to target.

1. Select `ImageAnalyzer.swift` in Project Navigator
2. Open **File Inspector** (right sidebar, first tab)
3. Under **Target Membership**, check **CameraAccess**

### Build Errors in PhotoPreviewView

**Solution**: Missing import or file not updated.

1. Ensure `PhotoPreviewView.swift` has the updated code
2. Check that all new files are added to the project
3. Clean build folder: **Product → Clean Build Folder** (⇧⌘K)
4. Rebuild

## Next Steps

After successfully building:

1. **Configure API Keys** (see `AI_SETUP.md`)
2. **Run on Device** (iOS Simulator won't work - needs real iPhone)
3. **Pair Your Glasses** via Meta AI app
4. **Test AI Analysis** by capturing and analyzing photos

## Alternative: Manual File Creation

If you prefer to create files manually in Xcode:

### For Each File:

1. Right-click on appropriate folder
2. Select **New File...**
3. Choose **Swift File**
4. Name it (e.g., `ImageAnalyzer.swift`)
5. Ensure **CameraAccess** target is checked
6. Click **Create**
7. Copy-paste the code from the provided files

## Verification Checklist

- [ ] All 3 new files appear in Project Navigator
- [ ] All files have **CameraAccess** target membership
- [ ] `PhotoPreviewView.swift` is updated
- [ ] `Info.plist` has API key placeholders
- [ ] Project builds without errors (⌘B)
- [ ] No compiler warnings related to new files

## Need Help?

If you encounter issues:

1. Check Xcode's **Issue Navigator** (⌘5) for detailed errors
2. Verify file paths match the structure above
3. Ensure you're using Xcode 14+ and iOS 17+ SDK
4. Try cleaning derived data: **Product → Clean Build Folder**

---

**Ready to test?** See `README_AI_ENHANCED.md` for usage instructions!
