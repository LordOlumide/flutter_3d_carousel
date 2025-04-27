import 'dart:math' as math;

abstract class UtilFunctions {
  static bool isBetween90And270Degrees(double angle) {
    return angle >= (math.pi / 2) && angle <= (3 * math.pi / 2);
  }
}
