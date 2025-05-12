import 'dart:math' as math;

import 'package:flutter/material.dart';

abstract class UtilFunctions {
  static double inDegrees(double radian) {
    return radian * 180 / math.pi;
  }

  static double inRadian(double degree) {
    return degree * math.pi / 180;
  }

  static bool isBetween90And270Degrees(double angle) {
    return angle > 90 && angle < 270;
  }

  static bool isBetween90And270DegreesRad(double angleInRad) {
    return angleInRad >= (math.pi / 2) && angleInRad <= (3 * math.pi / 2);
  }

  static Color getContrastingColor(Color background) {
    // Calculate luminance (0.0 to 1.0)
    final luminance = background.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  static Color getReverseContrastingColor(Color background) {
    final luminance = background.computeLuminance();
    return luminance > 0.5 ? Colors.white : Colors.black;
  }
}
