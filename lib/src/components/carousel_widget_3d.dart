import 'dart:math' as math;
import 'dart:ui';
import 'package:vector_math/vector_math_64.dart' as vector_math hide Colors;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_3d_carousel/src/models/models.dart';
import 'package:flutter_3d_carousel/src/utils/utils.dart';

part 'sub_widget.dart';

// TODO: Create Presets: .horizontal, .vertical, .spinning

/// A 3D carousel widget that displays children in a circular arrangement with
/// 3D perspective effects and interactive rotation.
///
/// There are 3 degrees of movement: roll, pitch, yaw.
/// To understand how they work, check out this article // TODO: Write article
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

  // /// Determines how the carousel behaves after a drag interaction ends. See [DragEndBehavior] for available options.
  // ///
  // /// Defaults to [DragEndBehavior.snapToNearest]
  // final DragEndBehavior dragEndBehavior;

  // /// Determines how the carousel behaves after the background is tapped. See [BackgroundTapBehavior] for available options.
  // ///
  // /// Defaults to [BackgroundTapBehavior.startAndSnapToNearest]
  // final BackgroundTapBehavior backgroundTapBehavior;

  // /// Determines how the carousel behaves after a child is tapped. See [ChildTapBehavior] for available options.
  // ///
  // /// Defaults to [ChildTapBehavior.stopAndSnapToChild]
  // final ChildTapBehavior childTapBehavior;

  // /// Whether the carousel should respond to drag gestures.
  // ///
  // /// Defaults to true
  // final bool isDragInteractive;

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

  // /// Whether it is a horizontal carousel or a vertical carousel.
  // ///
  // /// Defaults to [Axis.horizontal]
  // final Axis dragDirection;

  /// The amount of blur effect applied to background children.
  ///
  /// Defaults to 3.0
  final double backgroundBlur;

  /// TODO: Whether the children of the carousel should spin with the carousel.
  /// If false, the children of the carousel will change orientation with it and always be facing outwards from the center of the carousel.
  /// If true, the children will always be facing forward (facing the camera or viewer).
  ///
  /// Defaults to true
  final bool childrenAreAlwaysFacingForward;

  /// This function sets the rotation of the axis around its own longitudinal line.
  ///
  /// Defaults to [ConstantInputFunction] with a value of 0.
  final InputFunction roll;

  /// This function sets the tilt or elevation relative to the vertical axis.
  ///
  /// Defaults to [ConstantInputFunction] with a value of 0.
  final InputFunction pitch;

  /// This function sets the direction the axis points in the horizontal plane.
  ///
  /// Defaults to [ConstantInputFunction] with a value of 0.
  final InputFunction yaw;

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

  /// Determines how the edges of the carousel area will be clipped.
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// Called whenever the roll angle is updated.
  final Function(double)? onRollAngleChanged;

  /// Called whenever the pitch angle is updated.
  final Function(double)? onPitchAngleChanged;

  /// Called whenever the yaw angle is updated.
  final Function(double)? onYawAngleChanged;

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
    this.childScale = 1.0,
    // this.dragEndBehavior = DragEndBehavior.snapToNearest,
    // this.backgroundTapBehavior = BackgroundTapBehavior.startAndSnapToNearest,
    // this.childTapBehavior = ChildTapBehavior.stopAndSnapToChild,
    // this.isDragInteractive = true,
    this.hideForeground = false,
    this.hideBackground = false,
    this.clockwise = false,
    // this.dragDirection = Axis.horizontal,
    this.backgroundBlur = 3.0,
    this.childrenAreAlwaysFacingForward = false,
    this.roll = const ConstantInputFunction(value: 0),
    this.pitch = const ConstantInputFunction(value: 0),
    this.yaw = const ConstantInputFunction(value: 0),
    this.snapTimeInMillis = 100,
    this.perspectiveStrength = 0.001,
    this.dragSensitivity = 1.0,
    this.clipBehavior = Clip.hardEdge,
    this.onRollAngleChanged,
    this.onPitchAngleChanged,
    this.onYawAngleChanged,
    this.background,
    this.core,
    required this.children,
  });

  @override
  State<CarouselWidget3D> createState() => _CarouselWidget3DState();
}

// TODO: Handle all Gesture Responses

// TODO: Make the carousel able to display orientation facing the moving axis

