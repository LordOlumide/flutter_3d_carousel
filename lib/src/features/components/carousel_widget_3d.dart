import 'dart:math' as math;

import 'package:_3d_onboarding_animation/src/features/components/sub_widget.dart';
import 'package:_3d_onboarding_animation/src/src.dart';
import 'package:_3d_onboarding_animation/src/utils/debouncer.dart';
import 'package:_3d_onboarding_animation/src/utils/throttler.dart';
import 'package:flutter/material.dart';

class CarouselWidget3D extends StatefulWidget {
  final double radius;
  final double childScale;
  final List<Widget> children;

  const CarouselWidget3D({
    super.key,
    required this.radius,
    this.childScale = 0.5,
    required this.children,
  });

  @override
  State<CarouselWidget3D> createState() => _CarouselWidget3DState();
}

class _CarouselWidget3DState extends State<CarouselWidget3D>
    with SingleTickerProviderStateMixin {
  final Debouncer _debouncer = Debouncer(delay: Duration(milliseconds: 500));
  final Throttler _throttler = Throttler(delay: Duration(milliseconds: 500));
  late final AnimationController _controller;

  late final double stepAngle;

  @override
  void initState() {
    super.initState();
    stepAngle = (2 * math.pi) / widget.children.length;

    _controller = AnimationController(
      vsync: this,
      value: 0.0,
      lowerBound: 0.0,
      upperBound: 2 * math.pi,
      duration: const Duration(milliseconds: 5000),
    );
    _controller.addListener(_controllerListener);
    _controller.repeat();
  }

  void _controllerListener() {
    if (_controller.value > 2 * math.pi || _controller.value < 0) {
      setState(() {
        _controller.value = _controller.value % (2 * math.pi);
      });
    }
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _throttler.dispose();

    _controller.removeListener(_controllerListener);
    _controller.dispose();
    super.dispose();
  }

  double getOffsetAngle(int index) =>
      (_controller.value + (index * stepAngle)) % (2 * math.pi);

  double getXTranslation(int index) =>
      widget.radius * math.sin(getOffsetAngle(index));

  double getZTranslation(int index) =>
      widget.radius * math.cos(getOffsetAngle(index));

  double getYRotation(int index) => -getOffsetAngle(index);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        List<double> angles = List.generate(
          widget.children.length,
          (index) => double.parse(getOffsetAngle(index).toStringAsFixed(2)),
        );
        _throttler.run(() {
          print(angles);
        });

        return Stack(
          children: [
            for (int i = 0; i < widget.children.length; i++)
              if (UtilFunctions.isBetween90And270Degrees(angles[i]))
                SubWidget(
                  scale: widget.childScale,
                  radius: widget.radius,
                  xTranslation: getXTranslation(i),
                  zTranslation: widget.radius - getZTranslation(i),
                  yRotation: getYRotation(i),
                  child: widget.children[i],
                ),
            for (int i = 0; i < widget.children.length; i++)
              if (!UtilFunctions.isBetween90And270Degrees(angles[i]))
                SubWidget(
                  scale: widget.childScale,
                  radius: widget.radius,
                  xTranslation: getXTranslation(i),
                  zTranslation: widget.radius - getZTranslation(i),
                  yRotation: getYRotation(i),
                  child: widget.children[i],
                ),
          ],
        );
      },
    );
  }
}
