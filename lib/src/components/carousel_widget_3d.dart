import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_3d_carousel/src/models/models.dart';
import 'package:flutter_3d_carousel/src/utils/util_functions.dart';

part 'sub_widget.dart';

/// A 3D carousel widget that displays children in a circular arrangement with
/// 3D perspective effects and interactive rotation.
class CarouselWidget3D extends StatefulWidget {
  /// The radius of the circular carousel in logical pixels. Determines the radius about which the children spin.
  final double radius;

  /// The scale factor applied to children. 1 is full size and 0.5 is half size.
  ///
  /// Defaults to 1.0
  final double childScale;

  /// Determines how the carousel behaves after a drag interaction ends. See [DragEndBehavior] for available options.
  ///
  /// Defaults to [DragEndBehavior.snapToNearest]
  final DragEndBehavior dragEndBehavior;

  /// Determines how the carousel behaves after the background is tapped. See [BackgroundTapBehavior] for available options.
  ///
  /// Defaults to [BackgroundTapBehavior.startAndSnapToNearest]
  final BackgroundTapBehavior backgroundTapBehavior;

  /// Determines how the carousel behaves after a child is tapped. See [ChildTapBehavior] for available options.
  ///
  /// Defaults to [ChildTapBehavior.stopAndSnapToChild]
  final ChildTapBehavior childTapBehavior;

  /// Whether the carousel should respond to drag gestures.
  ///
  /// Defaults to true
  final bool isDragInteractive;

  /// Whether only widgets in the front half of the carousel should be rendered
  ///
  /// Defaults to false
  final bool onlyRenderForeground;

  /// Whether the carousel rotates in the clockwise direction when observed from the top.
  /// Defaults to false
  final bool clockwise;

  /// The amount of blur effect applied to background children.
  ///
  /// Defaults to 3.0
  final double backgroundBlur;

  /// Whether the children of the carousel should spin with the carousel.
  /// If true, the children of the carousel will always be facing outwards from the center of the carousel.
  /// If false, the children will always be facing forward (facing the camera or viewer).
  ///
  /// Defaults to true
  final bool spinWhileRotating;

  /// Whether the carousel should automatically rotate.
  ///
  /// Defaults to true
  final bool shouldRotate;

  /// The time in milliseconds for a complete 360-degree revolution when auto-rotating.
  ///
  /// Defaults to 20000 (20 seconds)
  final int timeForFullRevolution;

  /// The duration in milliseconds for the snap-to-position animation after interaction.
  ///
  /// Defaults to 100
  final int snapTimeInMillis;

  /// Decides how strong the perspective effect will be. Uses Matrix4.identity()..setEntry(3, 2, [perspectiveStrength]).
  ///
  /// Defaults to 0.001
  final double perspectiveStrength;

  /// Controls how responsive the carousel is to drag gestures.
  ///
  /// Defaults to 1.0
  final double dragSensitivity;

  /// Called whenever the internal AnimationController's value is updated with the new value.
  /// The internal AnimationController animates from 0 to 2 * pi.
  final Function(double)? onValueChanged;

  /// A widget to fill the background with.
  ///
  /// **Note:** The blur effect is layered on top of the background.
  /// Adjust the [backgroundBlur] property accordingly to achieve the desired visual outcome.
  ///
  /// If the `background` widget is an `Image`, ensure you set its `fit` property
  /// (e.g., `BoxFit.cover`) to control how the image scales and positions itself within the available space.
  final Widget? background;

  /// A widget to render in the center between the front and back halves of the carousel.
  /// **Note:** Is not affected by [backgroundBlur] property.
  final Widget? core;

  /// The list of widgets to display in the carousel. These will be evenly distributed around the circular path.
  final List<CarouselChild> children;

