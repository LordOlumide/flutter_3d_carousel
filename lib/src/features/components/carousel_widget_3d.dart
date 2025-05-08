import 'dart:math' as math;
import 'dart:ui';

import 'package:_3d_carousel/src/src.dart';
import 'package:flutter/material.dart';

class CarouselWidget3D extends StatelessWidget {
  final double radius;
  final double childScale;
  final List<Widget> children;
  final double backgroundBlur;
  final Color blurColor;
  final double stepAngle;
  final AnimationController controller;

  const CarouselWidget3D({
    super.key,
    required this.radius,
    this.childScale = 0.5,
    required this.children,
    this.backgroundBlur = 3,
    this.blurColor = Colors.transparent,
    required this.stepAngle,
    required this.controller,
  });

  double getOffsetAngle(int index) =>
      (controller.value + (index * stepAngle)) % (2 * math.pi);

  double getXTranslation(int index) => radius * math.sin(getOffsetAngle(index));

  double getZTranslation(int index) => radius * math.cos(getOffsetAngle(index));

  double getYRotation(int index) => -getOffsetAngle(index);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // print(controller.value);

        List<double> angles = List.generate(
          children.length,
          (index) => double.parse(getOffsetAngle(index).toStringAsFixed(2)),
        );
        print(UtilFunctions.inDegrees(angles[0]));

        return Stack(
          children: [
            for (int i = 0; i < children.length; i++)
              if (UtilFunctions.isBetween90And270Degrees(angles[i]))
                SubWidget(
                  scale: childScale,
                  radius: radius,
                  xTranslation: getXTranslation(i),
                  zTranslation: radius - getZTranslation(i),
                  yRotation: getYRotation(i),
                  child: children[i],
                ),
            BackdropFilter(
              blendMode: BlendMode.srcATop,
              filter: ImageFilter.blur(
                sigmaX: backgroundBlur,
                sigmaY: backgroundBlur,
              ),
              child: Container(color: blurColor),
            ),
            for (int i = 0; i < children.length; i++)
              if (!UtilFunctions.isBetween90And270Degrees(angles[i]))
                SubWidget(
                  scale: childScale,
                  radius: radius,
                  xTranslation: getXTranslation(i),
                  zTranslation: radius - getZTranslation(i),
                  yRotation: getYRotation(i),
                  child: children[i],
                ),
          ],
        );
      },
    );
  }
}
