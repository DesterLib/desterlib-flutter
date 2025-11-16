import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  // Minimum window size to avoid mobile UI
  private let minimumWindowSize = NSSize(width: 1200, height: 800)
  
  override func awakeFromNib() {
    // Set minimum size first, before any frame operations
    self.minSize = minimumWindowSize
    
    let flutterViewController = FlutterViewController()
    var windowFrame = self.frame
    
    // Ensure the window frame respects the minimum size
    if windowFrame.width < minimumWindowSize.width {
      windowFrame.size.width = minimumWindowSize.width
    }
    if windowFrame.height < minimumWindowSize.height {
      windowFrame.size.height = minimumWindowSize.height
    }
    
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
  
  override func setFrame(_ frameRect: NSRect, display flag: Bool) {
    // Enforce minimum size when frame is set (including on restore)
    var adjustedFrame = frameRect
    if adjustedFrame.width < minimumWindowSize.width {
      adjustedFrame.size.width = minimumWindowSize.width
    }
    if adjustedFrame.height < minimumWindowSize.height {
      adjustedFrame.size.height = minimumWindowSize.height
    }
    super.setFrame(adjustedFrame, display: flag)
  }
}
