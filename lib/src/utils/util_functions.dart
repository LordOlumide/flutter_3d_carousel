import 'dart:math' as math;

/// A collection of utility functions for common mathematical and color operations.
///
/// This class provides static helper methods:
abstract class UtilFunctions {
  /// Converts radians to degrees.
  static double inDegrees(double radian) {
    return radian * 180 / math.pi;
  }

  /// Converts degrees to radians.
  static double inRadian(double degree) {
    return degree * math.pi / 180;
  }

  /// Ensures an angle in radians stays within the range 0 to math.pi * 2.
  static double normalizeDegreeInRadians(double degree) {
    return degree % (2 * math.pi);
  }
}
