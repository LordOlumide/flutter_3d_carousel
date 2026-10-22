import 'dart:math' as math;

import 'package:flutter_3d_carousel/flutter_3d_carousel.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

/// The naming here is [column number][row number].
///
sealed class Transformations {
  /// This is the transformation that corresponds to [ChildOrientation.backingCenter].
  static vector_math.Matrix3 transformation1({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    final double cr = math.cos(rollAngle);
    final double sr = math.sin(rollAngle);
    final double cp = math.cos(pitchAngle);
    final double sp = math.sin(pitchAngle);
    final double cy = math.cos(yawAngle);
    final double sy = math.sin(yawAngle);

    final double _00 = (cy * cr) - (sy * cp * sr);
    final double _01 = sp * sr;
    final double _02 = (sy * cr) + (cy * cp * sr);
    final double _10 = sy * sp;
    final double _11 = cp;
    final double _12 = -(cy * sp);
    final double _20 = -(cy * sr) - (sy * cp * cr);
    final double _21 = sp * cr;
    final double _22 = -(sy * sr) + (cy * cp * cr);

    return vector_math.Matrix3(_00, _01, _02, _10, _11, _12, _20, _21, _22);
  }

  /// This is the transformation that corresponds to [OrientedWithXTilt].
  ///
  /// It rotates the children in the X axis before applying [transformation1].
  static vector_math.Matrix3 transformation2({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
    double a = math.pi / 2,
  }) {
    final double cr = math.cos(rollAngle);
    final double sr = math.sin(rollAngle);
    final double cp = math.cos(pitchAngle);
    final double sp = math.sin(pitchAngle);
    final double cy = math.cos(yawAngle);
    final double sy = math.sin(yawAngle);
    final double sa = math.sin(a);
    final double ca = math.cos(a);

    final double _00 = (cy * cr) - (sy * cp * sr);
    final double _01 = sp * sr;
    final double _02 = (sy * cr) + (cy * cp * sr);
    final double _10 = (sy * sp * ca) - (cy * sr * sa) - (sy * cp * cr * sa);
    final double _11 = (cp * ca) + (sp * cr * sa);
    final double _12 = -(cy * sp * ca) - (sy * sr * sa) + (cy * cp * cr * sa);
    final double _20 = -(sy * sp * sa) - (cy * sr * ca) - (sy * cp * cr * ca);
    final double _21 = -(cp * sa) + (sp * cr * ca);
    final double _22 = (cy * sp * sa) - (sy * sr * ca) + (cy * cp * cr * ca);

    return vector_math.Matrix3(_00, _01, _02, _10, _11, _12, _20, _21, _22);
  }

  /// This is the transformation that corresponds to [OrientedWithYTilt].
  ///
  /// It rotates the children in the Y axis before applying [transformation1].
  static vector_math.Matrix3 transformation3({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
    double a = math.pi / 2,
  }) {
    final double cr = math.cos(rollAngle);
    final double sr = math.sin(rollAngle);
    final double cp = math.cos(pitchAngle);
    final double sp = math.sin(pitchAngle);
    final double cy = math.cos(yawAngle);
    final double sy = math.sin(yawAngle);
    final double sa = math.sin(a);
    final double ca = math.cos(a);

    final double _00 = (cy * cr * ca) -
        (sy * cp * sr * ca) -
        (cy * sr * sa) -
        (sy * cp * cr * sa);
    final double _01 = (sp * sr * ca) + (sp * cr * sa);
    final double _02 = (sy * cr * ca) +
        (cy * cp * sr * ca) -
        (sy * sr * sa) -
        (cy * cp * cr * sa);
    final double _10 = sy * sp;
    final double _11 = cp;
    final double _12 = -(cy * sp);
    final double _20 = -(cy * cr * sa) +
        (sy * cp * sr * sa) -
        (cy * sr * ca) -
        (sy * cp * cr * ca);
    final double _21 = -(sp * sr * sa) + (sp * sr * ca);
    final double _22 = -(sy * cr * sa) -
        (cy * cp * sr * sa) -
        (sy * sr * ca) +
        (sy * cp * cr * ca);

    return vector_math.Matrix3(_00, _01, _02, _10, _11, _12, _20, _21, _22);
  }

  /// This is the transformation that corresponds to [OrientedWithZTilt].
  ///
  /// It rotates the children in the Z axis before applying [transformation1].
  static vector_math.Matrix3 transformation4({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
    double a = math.pi / 2,
  }) {
    final double cr = math.cos(rollAngle);
    final double sr = math.sin(rollAngle);
    final double cp = math.cos(pitchAngle);
    final double sp = math.sin(pitchAngle);
    final double cy = math.cos(yawAngle);
    final double sy = math.sin(yawAngle);
    final double sa = math.sin(a);
    final double ca = math.cos(a);

    final double _00 = (cy * cr * ca) - (sy * cp * sr * ca) + (sy * sp * sa);
    final double _01 = (sp * sr * ca) + (cp * sa);
    final double _02 = (sy * cr * ca) + (cy * cp * sr * ca) - (cy * sp * sa);
    final double _10 = -(cy * cr * sa) + (sy * cp * sr * sa) + (sy * sp * ca);
    final double _11 = -(sp * sr * sa) + (cp * ca);
    final double _12 = -(sy * cr * sa) - (cy * cp * sr * sa) - (cy * sp * ca);
    final double _20 = -(cy * sr) - (sy * cp * cr);
    final double _21 = sp * cr;
    final double _22 = -(sy * sr) + (cy * cp * cr);

    return vector_math.Matrix3(_00, _01, _02, _10, _11, _12, _20, _21, _22);
  }
}
