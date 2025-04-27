import 'package:flutter/material.dart';

class SubWidget extends StatelessWidget {
  final double scale;
  final double radius;
  final double xTranslation;
  final double zTranslation;
  final double yRotation;
  final Widget child;

  const SubWidget({
    super.key,
    required this.scale,
    required this.radius,
    required this.xTranslation,
    required this.zTranslation,
    required this.yRotation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform:
          Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..translate(xTranslation, 0.0, zTranslation)
            ..rotateY(yRotation),
      child: Transform.scale(scale: scale, child: child),
    );
  }
}
