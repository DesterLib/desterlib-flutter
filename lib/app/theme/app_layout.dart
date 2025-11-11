/// Layout breakpoints for responsive design
class AppBreakpoints {
  AppBreakpoints._();

  /// Breakpoint for desktop layout (sidebar visible)
  static const double desktop = 900.0;

  /// Helper to check if current width is desktop
  static bool isDesktop(double width) => width > desktop;

  /// Helper to check if current width is mobile
  static bool isMobile(double width) => width <= desktop;
}

/// Layout dimensions and constants
class AppLayout {
  AppLayout._();

  /// Sidebar width on desktop
  static const double sidebarWidth = 324.0;

  /// Bottom navigation bar height on mobile
  static const double bottomNavBarHeight = 80.0;

  /// App bar height (compact)
  static const double appBarHeightCompact = 80.0;

  /// App bar height (regular)
  static const double appBarHeightRegular = 120.0;

  /// Default horizontal padding on desktop (after sidebar)
  static const double desktopHorizontalPadding = 44.0;

  /// Default horizontal padding on mobile
  static const double mobileHorizontalPadding = 24.0;

  /// Extra large padding (40px)
  static const double extraLargePadding = 40.0;
}

/// Card and media item dimensions
class AppCardSize {
  AppCardSize._();

  /// Desktop card width
  static const double desktopWidth = 320.0;

  /// Mobile card width
  static const double mobileWidth = 200.0;

  /// Card aspect ratio (width:height)
  static const double aspectRatio = 16 / 10;

  /// Get card height based on width
  static double getHeight(double width) => width * 10 / 16;
}

/// Aspect ratios for different media types
class AppAspectRatio {
  AppAspectRatio._();

  /// Standard poster aspect ratio (portrait)
  static const double poster = 2 / 3;

  /// Standard backdrop aspect ratio (landscape)
  static const double backdrop = 16 / 9;

  /// Card aspect ratio
  static const double card = 16 / 10;
}
