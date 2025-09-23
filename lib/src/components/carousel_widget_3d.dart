import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_3d_carousel/src/models/models.dart';
import 'package:flutter_3d_carousel/src/utils/util_functions.dart';

part 'sub_widget.dart';

// TODO: Create Presets: .horizontal, .vertical, .spinning

/// A 3D carousel widget that displays children in a circular arrangement with
/// 3D perspective effects and interactive rotation.
///
/// **Note:** The [CarouselChild.onTap] will be called no matter what value is assigned to [childTapBehavior].
/// The [childTapBehavior] defines how the carousel will animate when a child is tapped.
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
  final bool hideForeground;

  /// Whether only widgets in the back half of the carousel should be rendered
  ///
  /// Defaults to false
  final bool hideBackground;

  /// Whether the carousel rotates in the clockwise direction when observed from the top.
  ///
  /// Defaults to false
  final bool clockwise;

  /// Whether it is a horizontal carousel or a vertical carousel.
  ///
  /// Defaults to [Axis.horizontal]
  final Axis dragDirection;

  /// The amount of blur effect applied to background children.
  ///
  /// Defaults to 3.0
  final double backgroundBlur;

  /// TODO: Whether the children of the carousel should spin with the carousel.
  /// If true, the children of the carousel will always be facing outwards from the center of the carousel.
  /// If false, the children will always be facing forward (facing the camera or viewer).
  ///
  /// Defaults to true
  final bool childrenAreAlwaysFacingForward;

  /// Whether the carousel should automatically rotate.
  ///
  /// Defaults to true
  final bool thetaShouldRotate;

  /// Whether the carousel should automatically rotate.
  ///
  /// Defaults to true
  final bool alphaShouldRotate;

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

  /// TODO:
  final TiltController tiltController;
  final double initialTheta;

  /// Determines how the edges of the carousel area will be clipped.
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// Called whenever the internal AnimationController value for Theta is updated with the new value.
  /// The internal AnimationController animates from 0 to 2 * pi.
  final Function(double)? onThetaValueChanged;

  /// Called whenever the internal AnimationController value for Alpha is updated with the new value.
  /// The internal AnimationController animates from 0 to 2 * pi.
  final Function(double)? onAlphaValueChanged;

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
    this.hideForeground = false,
    this.hideBackground = false,
    this.clockwise = false,
    this.dragDirection = Axis.horizontal,
    this.backgroundBlur = 3.0,
    this.childrenAreAlwaysFacingForward = false,
    this.thetaShouldRotate = true,
    this.alphaShouldRotate = false,
    this.timeForFullRevolution = 20000,
    this.snapTimeInMillis = 100,
    this.perspectiveStrength = 0.001,
    this.dragSensitivity = 1.0,
    this.tiltController = const TiltController(initialTiltAngle: 0),
    this.initialTheta = 0.0,
    this.clipBehavior = Clip.hardEdge,
    this.onThetaValueChanged,
    this.onAlphaValueChanged,
    this.background,
    this.core,
    required this.children,
  });

  @override
  State<CarouselWidget3D> createState() => _CarouselWidget3DState();
}

// TODO: Handle all Gesture Responses

