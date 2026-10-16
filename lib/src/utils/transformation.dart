import 'dart:math' as math;

import 'package:vector_math/vector_math_64.dart' as vector_math;

/// The naming here is [column number][row number].
///
abstract class Transformation {
  static vector_math.Matrix3 getTransformationMatrix({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return vector_math.Matrix3(
      Transformation.get00(
        rollAngle: rollAngle,
        pitchAngle: pitchAngle,
        yawAngle: yawAngle,
      ),
      Transformation.get01(
        rollAngle: rollAngle,
        pitchAngle: pitchAngle,
        yawAngle: yawAngle,
      ),
      Transformation.get02(
        rollAngle: rollAngle,
        pitchAngle: pitchAngle,
        yawAngle: yawAngle,
      ),
      Transformation.get10(
        rollAngle: rollAngle,
        pitchAngle: pitchAngle,
        yawAngle: yawAngle,
      ),
      Transformation.get11(
        rollAngle: rollAngle,
        pitchAngle: pitchAngle,
        yawAngle: yawAngle,
      ),
      Transformation.get12(
        rollAngle: rollAngle,
        pitchAngle: pitchAngle,
        yawAngle: yawAngle,
      ),
      Transformation.get20(
        rollAngle: rollAngle,
        pitchAngle: pitchAngle,
        yawAngle: yawAngle,
      ),
      Transformation.get21(
        rollAngle: rollAngle,
        pitchAngle: pitchAngle,
        yawAngle: yawAngle,
      ),
      Transformation.get22(
        rollAngle: rollAngle,
        pitchAngle: pitchAngle,
        yawAngle: yawAngle,
      ),
    );
  }

  /// Column 0, Row 0
  static double get00({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return (math.cos(yawAngle) * math.cos(rollAngle)) -
        (math.sin(yawAngle) * math.cos(pitchAngle) * math.sin(rollAngle));
  }

  /// Column 0, Row 1
  static double get01({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return math.sin(pitchAngle) * math.sin(rollAngle);
  }

  /// Column 0, Row 2
  static double get02({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return (math.sin(yawAngle) * math.cos(rollAngle)) +
        (math.cos(yawAngle) * math.cos(pitchAngle) * math.sin(rollAngle));
  }

  /// Column 1, Row 0
  static double get10({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return math.sin(yawAngle) * math.sin(pitchAngle);
  }

  /// Column 1, Row 1
  static double get11({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return math.cos(pitchAngle);
  }

  /// Column 1, Row 2
  static double get12({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return -(math.cos(yawAngle) * math.sin(pitchAngle));
  }

  /// Column 2, Row 0
  static double get20({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return -(math.cos(yawAngle) * math.sin(rollAngle)) -
        (math.sin(yawAngle) * math.cos(pitchAngle) * math.cos(rollAngle));
  }

  /// Column 2, Row 1
  static double get21({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return math.sin(pitchAngle) * math.cos(rollAngle);
  }

  /// Column 2, Row 2
  static double get22({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return -(math.sin(yawAngle) * math.sin(rollAngle)) +
        (math.cos(yawAngle) * math.cos(pitchAngle) * math.cos(rollAngle));
  }
}