class _CarouselWidget3DState extends State<CarouselWidget3D>
    with SingleTickerProviderStateMixin {
  // The theta angle between successive elements in the carousel
  late double _stepAngle;

  // Instead of using AnimationController, we are using a Ticker object to track time progress
  late final Ticker _ticker;
  Duration _elapsedTime = Duration();

  double rollAngle = 0;
  double pitchAngle = 0;
  double yawAngle = 0;

  @override
  void initState() {
    super.initState();
    _stepAngle = (2 * math.pi) / widget.children.length;

    _ticker = createTicker((Duration elapsed) {
      setState(() {
        _elapsedTime = elapsed;
        _getUpdatedAngles(elapsed);
      });
    });

    _ticker.start();
  }

  // @override
  // void didUpdateWidget(covariant CarouselWidget3D oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //
  //   // Everything set up in `initState()` needs to be monitored here:
  //
  //   if (widget.children.length != oldWidget.children.length) {
  //     _stepAngle = (2 * math.pi) / widget.children.length;
  //   }
  //
  //   if (widget.timeForFullRevolution != oldWidget.timeForFullRevolution) {
  //     thetaController.duration =
  //         Duration(milliseconds: widget.timeForFullRevolution);
  //   }
  //
  //   if (widget.thetaShouldRotate != oldWidget.thetaShouldRotate) {
  //     widget.thetaShouldRotate
  //         ? thetaController.repeat()
  //         : animateToClosestStep();
  //   }
  //
  //   // Deliberately skipping the `initialTiltAngle, because that
  //   // _explicitly_ only applies during initialization
  //
  //   if (widget.tiltController.tiltAnimationTime !=
  //       oldWidget.tiltController.tiltAnimationTime) {
  //     alphaController.duration =
  //         Duration(milliseconds: widget.tiltController.tiltAnimationTime);
  //   }
  //
  //   if (widget.alphaShouldRotate != oldWidget.alphaShouldRotate) {
  //     widget.alphaShouldRotate
  //         ? alphaController.repeat()
  //         : alphaController.stop();
  //   }
  // }

  @override
  void dispose() {
    _ticker.dispose();

    super.dispose();
  }

  void _getUpdatedAngles(Duration elapsedTime) {
    final double newRollAngle =
        widget.roll.getCurrentValue(elapsedTime: elapsedTime);
    final double newPitchAngle =
        widget.pitch.getCurrentValue(elapsedTime: elapsedTime);
    final double newYawAngle =
        widget.yaw.getCurrentValue(elapsedTime: elapsedTime);

    if (widget.onRollAngleChanged != null && rollAngle != newRollAngle) {
      widget.onRollAngleChanged!(newRollAngle);
    }
    if (widget.onPitchAngleChanged != null && pitchAngle != newPitchAngle) {
      widget.onPitchAngleChanged!(newPitchAngle);
    }
    if (widget.onYawAngleChanged != null && yawAngle != newYawAngle) {
      widget.onYawAngleChanged!(newYawAngle);
    }

    rollAngle = newRollAngle;
    pitchAngle = newPitchAngle;
    yawAngle = newYawAngle;
  }

  // Future<void> animateToStep(int index) async {
  //   final double stepAngle = (2 * math.pi) - (index * _stepAngle);
  //   await animateTo(stepAngle, widget.snapTimeInMillis);
  // }
  //
  // Future<void> animateToClosestStep() async {
  //   final int closestStep = (thetaController.value / _stepAngle).round();
  //   final double closestStepAngle = closestStep * _stepAngle;
  //   await animateTo(closestStepAngle, widget.snapTimeInMillis);
  // }
  //
  // Future<void> animateToPreviousStep() async {
  //   final int currentStep = (thetaController.value / _stepAngle).round();
  //   final int nextStep = currentStep - 1;
  //   final double nextAngle = nextStep * _stepAngle;
  //   await animateTo(nextAngle);
  // }
  //
  // Future<void> animateToNextStep() async {
  //   final int currentStep = (thetaController.value / _stepAngle).round();
  //   final int nextStep = currentStep + 1;
  //   final double nextAngle = nextStep * _stepAngle;
  //   await animateTo(nextAngle);
  // }
  //
  // Future<void> animateTo(
  //   double nextAngle, [
  //   int durationInMillis = animationTimeMillis,
  // ]) async {
  //   // If the direct linear path between _controller.value and nextAngle
  //   // is shorter than half the circle (pi radians), directly animate to nextAngle
  //   if ((thetaController.value - nextAngle).abs() < math.pi) {
  //     await thetaController.animateTo(
  //       nextAngle,
  //       duration: Duration(milliseconds: durationInMillis),
  //     );
  //   } else {
  //     late final double duration1;
  //     if (thetaController.value <= math.pi) {
  //       duration1 = durationInMillis *
  //           ((thetaController.value - thetaController.lowerBound) /
  //               ((thetaController.value - thetaController.lowerBound) +
  //                   (thetaController.upperBound - nextAngle)));
  //       await thetaController.animateTo(
  //         thetaController.lowerBound,
  //         duration: Duration(milliseconds: duration1.round()),
  //       );
  //       thetaController.value = thetaController.upperBound;
  //     } else {
  //       duration1 = durationInMillis *
  //           ((thetaController.upperBound - thetaController.value) /
  //               ((thetaController.upperBound - thetaController.value) +
  //                   (nextAngle - thetaController.lowerBound)));
  //       await thetaController.animateTo(
  //         thetaController.upperBound,
  //         duration: Duration(milliseconds: duration1.round()),
  //       );
  //       thetaController.value = thetaController.lowerBound;
  //     }
  //     await thetaController.animateTo(
  //       nextAngle,
  //       duration: Duration(milliseconds: durationInMillis - duration1.round()),
  //     );
  //   }
  // }
  //
  // void onDragStart(DragStartDetails details) {
  //   final bool isDragHorizontal = widget.dragDirection == Axis.horizontal;
  //
  //   initialPosition = isDragHorizontal
  //       ? details.globalPosition.dx
  //       : details.globalPosition.dy;
  // }
  //
  // void onDragUpdate(DragUpdateDetails details) {
  //   final bool isDragHorizontal = widget.dragDirection == Axis.horizontal;
  //
  //   final double dragDistance = initialPosition -
  //       (isDragHorizontal
  //           ? details.globalPosition.dx
  //           : details.globalPosition.dy);
  //   initialPosition = isDragHorizontal
  //       ? details.globalPosition.dx
  //       : details.globalPosition.dy;
  //   final double angleInRadian = widget.clockwise
  //       ? -_getAngleInRadFromXMovement(dragDistance)
  //       : _getAngleInRadFromXMovement(dragDistance);
  //   animateTo(
  //     (thetaController.value - angleInRadian) % (2 * math.pi),
  //     0,
  //   );
  // }
  //
  // void onDragEnd(DragEndDetails details) {
  //   switch (widget.dragEndBehavior) {
  //     case DragEndBehavior.doNothing:
  //       break;
  //     case DragEndBehavior.snapToNearest:
  //       animateToClosestStep();
  //       break;
  //     case DragEndBehavior.continueRotating:
  //       if (widget.thetaShouldRotate) {
  //         thetaController.repeat();
  //       } else {
  //         animateToClosestStep();
  //       }
  //       break;
  //   }
  // }

  double getRollOffset(int index) =>
      (rollAngle + (index * _stepAngle)) % (2 * math.pi);

  double getXTranslation(int index) =>
      -widget.radius *
      Transformation.get20(
        rollAngle: getRollOffset(index),
        pitchAngle: pitchAngle,
        yawAngle: yawAngle,
      );

  double getYTranslation(int index) =>
      -widget.radius *
      Transformation.get21(
        rollAngle: getRollOffset(index),
        pitchAngle: pitchAngle,
        yawAngle: yawAngle,
      );

  double getZTranslation(int index) =>
      -widget.radius *
      Transformation.get22(
        rollAngle: getRollOffset(index),
        pitchAngle: pitchAngle,
        yawAngle: yawAngle,
      );

  @override
  Widget build(BuildContext context) {
    // To render them in order of how far they are to the
    List<(int, double)> indexToZDistance = [];
    for (int i = 0; i < widget.children.length; i++) {
      indexToZDistance.add((i, getZTranslation(i)));
    }
    indexToZDistance.sort((a, b) => b.$2.compareTo(a.$2));

    int getIndexOf(int index) => indexToZDistance[index].$1;

    return GestureDetector(
      onTap: _onBackgroundTap,
      // onHorizontalDragStart:
      //     widget.isDragInteractive && isDragHorizontal ? onDragStart : null,
      // onHorizontalDragUpdate:
      //     widget.isDragInteractive && isDragHorizontal ? onDragUpdate : null,
      // onHorizontalDragEnd:
      //     widget.isDragInteractive && isDragHorizontal ? onDragEnd : null,
      // onVerticalDragStart:
      //     widget.isDragInteractive && !isDragHorizontal ? onDragStart : null,
      // onVerticalDragUpdate:
      //     widget.isDragInteractive && !isDragHorizontal ? onDragUpdate : null,
      // onVerticalDragEnd:
      //     widget.isDragInteractive && !isDragHorizontal ? onDragEnd : null,
      child: ClipRect(
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
                  if (indexToZDistance[i].$2 >= 0)
                    _SubWidget(
                      scale: widget.childScale,
                      radius: widget.radius,
                      perspectiveStrength: widget.perspectiveStrength,
                      xTranslation: getXTranslation(getIndexOf(i)),
                      yTranslation: getYTranslation(getIndexOf(i)),
                      zTranslation: getZTranslation(getIndexOf(i)),
                      rollAngle: getRollOffset(getIndexOf(i)),
                      pitchAngle: pitchAngle,
                      yawAngle: yawAngle,
                      childrenAreAlwaysFacingForward:
                          widget.childrenAreAlwaysFacingForward,
                      child: widget.children[getIndexOf(i)].child,
                      onTap: () {
                        // switch (widget.childTapBehavior) {
                        //   case ChildTapBehavior.doNothing:
                        //     break;
                        //   case ChildTapBehavior.transparent:
                        //     _onBackgroundTap();
                        //     break;
                        //   case ChildTapBehavior.stopAndSnapToChild:
                        //     animateToStep(getIndexOf(i));
                        //     break;
                        // }
                        // if (widget.children[getIndexOf(i)].onTap != null) {
                        //   widget.children[getIndexOf(i)].onTap!();
                        // }
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
                  if (indexToZDistance[i].$2 < 0)
                    _SubWidget(
                      scale: widget.childScale,
                      radius: widget.radius,
                      perspectiveStrength: widget.perspectiveStrength,
                      xTranslation: getXTranslation(getIndexOf(i)),
                      yTranslation: getYTranslation(getIndexOf(i)),
                      zTranslation: getZTranslation(getIndexOf(i)),
                      rollAngle: getRollOffset(getIndexOf(i)),
                      pitchAngle: pitchAngle,
                      yawAngle: yawAngle,
                      childrenAreAlwaysFacingForward:
                          widget.childrenAreAlwaysFacingForward,
                      child: widget.children[getIndexOf(i)].child,
                      onTap: () {
                        // switch (widget.childTapBehavior) {
                        //   case ChildTapBehavior.doNothing:
                        //     break;
                        //   case ChildTapBehavior.transparent:
                        //     _onBackgroundTap();
                        //     break;
                        //   case ChildTapBehavior.stopAndSnapToChild:
                        //     animateToStep(getIndexOf(i));
                        //     break;
                        // }
                        // if (widget.children[getIndexOf(i)].onTap != null) {
                        //   widget.children[getIndexOf(i)].onTap!();
                        // }
                      },
                    ),

              //TODO:
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    (getZTranslation(0) / widget.radius).toStringAsFixed(2),
                    style: TextStyle(fontSize: 30),
                  ),
                  // Text(
                  //   (getRollOffset(0) * 180 / math.pi).toStringAsFixed(2),
                  //   style: TextStyle(fontSize: 30),
                  // ),
                  const SizedBox(height: 300),
                  // Text(
                  //   widget.pitch
                  //       .getCurrentValue(elapsedTime: _elapsedTime)
                  //       .toStringAsFixed(2),
                  //   style: TextStyle(fontSize: 30),
                  // ),
                  // const SizedBox(height: 100),
                  // Text(
                  //   widget.yaw
                  //       .getCurrentValue(elapsedTime: _elapsedTime)
                  //       .toStringAsFixed(2),
                  //   style: TextStyle(fontSize: 30),
                  // ),
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
      ),
    );
  }

  void _onBackgroundTap() {
    // switch (widget.backgroundTapBehavior) {
    //   case BackgroundTapBehavior.startAndSnapToNearest:
    //     if (!thetaIsAnimating) {
    //       thetaController.repeat();
    //     } else {
    //       animateToClosestStep();
    //     }
    //     break;
    //   case BackgroundTapBehavior.startAndFreeze:
    //     if (!thetaIsAnimating) {
    //       thetaController.repeat();
    //     } else {
    //       thetaController.value = thetaController.value;
    //     }
    //     break;
    //   case BackgroundTapBehavior.none:
    //     break;
    // }
  }
}
