# NSShield

NSShield is a lightweight Swift package that provides a specialized subclass of NSWindow designed to float over every space on macOS. It's perfect for creating notch apps, status bar utilities, and custom overlays that replicate system UI elements.

## Features

- **Cross-Space Visibility**: Windows appear on all macOS spaces
- **Always-On-Top**: Stays above other applications
- **Simple Integration**: Drop-in replacement for NSWindow
- **Minimal Footprint**: Single-file implementation

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file's dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/AlexStrNik/NSShield.git", from: "1.0.0")
]
```

Then include it in your target:

```swift
targets: [
    .target(
        name: "YourApp",
        dependencies: ["NSShield"]),
]
```

## Usage

```swift
import NSShield

// Create a shield window
let window = NSShield(
    contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
    styleMask: [.titled, .closable],
    backing: .buffered,
    defer: false
)

// Set up your window as needed
window.contentView = YourCustomView()

// Show the window - this automatically applies the shield properties
window.makeKeyAndOrderFront(nil)
```

## How It Works

NSShield leverages private CoreGraphics Space APIs to create a window that appears across all spaces and maintains its position above other windows. When `makeKeyAndOrderFront(_:)` is called, NSShield automatically applies the necessary properties to make the window float across spaces.

## Inspiration

NSShield was inspired by [SketchyBar](https://github.com/FelixKratz/SketchyBar), a customizable macOS status bar replacement.

## Disclaimer

This package uses private macOS APIs which are not officially supported by Apple. While it works with current macOS versions, future updates might break functionality. Use in production applications at your own risk.
