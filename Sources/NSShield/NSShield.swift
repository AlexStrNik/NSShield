import AppKit

/// NSShield is a specialized NSWindow subclass that floats over every space on macOS.
///
/// This window type is designed for creating UI elements that need to be visible across
/// all spaces, such as notch apps, status bar utilities, and custom overlays that
/// replicate system UI elements.
///
/// Usage:
/// ```swift
/// let window = NSShield(
///     contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
///     styleMask: [.titled, .closable],
///     backing: .buffered,
///     defer: false
/// )
/// window.contentView = YourCustomView()
/// window.makeKeyAndOrderFront(nil) // This automatically applies the shield properties
/// ```
open class NSShield: NSWindow {
  /// Creates a new NSShield window.
  ///
  /// - Parameters:
  ///   - contentRect: The initial content rectangle for the window.
  ///   - style: The window style mask.
  ///   - backingStore: The backing store type for the window.
  ///   - flag: A Boolean value that specifies whether window creation should be deferred.
  override init(
    contentRect: NSRect, styleMask style: NSWindow.StyleMask,
    backing backingStore: NSWindow.BackingStoreType, defer flag: Bool
  ) {
    super.init(contentRect: contentRect, styleMask: style, backing: backingStore, defer: flag)
  }

  /// Makes the window key and visible, and applies the shield properties.
  ///
  /// This override ensures that whenever the window is made visible, it automatically
  /// becomes a shield window that floats over all spaces.
  ///
  /// - Parameter sender: The object that sent the message.
  open override func makeKeyAndOrderFront(_ sender: Any?) {
    super.makeKeyAndOrderFront(sender)
    makeShield()
  }
}

extension NSShield {
  /// Applies the shield properties to the window.
  ///
  /// This method:
  /// 1. Sets the window level to floating
  /// 2. Creates a special space for the window
  /// 3. Configures the window to appear across all spaces
  ///
  /// This is automatically called when the window is made visible.
  public func makeShield() {
    self.level = .floating
    let spaceId = CGSSpaceCreate(
      _CGSDefaultConnection(),
      1,
      nil
    )
    CGSSpaceSetAbsoluteLevel(
      _CGSDefaultConnection(),
      spaceId,
      0
    )
    CGSShowSpaces(
      _CGSDefaultConnection(),
      [spaceId]
    )
    CGSSpaceAddWindowsAndRemoveFromSpaces(
      _CGSDefaultConnection(),
      spaceId,
      [self.windowNumber],
      -1
    )
  }
}

// MARK: - Private CoreGraphics Space API

/// Type aliases for the private CoreGraphics Space API
private typealias CGSConnectionID = UInt
private typealias CGSSpaceID = UInt64

@_silgen_name("_CGSDefaultConnection")
private func _CGSDefaultConnection() -> CGSConnectionID

@_silgen_name("CGSSpaceCreate")
private func CGSSpaceCreate(_ cid: CGSConnectionID, _ unknown: Int, _ options: NSDictionary?)
  -> CGSSpaceID

@_silgen_name("CGSSpaceSetAbsoluteLevel")
private func CGSSpaceSetAbsoluteLevel(_ cid: CGSConnectionID, _ space: CGSSpaceID, _ level: Int)

@_silgen_name("CGSSpaceAddWindowsAndRemoveFromSpaces")
private func CGSSpaceAddWindowsAndRemoveFromSpaces(
  _ cid: CGSConnectionID, _ space: CGSSpaceID, _ windows: NSArray, _ selector: Int)

@_silgen_name("CGSShowSpaces")
private func CGSShowSpaces(_ cid: CGSConnectionID, _ spaces: NSArray)
