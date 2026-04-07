import 'package:flutter/widgets.dart';

/// Logical size of your UI design / Figma frame (width × height).
///
/// Adjust to match your mockups so [num.w], [num.h], [num.sp], [num.r] map correctly.
abstract final class AppDesignSize {
  AppDesignSize._();

  /// Default reference (e.g. iPhone 14 Pro width). Change if your team uses another artboard.
  static const Size canvas = Size(390, 844);
}
