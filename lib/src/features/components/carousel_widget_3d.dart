import 'dart:math' as math;
import 'dart:ui';

import 'package:_3d_carousel/src/features/models/drag_behaviour.dart';
import 'package:_3d_carousel/src/src.dart';
import 'package:flutter/material.dart';

class CarouselWidget3D extends StatefulWidget {
  final DragEndBehavior dragEndBehavior;
  final bool isDragInteractive;
  final double radius;
  final double childScale;
  final List<Widget> children;
  final double backgroundBlur;
  final bool spinWhileRotating;
  final bool shouldRotateInfinitely;

  const CarouselWidget3D({
    super.key,
    this.isDragInteractive = true,
    this.dragEndBehavior = DragEndBehavior.snapToNearest,
    required this.radius,
    this.childScale = 0.5,
    required this.children,
    this.backgroundBlur = 3,
    this.spinWhileRotating = true,
    this.shouldRotateInfinitely = true,
  });

  @override
  State<CarouselWidget3D> createState() => _CarouselWidget3DState();
}

class _CarouselWidget3DState extends State<CarouselWidget3D>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final double _stepAngle;

  static const int animationTimeMillis = 300;

  bool isRotating = false;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    _stepAngle = (2 * math.pi) / widget.children.length;

    _controller = AnimationController(
      vsync: this,
      value: 0.0,
      lowerBound: 0.0,
      upperBound: 2 * math.pi,
      duration: const Duration(seconds: 10),
    );
    _controller.addListener(_controllerListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_controllerListener);
    _controller.dispose();
    super.dispose();
  }

  void _controllerListener() {
    setState(() {
      isRotating = _controller.isAnimating ? true : false;
    });
  }

  void _rotateInfinitely() => _controller.repeat();

  void _stopInfiniteRotation() {
    animateToClosestStep();
  }

  Future<void> animateToClosestStep() async {
    final int closestStep = (_controller.value / _stepAngle).round();
    final double closestStepAngle = closestStep * _stepAngle;
    if (closestStepAngle < _controller.value) {
      await animateBackTo(closestStepAngle, 100);
    } else {
      await animateForwardTo(closestStepAngle, 100);
    }
  }

  Future<void> animateToPreviousStep() async {
    final int currentStep = (_controller.value / _stepAngle).round();
    final int nextStep = currentStep - 1;
    final double nextAngle = nextStep * _stepAngle;
    await animateBackTo(nextAngle);
  }

  Future<void> animateToNextStep() async {
    final int currentStep = (_controller.value / _stepAngle).round();
    final int nextStep = currentStep + 1;
    final double nextAngle = nextStep * _stepAngle;
    await animateForwardTo(nextAngle);
  }

  Future<void> animateBackTo(
    double nextAngle, [
    int durationInMillis = animationTimeMillis,
  ]) async {
    if (nextAngle >= _controller.lowerBound) {
      await _controller.animateTo(
        nextAngle,
        duration: Duration(milliseconds: durationInMillis),
      );
    } else {
      await _controller.animateTo(
        _controller.lowerBound,
        duration: const Duration(milliseconds: 0),
      );
      _controller.value = _controller.upperBound;
      await _controller.animateTo(
        nextAngle % (2 * math.pi),
        duration: Duration(milliseconds: durationInMillis),
      );
    }
  }

  Future<void> animateForwardTo(
    double nextAngle, [
    int durationInMillis = animationTimeMillis,
  ]) async {
    if (nextAngle <= _controller.upperBound) {
      await _controller.animateTo(
        nextAngle,
        duration: Duration(milliseconds: durationInMillis),
      );
    } else {
      await _controller.animateTo(
        _controller.upperBound,
        duration: const Duration(milliseconds: 0),
      );
      _controller.value = _controller.lowerBound;
      await _controller.animateTo(
        nextAngle % (2 * math.pi),
        duration: Duration(milliseconds: durationInMillis),
      );
    }
  }

  final double sensitivityFactor = 1.0;
  double _getAngleInRadFromXMovement(double dx) {
    // Length of an arc = r * theta  where (r = radius, theta = angle in radians)
    final double radius = MediaQuery.sizeOf(context).width / 2;
    return (dx / radius) * sensitivityFactor;
  }

  double initialXPosition = 0;

  double getOffsetAngle(int index) =>
      (_controller.value + (index * _stepAngle)) % (2 * math.pi);

  double getXTranslation(int index) =>
      widget.radius * math.sin(getOffsetAngle(index));

  double getZTranslation(int index) =>
      widget.radius * math.cos(getOffsetAngle(index));

  double getYRotation(int index) =>
      widget.spinWhileRotating ? -getOffsetAngle(index) : 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart:
          widget.isDragInteractive
              ? (details) {
                initialXPosition = details.globalPosition.dx;
                setState(() {
                  isDragging = true;
                });
              }
              : null,
      onHorizontalDragUpdate:
          widget.isDragInteractive
              ? (details) {
                final double xDrag =
                    initialXPosition - details.globalPosition.dx;
                initialXPosition = details.globalPosition.dx;
                final double angleInRadian = _getAngleInRadFromXMovement(xDrag);

                if (angleInRadian >= 0) {
                  animateForwardTo(
                    (_controller.value - angleInRadian) % (2 * math.pi),
                    0,
                  );
                } else {
                  animateBackTo(
                    (_controller.value - angleInRadian) % (2 * math.pi),
                    0,
                  );
                }
              }
              : null,
      onHorizontalDragEnd:
          widget.isDragInteractive
              ? switch (widget.dragEndBehavior) {
                DragEndBehavior.doNothing => null,
                DragEndBehavior.snapToNearest => (details) {
                  animateToClosestStep().then((_) {
                    setState(() {
                      isDragging = false;
                    });
                  });
                },
                DragEndBehavior.continueRotating => (details) {
                  if (widget.shouldRotateInfinitely) {}
                },
              }
              : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // print(controller.value);

          List<(double, Widget)> anglesInDegToWidgets = [];
          for (int i = 0; i < widget.children.length; i++) {
            final double angleAtIndexInDeg = UtilFunctions.inDegrees(
              double.parse(getOffsetAngle(i).toStringAsFixed(2)),
            );
            anglesInDegToWidgets.add((angleAtIndexInDeg, widget.children[i]));
          }
          print(anglesInDegToWidgets[0].$1);

          return Stack(
            children: [
              // First render the widgets from 90 - 270 degrees
              for (int i = 0; i < widget.children.length; i++)
                if (UtilFunctions.isBetween90And270Degrees(
                  anglesInDegToWidgets[i].$1,
                ))
                  SubWidget(
                    scale: widget.childScale,
                    radius: widget.radius,
                    xTranslation: getXTranslation(i),
                    zTranslation: widget.radius - getZTranslation(i),
                    yRotation: getYRotation(i),
                    child: widget.children[i],
                  ),
              BackdropFilter(
                blendMode: BlendMode.srcATop,
                filter: ImageFilter.blur(
                  sigmaX: widget.backgroundBlur,
                  sigmaY: widget.backgroundBlur,
                ),
                child: ColoredBox(color: Colors.transparent),
              ),
              for (int i = 0; i < widget.children.length; i++)
                if (!UtilFunctions.isBetween90And270Degrees(
                  anglesInDegToWidgets[i].$1,
                ))
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
      ),
    );
  }
}