  /// Constructs a new [CarouselWidget3D] object.
  const CarouselWidget3D({
    super.key,
    required this.radius,
    this.childScale = 0.5,
    this.dragEndBehavior = DragEndBehavior.snapToNearest,
    this.backgroundTapBehavior = BackgroundTapBehavior.startAndSnapToNearest,
    this.childTapBehavior = ChildTapBehavior.stopAndSnapToChild,
    this.isDragInteractive = true,
    this.onlyRenderForeground = false,
    this.clockwise = false,
    this.backgroundBlur = 3.0,
    this.spinWhileRotating = true,
    this.shouldRotate = true,
    this.timeForFullRevolution = 20000,
    this.snapTimeInMillis = 100,
    this.perspectiveStrength = 0.001,
    this.dragSensitivity = 1.0,
    this.onValueChanged,
    this.background,
    this.core,
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

  bool isAnimating = false;

  @override
  void dispose() {
    _controller.removeListener(_controllerListener);
    _controller.dispose();
    super.dispose();
  }

  void _controllerListener() {
    if (_controller.isAnimating) {
      isAnimating = true;
    } else {
      isAnimating = false;
    }
    if (widget.onValueChanged != null) {
      widget.onValueChanged!(_controller.value);
    }
  }

  void _rotateInfinitely() => _controller.repeat();

  Future<void> animateToStep(int index) async {
    final double stepAngle = (2 * math.pi) - (index * _stepAngle);
    await animateTo(stepAngle, widget.snapTimeInMillis);
  }

  Future<void> animateToClosestStep() async {
    final int closestStep = (_controller.value / _stepAngle).round();
    final double closestStepAngle = closestStep * _stepAngle;
    await animateTo(closestStepAngle, widget.snapTimeInMillis);
  }

  Future<void> animateToPreviousStep() async {
    final int currentStep = (_controller.value / _stepAngle).round();
    final int nextStep = currentStep - 1;
    final double nextAngle = nextStep * _stepAngle;
    await animateTo(nextAngle);
  }

  Future<void> animateToNextStep() async {
    final int currentStep = (_controller.value / _stepAngle).round();
    final int nextStep = currentStep + 1;
    final double nextAngle = nextStep * _stepAngle;
    await animateTo(nextAngle);
  }

  Future<void> animateTo(
    double nextAngle, [
    int durationInMillis = animationTimeMillis,
  ]) async {
    // This condition determines if the direct linear path between _controller.value and nextAngle
    // is shorter than half the circle (pi radians or 180 degrees).
    // If true, directly animate to nextAngle
    if ((_controller.value - nextAngle).abs() < math.pi) {
      await _controller.animateTo(
        nextAngle,
        duration: Duration(milliseconds: durationInMillis),
      );
    } else {
      late final double duration1;
      if (_controller.value <= math.pi) {
        duration1 = durationInMillis *
            ((_controller.value - _controller.lowerBound) /
                ((_controller.value - _controller.lowerBound) +
                    (_controller.upperBound - nextAngle)));
        await _controller.animateTo(
          _controller.lowerBound,
          duration: Duration(milliseconds: duration1.round()),
        );
        _controller.value = _controller.upperBound;
      } else {
        duration1 = durationInMillis *
            ((_controller.upperBound - _controller.value) /
                ((_controller.upperBound - _controller.value) +
                    (nextAngle - _controller.lowerBound)));
        await _controller.animateTo(
          _controller.upperBound,
          duration: Duration(milliseconds: duration1.round()),
        );
        _controller.value = _controller.lowerBound;
      }
      await _controller.animateTo(
        nextAngle,
        duration: Duration(milliseconds: durationInMillis - duration1.round()),
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
      widget.radius *
      math.sin(getOffsetAngle(index)) *
      (widget.clockwise ? -1 : 1);

  double getZTranslation(int index) =>
      widget.radius * math.cos(getOffsetAngle(index));

  double getYRotation(int index) =>
      widget.spinWhileRotating ? -getOffsetAngle(index) : 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: switch (widget.backgroundTapBehavior) {
        BackgroundTapBehavior.startAndFreeze => () {
            if (!isAnimating) {
              _rotateInfinitely();
            } else {
              _controller.value = _controller.value;
            }
          },
        BackgroundTapBehavior.startAndSnapToNearest => () {
            if (!isAnimating) {
              _rotateInfinitely();
            } else {
              animateToClosestStep();
            }
          },
        _ => () {},
      },
      onHorizontalDragStart: widget.isDragInteractive
          ? (details) {
              initialXPosition = details.globalPosition.dx;
            }
          : null,
      onHorizontalDragUpdate: widget.isDragInteractive
          ? (details) {
              final double xDrag = initialXPosition - details.globalPosition.dx;
              initialXPosition = details.globalPosition.dx;
              final double angleInRadian = widget.clockwise
                  ? -_getAngleInRadFromXMovement(xDrag)
                  : _getAngleInRadFromXMovement(xDrag);
              animateTo(
                (_controller.value - angleInRadian) % (2 * math.pi),
                0,
              );
            }
          : null,
      onHorizontalDragEnd: widget.isDragInteractive
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

          return SizedBox(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // To enable dragging on the empty background
                const Positioned.fill(
                  child: ColoredBox(color: Colors.transparent),
                ),

                // Background widget
                if (widget.background != null)
                  Positioned.fill(child: widget.background!),

                // Back half of the carousel
                if (!widget.onlyRenderForeground)
                  for (int i = 0; i < widget.children.length; i++)
                    if (indexToDistFrom180[i].$2 < 90)
                      _SubWidget(
                        scale: widget.childScale,
                        radius: widget.radius,
                        perspectiveStrength: widget.perspectiveStrength,
                        xTranslation: getXTranslation(getIndexOf(i)),
                        zTranslation:
                            widget.radius - getZTranslation(getIndexOf(i)),
                        yRotation: getYRotation(getIndexOf(i)),
                        child: widget.children[getIndexOf(i)].child,
                        onTap: () {
                          animateToStep(getIndexOf(i));
                          widget.children[getIndexOf(i)].onTap();
                        },
                      ),

                // Then, render the blur
                IgnorePointer(
                  ignoring: true,
                  child: BackdropFilter(
                    blendMode: BlendMode.srcATop,
                    filter: ImageFilter.blur(
                      sigmaX: widget.backgroundBlur,
                      sigmaY: widget.backgroundBlur,
                    ),
                    child: const ColoredBox(color: Colors.transparent),
                  ),
                ),

                // Core widget
                if (widget.core != null)
                  AbsorbPointer(
                    absorbing: true,
                    child: widget.core!,
                  ),

                // Front half of the carousel
                for (int i = 0; i < widget.children.length; i++)
                  if (indexToDistFrom180[i].$2 >= 90)
                    _SubWidget(
                      scale: widget.childScale,
                      radius: widget.radius,
                      perspectiveStrength: widget.perspectiveStrength,
                      xTranslation: getXTranslation(indexToDistFrom180[i].$1),
                      zTranslation: widget.radius -
                          getZTranslation(indexToDistFrom180[i].$1),
                      yRotation: getYRotation(indexToDistFrom180[i].$1),
                      child: widget.children[indexToDistFrom180[i].$1].child,
                      onTap: () {
                        animateToStep(getIndexOf(i));
                        widget.children[getIndexOf(i)].onTap();
                      },
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}
