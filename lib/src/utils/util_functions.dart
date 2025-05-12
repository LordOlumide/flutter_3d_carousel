import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A collection of utility functions for common mathematical and color operations.
///
/// This class provides static helper methods for:
/// - Angle unit conversions (degrees/radians)
/// - Color contrast calculations
abstract class UtilFunctions {
  /// Converts radians to degrees.
  ///
  /// Example:
  /// ```dart
  /// final degrees = UtilFunctions.inDegrees(math.pi); // Returns 180.0
  /// ```
  ///
  /// [radian] - The angle in radians (0 to 2π)
  /// Returns the equivalent angle in degrees (0 to 360)
  static double inDegrees(double radian) {
    return radian * 180 / math.pi;
  }

  /// Converts degrees to radians.
  ///
  /// Example:
  /// ```dart
  /// final radians = UtilFunctions.inRadian(180); // Returns π (~3.1416)
  /// ```
  ///
  /// [degree] - The angle in degrees (0 to 360)
  /// Returns the equivalent angle in radians (0 to 2π)
  static double inRadian(double degree) {
    return degree * math.pi / 180;
  }

  /// Determines an appropriate contrasting text color for a given background color.
  ///
  /// Uses luminance calculation to determine whether black or white
  /// would provide better contrast against the background color.
  ///
  /// Example:
  /// ```dart
  /// final textColor = UtilFunctions.getContrastingColor(Colors.blue);
  /// ```
  ///
  /// [background] - The background color to contrast against
  /// Returns [Colors.black] for light backgrounds, [Colors.white] for dark
  static Color getContrastingColor(Color background) {
    final luminance = background.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Determines the reverse contrasting color of [getContrastingColor].
  ///
  /// Returns white for light backgrounds and black for dark backgrounds,
  /// which is the opposite of [getContrastingColor].
  ///
  /// Useful when you need an alternative contrasting color scheme.
  ///
  /// Example:
  /// ```dart
  /// final altColor = UtilFunctions.getReverseContrastingColor(Colors.blue);
  /// ```
  static Color getReverseContrastingColor(Color background) {
    final luminance = background.computeLuminance();
    return luminance > 0.5 ? Colors.white : Colors.black;
  }
}
