part of 'carousel_widget_3d.dart';

class _SubWidget extends StatelessWidget {
  final double scale;
  final double radius;
  final double xTranslation;
  final double zTranslation;
  final double yRotation;
  final double perspectiveStrength;
  final Widget child;

  const _SubWidget({
    required this.scale,
    required this.radius,
    required this.xTranslation,
    required this.zTranslation,
    required this.yRotation,
    required this.perspectiveStrength,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, perspectiveStrength)
        ..translate(xTranslation, 0.0, zTranslation)
        ..rotateY(yRotation),
      child: Transform.scale(scale: scale, child: child),
    );
  }
}
