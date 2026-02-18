# ScreenText

A minimal macOS menu bar application that captures a screen region, extracts text via OCR, and copies it to the clipboard.

![macOS](https://img.shields.io/badge/macOS-13.0+-blue)
![Swift](https://img.shields.io/badge/Swift-5.0-orange)
![License](https://img.shields.io/badge/License-MIT-green)

## Features

- **Menu Bar App** - Lives in the menu bar with a clean icon, no dock clutter
- **Screen Capture** - Select any region on screen with click and drag
- **OCR Processing** - Extract text using Apple's Vision framework
- **Multi-Language** - Supports Korean and English text recognition
- **Clipboard Integration** - Automatically copies extracted text to clipboard
- **Notifications** - Shows confirmation when text is captured

## Requirements

- macOS 13.0 (Ventura) or later
- Xcode 15.0 or later (for building from source)

## Installation

### Option 1: Build from Source

1. **Clone the repository**
   ```bash
   git clone https://github.com/hugehoo/ScreenText.git
   cd ScreenText
   ```

2. **Build the app**
   ```bash
   xcodebuild -project ScreenText.xcodeproj -scheme ScreenText -configuration Release build
   ```

3. **Copy to Applications**
   ```bash
   cp -R ~/Library/Developer/Xcode/DerivedData/ScreenText-*/Build/Products/Release/ScreenText.app /Applications/
   ```

4. **Sign the app** (required for permissions)
   ```bash
   codesign --force --deep --sign - /Applications/ScreenText.app
   ```

5. **Launch**
   ```bash
   open /Applications/ScreenText.app
   ```

### Option 2: Open in Xcode

1. Open `ScreenText.xcodeproj` in Xcode
2. Select **Product → Run** (or press `⌘R`)
3. The app will appear in your menu bar

## Setup Permissions

ScreenText requires **Screen Recording** permission to capture screen content.

### First-Time Setup

1. Launch ScreenText
2. Click the menu bar icon → **Capture Text**
3. macOS will prompt for Screen Recording permission
4. Click **Open System Settings**
5. In **Privacy & Security → Screen Recording**:
   - Click the **+** button
   - Navigate to `/Applications/ScreenText.app`
   - Add and enable it
6. **Quit and relaunch** ScreenText (required for permission to take effect)

### Troubleshooting Permissions

If capture doesn't work:

1. Go to **System Settings → Privacy & Security → Screen Recording**
2. Find ScreenText in the list
3. Toggle it **OFF**, then **ON** again
4. Quit ScreenText completely: `pkill -x ScreenText`
5. Relaunch: `open /Applications/ScreenText.app`

> **Note**: If you rebuild the app, you may need to re-grant permissions as the app signature changes.

## Usage

### Capture Text

1. Click the **ScreenText icon** in the menu bar (looks like: 📄🔍)
2. Click **"Capture Text"**
3. Your cursor changes to a crosshair
4. **Click and drag** to select the area containing text
5. Release the mouse button
6. The extracted text is automatically copied to your clipboard
7. **Paste** (`⌘V`) anywhere to use the text

### Tips

- Select a clean area around the text for better recognition
- Works best with clear, high-contrast text
- Supports both horizontal and vertical text layouts

## Project Structure

```
ScreenText/
├── ScreenText.xcodeproj/
│   └── project.pbxproj
├── ScreenText/
│   ├── ScreenTextApp.swift      # Main app entry, menu bar setup
│   ├── AppDelegate.swift        # App lifecycle, hotkey registration
│   ├── ScreenCapture.swift      # Screen capture using screencapture tool
│   ├── OCRProcessor.swift       # Vision framework OCR processing
│   ├── ClipboardManager.swift   # Pasteboard operations
│   ├── NotificationManager.swift # User notifications
│   ├── Info.plist               # App configuration
│   ├── ScreenText.entitlements  # App entitlements
│   └── Assets.xcassets/         # App icons
├── .gitignore
└── README.md
```

## Technology Stack

| Component | Technology |
|-----------|------------|
| Language | Swift 5 |
| UI Framework | SwiftUI + AppKit |
| OCR Engine | Vision Framework |
| Screen Capture | macOS `screencapture` CLI |
| Notifications | UserNotifications |

## Supported Languages

- English (en-US)
- Korean (ko-KR)

To add more languages, edit `OCRProcessor.swift`:
```swift
request.recognitionLanguages = ["ko-KR", "en-US", "ja-JP", "zh-Hans"]
```

## Development

### Building for Debug

```bash
xcodebuild -project ScreenText.xcodeproj -scheme ScreenText -configuration Debug build
```

### Building for Release

```bash
xcodebuild -project ScreenText.xcodeproj -scheme ScreenText -configuration Release build
```

### Quick Deploy Script

```bash
# Kill existing app
pkill -x ScreenText

# Build
xcodebuild -project ScreenText.xcodeproj -scheme ScreenText -configuration Debug build

# Deploy
rm -rf /Applications/ScreenText.app
cp -R ~/Library/Developer/Xcode/DerivedData/ScreenText-*/Build/Products/Debug/ScreenText.app /Applications/

# Sign
codesign --force --deep --sign - /Applications/ScreenText.app

# Launch
open /Applications/ScreenText.app
```

## Known Issues

1. **Permission prompt on every rebuild**: Since the app is ad-hoc signed, macOS treats each build as a new app. You may need to re-grant Screen Recording permission after rebuilding.

2. **Metal warnings in console**: You may see Metal-related warnings in the Xcode console. These are harmless and don't affect functionality.

## Future Enhancements

- [ ] Global hotkey support (⌘⇧2)
- [ ] Settings window for language selection
- [ ] History of captured text
- [ ] Auto-start at login
- [ ] Customizable hotkeys

## License

MIT License - feel free to use and modify.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
