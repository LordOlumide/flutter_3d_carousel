import 'dart:math' as math;
import 'dart:ui';

import 'package:_3d_carousel/src/features/models/drag_behaviour.dart';
import 'package:_3d_carousel/src/src.dart';
import 'package:flutter/material.dart';

part 'sub_widget.dart';

/// A 3D carousel widget that displays children in a circular arrangement with
/// 3D perspective effects and interactive rotation.
class CarouselWidget3D extends StatefulWidget {
  /// The radius of the circular carousel in logical pixels. Determines the radius about which the children spin.
  final double radius;

  /// The scale factor applied to children. 1 is full size and 0.5 is half size.
  final double childScale;

  /// Determines how the carousel behaves after a drag interaction ends. See [DragEndBehavior] for available options.
  final DragEndBehavior dragEndBehavior;

  /// Whether the carousel should respond to drag gestures.
  final bool isDragInteractive;

  /// The amount of blur effect applied to background children.
  final double backgroundBlur;

  /// Whether the children of the carousel should spin with the carousel.
  /// If true, the children of the carousel will always be facing outwards from the center of the carousel.
  /// If false, the children will always be facing forward.
  final bool spinWhileRotating;

  /// Whether the carousel should automatically rotate.
  final bool shouldRotate;

  /// The time in milliseconds for a complete 360-degree revolution when auto-rotating.
  final int timeForFullRevolution;

  /// The duration in milliseconds for the snap-to-position animation after interaction.
  final int snapTimeInMillis;

  /// Decides how strong the perspective effect will be. Uses Matrix4.identity()..setEntry(3, 2, [perspectiveStrength]).
  final double perspectiveStrength;

  /// Controls how responsive the carousel is to drag gestures.
  final double dragSensitivity;

  /// Called whenever the internal AnimationController's value is updated with the new value. The internal AnimationController animates from 0 to 2 * pi in radians.
  final Function(double)? onValueChanged;

  /// The list of widgets to display in the carousel. These will be evenly distributed around the circular path.
  final List<Widget> children;

  const CarouselWidget3D({
    super.key,
    required this.radius,
    this.childScale = 0.5,
    this.isDragInteractive = true,
    this.dragEndBehavior = DragEndBehavior.snapToNearest,
    this.backgroundBlur = 3,
    this.spinWhileRotating = true,
    this.shouldRotate = true,
    this.timeForFullRevolution = 10,
    this.snapTimeInMillis = 100,
    this.perspectiveStrength = 0.001,
    this.dragSensitivity = 1.0,
    this.onValueChanged,
    required this.children,
  });

  @override
  State<CarouselWidget3D> createState() => _CarouselWidget3DState();
}

class _CarouselWidget3DState extends State<CarouselWidget3D>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final double _stepAngle;

  static const int animationTimeMillis = 300;

  @override
  void initState() {
    super.initState();
    _stepAngle = (2 * math.pi) / widget.children.length;

    _controller = AnimationController(
      vsync: this,
      value: 0.0,
      lowerBound: 0.0,
      upperBound: 2 * math.pi,
      duration: Duration(milliseconds: widget.timeForFullRevolution),
    );
    _controller.addListener(_controllerListener);
    if (widget.shouldRotate) {
      _rotateInfinitely();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_controllerListener);
    _controller.dispose();
    super.dispose();
  }

  void _controllerListener() {
    if (widget.onValueChanged != null) {
      widget.onValueChanged!(_controller.value);
    }
  }

  void _rotateInfinitely() => _controller.repeat();

  void _stopInfiniteRotation() {
    animateToClosestStep();
  }

  Future<void> animateToClosestStep() async {
    final int closestStep = (_controller.value / _stepAngle).round();
    final double closestStepAngle = closestStep * _stepAngle;
    if (closestStepAngle < _controller.value) {
      await animateBackTo(closestStepAngle, widget.snapTimeInMillis);
    } else {
      await animateForwardTo(closestStepAngle, widget.snapTimeInMillis);
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

  double _getAngleInRadFromXMovement(double dx) {
    // Length of an arc = r * theta  where (r = radius, theta = angle in radians)
    final double radius = MediaQuery.sizeOf(context).width / 2;
    return (dx / radius) * widget.dragSensitivity;
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
                  animateToClosestStep();
                },
                DragEndBehavior.continueRotating => (details) {
                  if (widget.shouldRotate) {
                    _rotateInfinitely();
                  } else {
                    animateToClosestStep();
                  }
                },
              }
              : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          List<(int, double)> indexToDistFrom180 = [];
          for (int i = 0; i < widget.children.length; i++) {
            final double offsetAngle = UtilFunctions.inDegrees(
              getOffsetAngle(i),
            );
            indexToDistFrom180.add((i, (180 - offsetAngle).abs()));
          }
          indexToDistFrom180.sort((a, b) => a.$2.compareTo(b.$2));

          int getIndexOf(int index) => indexToDistFrom180[index].$1;

          return Stack(
            children: [
              // To enable dragging on the background
              const Positioned.fill(
                child: ColoredBox(color: Colors.transparent),
              ),

              // Back half of the carousel
              for (int i = 0; i < widget.children.length; i++)
                if (indexToDistFrom180[i].$2 < 90)
                  SubWidget(
                    scale: widget.childScale,
                    radius: widget.radius,
                    perspectiveStrength: widget.perspectiveStrength,
                    xTranslation: getXTranslation(getIndexOf(i)),
                    zTranslation:
                        widget.radius - getZTranslation(getIndexOf(i)),
                    yRotation: getYRotation(getIndexOf(i)),
                    child: widget.children[getIndexOf(i)],
                  ),

              // Then, render the blur
              BackdropFilter(
                blendMode: BlendMode.srcATop,
                filter: ImageFilter.blur(
                  sigmaX: widget.backgroundBlur,
                  sigmaY: widget.backgroundBlur,
                ),
                child: const ColoredBox(color: Colors.transparent),
              ),

              // Front half of the carousel
              for (int i = 0; i < widget.children.length; i++)
                if (indexToDistFrom180[i].$2 >= 90)
                  SubWidget(
                    scale: widget.childScale,
                    radius: widget.radius,
                    perspectiveStrength: widget.perspectiveStrength,
                    xTranslation: getXTranslation(indexToDistFrom180[i].$1),
                    zTranslation:
                        widget.radius -
                        getZTranslation(indexToDistFrom180[i].$1),
                    yRotation: getYRotation(indexToDistFrom180[i].$1),
                    child: widget.children[indexToDistFrom180[i].$1],
                  ),
            ],
          );
        },
      ),
    );
  }
}
