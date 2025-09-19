part of 'carousel_widget_3d.dart';

class _SubWidget extends StatelessWidget {
  final double scale;
  final double radius;
  final double xTranslation;
  final double yTranslation;
  final double zTranslation;
  final double yRotation;
  final double xRotation;
  final double zRotation;
  final double perspectiveStrength;
  final Widget child;
  final VoidCallback onTap;

  const _SubWidget({
    required this.scale,
    required this.radius,
    required this.xTranslation,
    required this.yTranslation,
    required this.zTranslation,
    required this.yRotation,
    required this.xRotation,
    required this.zRotation,
    required this.perspectiveStrength,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, perspectiveStrength)
        ..translate(
          xTranslation,
          yTranslation,
          zTranslation,
        )
        ..rotateY(yRotation)
        ..rotateX(xRotation)
        ..rotateZ(zRotation),
      child: Transform.scale(
        scale: scale,
        child: GestureDetector(
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