class _CarouselWidget3DState extends State<CarouselWidget3D>
    with TickerProviderStateMixin {
  late final AnimationController thetaController;
  late final AnimationController alphaController;

  // The theta angle between successive elements in the carousel
  late final double _stepAngle;

  static const int animationTimeMillis = 300;

  @override
  void initState() {
    super.initState();
    _stepAngle = (2 * math.pi) / widget.children.length;

    thetaController = AnimationController(
      vsync: this,
      value: widget.initialTheta,
      lowerBound: 0.0,
      upperBound: 2 * math.pi,
      duration: Duration(milliseconds: widget.timeForFullRevolution),
    );
    thetaController.addListener(_thetaControllerListener);
    if (widget.thetaShouldRotate) {
      thetaController.repeat();
    }

    alphaController = AnimationController(
      vsync: this,
      value: widget.tiltController.initialTiltAngle,
      lowerBound: 0.0,
      upperBound: 2 * math.pi,
      duration: Duration(milliseconds: widget.tiltController.tiltAnimationTime),
    );
    alphaController.addListener(_alphaControllerListener);
    if (widget.alphaShouldRotate) {
      alphaController.repeat();
    }
  }

  bool thetaIsAnimating = false;
  bool alphaIsAnimating = false;

  @override
  void dispose() {
    thetaController.removeListener(_thetaControllerListener);
    thetaController.dispose();

    alphaController.removeListener(_alphaControllerListener);
    alphaController.dispose();
    super.dispose();
  }

  void _thetaControllerListener() {
    if (thetaController.isAnimating) {
      thetaIsAnimating = true;
    } else {
      thetaIsAnimating = false;
    }
    if (widget.onThetaValueChanged != null) {
      widget.onThetaValueChanged!(thetaController.value);
    }
  }

  void _alphaControllerListener() {
    if (alphaController.isAnimating) {
      alphaIsAnimating = true;
    } else {
      alphaIsAnimating = false;
    }
    if (widget.onAlphaValueChanged != null) {
      widget.onAlphaValueChanged!(alphaController.value);
    }
  }

  Future<void> animateToStep(int index) async {
    final double stepAngle = (2 * math.pi) - (index * _stepAngle);
    await animateTo(stepAngle, widget.snapTimeInMillis);
  }

  Future<void> animateToClosestStep() async {
    final int closestStep = (thetaController.value / _stepAngle).round();
    final double closestStepAngle = closestStep * _stepAngle;
    await animateTo(closestStepAngle, widget.snapTimeInMillis);
  }

  Future<void> animateToPreviousStep() async {
    final int currentStep = (thetaController.value / _stepAngle).round();
    final int nextStep = currentStep - 1;
    final double nextAngle = nextStep * _stepAngle;
    await animateTo(nextAngle);
  }

  Future<void> animateToNextStep() async {
    final int currentStep = (thetaController.value / _stepAngle).round();
    final int nextStep = currentStep + 1;
    final double nextAngle = nextStep * _stepAngle;
    await animateTo(nextAngle);
  }

  Future<void> animateTo(
    double nextAngle, [
    int durationInMillis = animationTimeMillis,
  ]) async {
    // If the direct linear path between _controller.value and nextAngle
    // is shorter than half the circle (pi radians), directly animate to nextAngle
    if ((thetaController.value - nextAngle).abs() < math.pi) {
      await thetaController.animateTo(
        nextAngle,
        duration: Duration(milliseconds: durationInMillis),
      );
    } else {
      late final double duration1;
      if (thetaController.value <= math.pi) {
        duration1 = durationInMillis *
            ((thetaController.value - thetaController.lowerBound) /
                ((thetaController.value - thetaController.lowerBound) +
                    (thetaController.upperBound - nextAngle)));
        await thetaController.animateTo(
          thetaController.lowerBound,
          duration: Duration(milliseconds: duration1.round()),
        );
        thetaController.value = thetaController.upperBound;
      } else {
        duration1 = durationInMillis *
            ((thetaController.upperBound - thetaController.value) /
                ((thetaController.upperBound - thetaController.value) +
                    (nextAngle - thetaController.lowerBound)));
        await thetaController.animateTo(
          thetaController.upperBound,
          duration: Duration(milliseconds: duration1.round()),
        );
        thetaController.value = thetaController.lowerBound;
      }
      await thetaController.animateTo(
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

  double normalizeAlphaForYCalculations(double valueInRadians) {
    valueInRadians = valueInRadians % (math.pi * 2);
    if (valueInRadians >= 0 && valueInRadians <= math.pi / 2) {
      return valueInRadians;
    } else if (valueInRadians <= math.pi) {
      return math.pi - valueInRadians;
    } else if (valueInRadians <= (3 * math.pi / 2)) {
      return math.pi - valueInRadians;
    } else {
      return valueInRadians - (2 * math.pi);
    }
  }

  double initialPosition = 0;

  double getThetaOffset(int index) =>
      (thetaController.value + (index * _stepAngle)) % (2 * math.pi);

  double getXTranslation(int index) =>
      widget.radius * math.sin(getThetaOffset(index));
  // (widget.clockwise ? -1 : 1); // TODO : Consider clockwise-ness

  double getYTranslation(int index) =>
      widget.radius *
      math.sin(alphaController.value) *
      math.cos(getThetaOffset(index));

  double getZTranslation(int index) =>
      widget.radius - (widget.radius * getZFraction(index));

  double getZFraction(int index) =>
      math.cos(getThetaOffset(index)) * math.cos(alphaController.value);

  double getYRotation(int index) {
    if (widget.childrenAreAlwaysFacingForward) {
      return 0;
    } else {
      double absYRotation = getAbsYRotation(index);
      if (getZFraction(index) >= 0) {
        return absYRotation;
      } else {
        return math.pi - absYRotation;
      }
    }
  }

  double getXRotation(int index) {
    if (widget.childrenAreAlwaysFacingForward) {
      return 0;
    } else {
      double absXRotation = getAbsXRotation(index);
      if (getZFraction(index) >= 0) {
        return absXRotation;
      } else {
        return math.pi - absXRotation;
      }
    }
  }

  double getAbsYRotation(int index) => -math.asin(double.parse(
      (getXTranslation(index) / getMaxXWidthAtIndex(index))
          .toStringAsFixed(4)));

  double getAbsXRotation(int index) => math.asin(double.parse(
      (getYTranslation(index) / getMaxYHeightAtIndex(index))
          .toStringAsFixed(4)));

  double getMaxYHeightAtIndex(int index) =>
      math.sqrt(math.pow(widget.radius, 2) - getXTranslation(index));

  double getMaxXWidthAtIndex(int index) =>
      math.sqrt(math.pow(widget.radius, 2) - getYTranslation(index));

  double getZRotation(int index) =>
      widget.childrenAreAlwaysFacingForward ? 0 : 0;

  void onDragStart(DragStartDetails details) {
    final bool isDragHorizontal = widget.dragDirection == Axis.horizontal;

    initialPosition = isDragHorizontal
        ? details.globalPosition.dx
        : details.globalPosition.dy;
  }

  void onDragUpdate(DragUpdateDetails details) {
    final bool isDragHorizontal = widget.dragDirection == Axis.horizontal;

    final double dragDistance = initialPosition -
        (isDragHorizontal
            ? details.globalPosition.dx
            : details.globalPosition.dy);
    initialPosition = isDragHorizontal
        ? details.globalPosition.dx
        : details.globalPosition.dy;
    final double angleInRadian = widget.clockwise
        ? -_getAngleInRadFromXMovement(dragDistance)
        : _getAngleInRadFromXMovement(dragDistance);
    animateTo(
      (thetaController.value - angleInRadian) % (2 * math.pi),
      0,
    );
  }

  void onDragEnd(DragEndDetails details) {
    switch (widget.dragEndBehavior) {
      case DragEndBehavior.doNothing:
        break;
      case DragEndBehavior.snapToNearest:
        animateToClosestStep();
        break;
      case DragEndBehavior.continueRotating:
        if (widget.thetaShouldRotate) {
          thetaController.repeat();
        } else {
          animateToClosestStep();
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDragHorizontal = widget.dragDirection == Axis.horizontal;

    return GestureDetector(
      onTap: _onBackgroundTap,
      onHorizontalDragStart:
          widget.isDragInteractive && isDragHorizontal ? onDragStart : null,
      onHorizontalDragUpdate:
          widget.isDragInteractive && isDragHorizontal ? onDragUpdate : null,
      onHorizontalDragEnd:
          widget.isDragInteractive && isDragHorizontal ? onDragEnd : null,
      onVerticalDragStart:
          widget.isDragInteractive && !isDragHorizontal ? onDragStart : null,
      onVerticalDragUpdate:
          widget.isDragInteractive && !isDragHorizontal ? onDragUpdate : null,
      onVerticalDragEnd:
          widget.isDragInteractive && !isDragHorizontal ? onDragEnd : null,
      child: AnimatedBuilder(
        animation: Listenable.merge([thetaController, alphaController]),
        builder: (context, child) {
          List<(int, double)> indexToZDistance = [];
          for (int i = 0; i < widget.children.length; i++) {
            indexToZDistance.add((i, getZFraction(i)));
          }
          indexToZDistance.sort((a, b) => a.$2.compareTo(b.$2));

          int getIndexOf(int index) => indexToZDistance[index].$1;

          return ClipRect(
            clipBehavior: widget.clipBehavior,
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // To enable dragging on the empty background
                  const Positioned.fill(
                    child: ColoredBox(color: Colors.transparent),
                  ),

                  // Background widget
                  if (widget.background != null)
                    Positioned.fill(child: widget.background!),

                  // Back half of the carousel
                  if (!widget.hideBackground)
                    for (int i = 0; i < widget.children.length; i++)
                      if (indexToZDistance[i].$2 < 0)
                        _SubWidget(
                          scale: widget.childScale,
                          radius: widget.radius,
                          perspectiveStrength: widget.perspectiveStrength,
                          xTranslation: getXTranslation(getIndexOf(i)),
                          yTranslation: getYTranslation(getIndexOf(i)),
                          zTranslation: getZTranslation(getIndexOf(i)),
                          yRotation: getYRotation(getIndexOf(i)),
                          xRotation: getXRotation(getIndexOf(i)),
                          zRotation: getZRotation(getIndexOf(i)),
                          child: widget.children[getIndexOf(i)].child,
                          onTap: () {
                            switch (widget.childTapBehavior) {
                              case ChildTapBehavior.doNothing:
                                break;
                              case ChildTapBehavior.transparent:
                                _onBackgroundTap();
                                break;
                              case ChildTapBehavior.stopAndSnapToChild:
                                animateToStep(getIndexOf(i));
                                break;
                            }
                            if (widget.children[getIndexOf(i)].onTap != null) {
                              widget.children[getIndexOf(i)].onTap!();
                            }
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
                  if (!widget.hideForeground)
                    for (int i = 0; i < widget.children.length; i++)
                      if (indexToZDistance[i].$2 >= 0)
                        _SubWidget(
                          scale: widget.childScale,
                          radius: widget.radius,
                          perspectiveStrength: widget.perspectiveStrength,
                          xTranslation: getXTranslation(getIndexOf(i)),
                          yTranslation: getYTranslation(getIndexOf(i)),
                          zTranslation: getZTranslation(getIndexOf(i)),
                          yRotation: getYRotation(getIndexOf(i)),
                          xRotation: getXRotation(getIndexOf(i)),
                          zRotation: getZRotation(getIndexOf(i)),
                          child: widget.children[getIndexOf(i)].child,
                          onTap: () {
                            switch (widget.childTapBehavior) {
                              case ChildTapBehavior.doNothing:
                                break;
                              case ChildTapBehavior.transparent:
                                _onBackgroundTap();
                                break;
                              case ChildTapBehavior.stopAndSnapToChild:
                                animateToStep(getIndexOf(i));
                                break;
                            }
                            if (widget.children[getIndexOf(i)].onTap != null) {
                              widget.children[getIndexOf(i)].onTap!();
                            }
                          },
                        ),

                  //TODO:
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        (getXRotation(0)).toStringAsFixed(2),
                        style: TextStyle(fontSize: 30),
                      ),
                      const SizedBox(height: 200),
                      // Text(
                      //   (math.asin(getXTranslation(0) / getMaxXWidthAtIndex(0)) * 180 / math.pi)
                      //       .toStringAsFixed(2),
                      //   style: TextStyle(fontSize: 30),
                      // ),
                      // Text(
                      //   (getZFraction(0)).toStringAsFixed(2),
                      //   style: TextStyle(fontSize: 30),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onBackgroundTap() {
    switch (widget.backgroundTapBehavior) {
      case BackgroundTapBehavior.startAndSnapToNearest:
        if (!thetaIsAnimating) {
          thetaController.repeat();
        } else {
          animateToClosestStep();
        }
        break;
      case BackgroundTapBehavior.startAndFreeze:
        if (!thetaIsAnimating) {
          thetaController.repeat();
        } else {
          thetaController.value = thetaController.value;
        }
        break;
      case BackgroundTapBehavior.none:
        break;
    }
  }
}
