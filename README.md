# NSShield

**NSShield** is a lightweight Swift package that provides a specialized subclass of `NSWindow`, designed to float *above* every space on macOS. It’s perfect for creating notch apps, status bar utilities, and custom overlays that mimic system UI elements.

## Features

**Truly floats above all spaces** — unlike `canJoinAllSpaces`, which simply makes a window *jump between* spaces as you switch, NSShield places the window in an unmanaged space that literally stays above all others. This makes it ideal for HUDs and overlays that should remain visible at all times.

## Installation

### Swift Package Manager

Add the following to your `Package.swift` dependencies:

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
        dependencies: ["NSShield"]
    ),
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

// Just like a regular NSWindow
window.makeKeyAndOrderFront(nil) // This also applies the shield behavior
```

## How It Works

NSShield leverages private CoreGraphics space APIs to create an **unmanaged space**, position it *above* all standard (managed) spaces — like the ones shown in Mission Control — and move your window into it. This all happens automatically when you call `makeKeyAndOrderFront(_:)`, or manually via the `makeShield()` method.

## Inspiration

NSShield was inspired by [SketchyBar](https://github.com/FelixKratz/SketchyBar), a customizable macOS status bar replacement, and by my own project [OverAll](https://github.com/AlexStrNik/OverAll), which brings similar functionality to any window from any app.

## Disclaimer

This package uses **private macOS APIs**, which are not officially supported by Apple. While it works on current macOS versions, future updates may break its functionality. Use in production at your own risk.
