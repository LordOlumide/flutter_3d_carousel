import 'dart:math' as math;

import 'package:flutter_3d_carousel/flutter_3d_carousel.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

/// The naming here is [column number][row number].
///
sealed class Transformations {
  /// The translation of the objects in the carousel is represented by the
  /// last column of [transformation1].
  static vector_math.Vector3 positionTransformation({
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

    final double e_20 = -(cy * sr) - (sy * cp * cr);
    final double e_21 = sp * cr;
    final double e_22 = -(sy * sr) + (cy * cp * cr);

    return vector_math.Vector3(e_20, e_21, e_22);
  }

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

    final double e_00 = (cy * cr) - (sy * cp * sr);
    final double e_01 = sp * sr;
    final double e_02 = (sy * cr) + (cy * cp * sr);
    final double e_10 = sy * sp;
    final double e_11 = cp;
    final double e_12 = -(cy * sp);
    final double e_20 = -(cy * sr) - (sy * cp * cr);
    final double e_21 = sp * cr;
    final double e_22 = -(sy * sr) + (cy * cp * cr);

    return vector_math.Matrix3(e_00, e_01, e_02, e_10, e_11, e_12, e_20, e_21, e_22);
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

    final double e_00 = (cy * cr) - (sy * cp * sr);
    final double e_01 = sp * sr;
    final double e_02 = (sy * cr) + (cy * cp * sr);
    final double e_10 = (sy * sp * ca) - (cy * sr * sa) - (sy * cp * cr * sa);
    final double e_11 = (cp * ca) + (sp * cr * sa);
    final double e_12 = -(cy * sp * ca) - (sy * sr * sa) + (cy * cp * cr * sa);
    final double e_20 = -(sy * sp * sa) - (cy * sr * ca) - (sy * cp * cr * ca);
    final double e_21 = -(cp * sa) + (sp * cr * ca);
    final double e_22 = (cy * sp * sa) - (sy * sr * ca) + (cy * cp * cr * ca);

    return vector_math.Matrix3(e_00, e_01, e_02, e_10, e_11, e_12, e_20, e_21, e_22);
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

    final double e_00 = (cy * cr * ca) -
        (sy * cp * sr * ca) -
        (cy * sr * sa) -
        (sy * cp * cr * sa);
    final double e_01 = (sp * sr * ca) + (sp * cr * sa);
    final double e_02 = (sy * cr * ca) +
        (cy * cp * sr * ca) -
        (sy * sr * sa) -
        (cy * cp * cr * sa);
    final double e_10 = sy * sp;
    final double e_11 = cp;
    final double e_12 = -(cy * sp);
    final double e_20 = -(cy * cr * sa) +
        (sy * cp * sr * sa) -
        (cy * sr * ca) -
        (sy * cp * cr * ca);
    final double e_21 = -(sp * sr * sa) + (sp * sr * ca);
    final double e_22 = -(sy * cr * sa) -
        (cy * cp * sr * sa) -
        (sy * sr * ca) +
        (sy * cp * cr * ca);

    return vector_math.Matrix3(e_00, e_01, e_02, e_10, e_11, e_12, e_20, e_21, e_22);
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

    final double e_00 = (cy * cr * ca) - (sy * cp * sr * ca) + (sy * sp * sa);
    final double e_01 = (sp * sr * ca) + (cp * sa);
    final double e_02 = (sy * cr * ca) + (cy * cp * sr * ca) - (cy * sp * sa);
    final double e_10 = -(cy * cr * sa) + (sy * cp * sr * sa) + (sy * sp * ca);
    final double e_11 = -(sp * sr * sa) + (cp * ca);
    final double e_12 = -(sy * cr * sa) - (cy * cp * sr * sa) - (cy * sp * ca);
    final double e_20 = -(cy * sr) - (sy * cp * cr);
    final double e_21 = sp * cr;
    final double e_22 = -(sy * sr) + (cy * cp * cr);

    return vector_math.Matrix3(e_00, e_01, e_02, e_10, e_11, e_12, e_20, e_21, e_22);
  }
}
