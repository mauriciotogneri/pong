import 'package:flutter/foundation.dart';

class Platform {
  static final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;

  static final bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;

  static final bool isWindows = defaultTargetPlatform == TargetPlatform.windows;

  static final bool isLinux = defaultTargetPlatform == TargetPlatform.linux;

  static final bool isMac = defaultTargetPlatform == TargetPlatform.macOS;

  static const bool isWeb = kIsWeb;

  static final bool isMobile = isAndroid || isIOS;

  static final bool isDesktop =
      !isAndroid && !isIOS && (isWindows || isLinux || isMac);

  static final bool isDesktopWeb = isDesktop && isWeb;

  static final bool isDesktopNative = isDesktop && !isWeb;

  static final bool isMobileWeb = isMobile && isWeb;

  static final bool isMobileNative = isMobile && !isWeb;
}
