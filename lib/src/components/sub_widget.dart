part of 'carousel_widget_3d.dart';

class _SubWidget extends StatelessWidget {
  final double scale;
  final double radius;
  final double xTranslation;
  final double yTranslation;
  final double zTranslation;
  final double rollAngle;
  final double pitchAngle;
  final double yawAngle;
  final ChildOrientation childOrientation;
  final double perspectiveStrength;
  final Widget child;
  final VoidCallback onTap;

  const _SubWidget({
    required this.scale,
    required this.radius,
    required this.xTranslation,
    required this.yTranslation,
    required this.zTranslation,
    required this.rollAngle,
    required this.pitchAngle,
    required this.yawAngle,
    required this.childOrientation,
    required this.perspectiveStrength,
    required this.child,
    required this.onTap,
  });

  // void testTransformationMatrix(vector_math.Matrix3 rotation) {
  //   final xAxis = rotation.transform(vector_math.Vector3(1, 0, 0));
  //   final yAxis = rotation.transform(vector_math.Vector3(0, 1, 0));
  //   final zAxis = rotation.transform(vector_math.Vector3(0, 0, 1));
  //
  //   print('Transformed X axis: $xAxis');
  //   print('Transformed Y axis: $yAxis');
  //   print('Transformed Z axis: $zAxis');
  // }

  @override
  Widget build(BuildContext context) {
    // print('${UtilFunctions.inDegrees(rollAngle).toStringAsFixed(2)}, '
    //     '${UtilFunctions.inDegrees(pitchAngle).toStringAsFixed(2)}, '
    //     '${UtilFunctions.inDegrees(yawAngle).toStringAsFixed(2)}');

    late final vector_math.Matrix3? matrix3;

    if (childOrientation is OrientedFacingScreen) {
      matrix3 = null;
    } else if (childOrientation is OrientedBackingCenter) {
      matrix3 = Transformations.transformation1(
        rollAngle: rollAngle,
        pitchAngle: pitchAngle,
        yawAngle: yawAngle,
      );
    } else if (childOrientation is OrientedWithXTilt) {
      matrix3 = Transformations.transformation2(
        rollAngle: rollAngle,
        pitchAngle: pitchAngle,
        yawAngle: yawAngle,
        a: childOrientation.tiltAngle!,
      );
    } else if (childOrientation is OrientedWithYTilt) {
      matrix3 = Transformations.transformation3(
        rollAngle: rollAngle,
        pitchAngle: pitchAngle,
        yawAngle: yawAngle,
        a: childOrientation.tiltAngle!,
      );
    } else if (childOrientation is OrientedWithZTilt) {
      matrix3 = Transformations.transformation4(
        rollAngle: rollAngle,
        pitchAngle: pitchAngle,
        yawAngle: yawAngle,
        a: childOrientation.tiltAngle!,
      );
    }

    late final vector_math.Matrix4 matrix4;
    if (childOrientation is OrientedFacingScreen) {
      matrix4 = Matrix4(
        1 * scale,
        0,
        0,
        0,
        0,
        1 * scale,
        0,
        0,
        0,
        0,
        1 * scale,
        perspectiveStrength,
        xTranslation,
        yTranslation,
        zTranslation,
        perspectiveStrength * zTranslation + 1,
      );
    } else {
      matrix4 = Matrix4(
        matrix3!.entry(0, 0) * scale,
        matrix3.entry(1, 0),
        matrix3.entry(2, 0),
        perspectiveStrength * matrix3.entry(2, 0),
        matrix3.entry(0, 1),
        matrix3.entry(1, 1) * scale,
        matrix3.entry(2, 1),
        perspectiveStrength * matrix3.entry(2, 1),
        matrix3.entry(0, 2),
        matrix3.entry(1, 2),
        matrix3.entry(2, 2) * scale,
        perspectiveStrength * matrix3.entry(2, 2),
        xTranslation,
        yTranslation,
        zTranslation,
        perspectiveStrength * zTranslation + 1,
      );
    }

    return Transform(
      alignment: Alignment.center,
      transform: matrix4,
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }
}
