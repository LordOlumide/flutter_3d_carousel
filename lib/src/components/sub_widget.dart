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
  final bool childrenAreAlwaysFacingForward;
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
    required this.childrenAreAlwaysFacingForward,
    required this.perspectiveStrength,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.compose(
        vector_math.Vector3(xTranslation, yTranslation, zTranslation),
        vector_math.Quaternion.euler(yawAngle, pitchAngle, rollAngle),
        vector_math.Vector3(scale, scale, scale),
      )..setEntry(3, 2, perspectiveStrength),
      // transform: Matrix4.identity()
      //   ..setEntry(3, 2, perspectiveStrength)
      //   ..translateByDouble(
      //     xTranslation,
      //     yTranslation,
      //     zTranslation,
      //     1.0,
      //   )
      //   ..scaleByDouble(scale, scale, scale, 1.0),
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }
}
