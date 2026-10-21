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

    final Transformation? transformation = switch (childOrientation) {
      ChildOrientation.backingCenter => Transformation1(),
      ChildOrientation.facingYAxis => Transformation2(),
      ChildOrientation.facingScreen => null,
    };

    final vector_math.Matrix4 matrix4 = switch (childOrientation) {
      (ChildOrientation.backingCenter || ChildOrientation.facingYAxis) =>
        Matrix4(
          transformation!.get00(
            rollAngle: rollAngle,
            pitchAngle: pitchAngle,
            yawAngle: yawAngle,
          ),
          transformation.get01(
            rollAngle: rollAngle,
            pitchAngle: pitchAngle,
            yawAngle: yawAngle,
          ),
          transformation.get02(
            rollAngle: rollAngle,
            pitchAngle: pitchAngle,
            yawAngle: yawAngle,
          ),
          0,
          transformation.get10(
            rollAngle: rollAngle,
            pitchAngle: pitchAngle,
            yawAngle: yawAngle,
          ),
          transformation.get11(
            rollAngle: rollAngle,
            pitchAngle: pitchAngle,
            yawAngle: yawAngle,
          ),
          transformation.get12(
            rollAngle: rollAngle,
            pitchAngle: pitchAngle,
            yawAngle: yawAngle,
          ),
          0,
          transformation.get20(
            rollAngle: rollAngle,
            pitchAngle: pitchAngle,
            yawAngle: yawAngle,
          ),
          transformation.get21(
            rollAngle: rollAngle,
            pitchAngle: pitchAngle,
            yawAngle: yawAngle,
          ),
          transformation.get22(
            rollAngle: rollAngle,
            pitchAngle: pitchAngle,
            yawAngle: yawAngle,
          ),
          perspectiveStrength,
          xTranslation,
          yTranslation,
          zTranslation,
          1,
        ),
      ChildOrientation.facingScreen => Matrix4(
          1,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          1,
          perspectiveStrength,
          xTranslation,
          yTranslation,
          zTranslation,
          1,
        ),
    };

    // TODO: The object is moving in the z dimension in 3d space but the perspectiveStrength is not
    // applied to the motion.
    // The object is also rotating in the Y axis but it is also not showing

    return Transform(
      alignment: Alignment.center,
      transform: matrix4,

      // transform: Matrix4.identity()
      //   // perspectiveStrength must be set first
      //   ..setEntry(3, 2, perspectiveStrength)
      //   ..translateByDouble(
      //     xTranslation,
      //     yTranslation,
      //     zTranslation,
      //     1.0,
      //   )
      //   ..rotateY(math.pi / 10)
      //   // ..setRotation(
      //   //   Transformation.getTransformationMatrix(
      //   //     rollAngle: rollAngle,
      //   //     pitchAngle: pitchAngle,
      //   //     yawAngle: yawAngle,
      //   //   ),
      //   // )
      //   ..scaleByDouble(scale, scale, scale, 1.0),
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }
}
