import 'dart:math' as math;
import 'dart:ui';
import 'package:vector_math/vector_math_64.dart' as vector_math hide Colors;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_3d_carousel/src/models/models.dart';
import 'package:flutter_3d_carousel/src/utils/utils.dart';

part 'sub_widget.dart';

// TODO: Create Presets: .horizontal, .vertical, .spinning

// TODO: Show guiding axes

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

  /// Determines how the carousel behaves after the background is tapped. See [BackgroundTapBehavior] for available options.
  ///
  /// Defaults to [BackgroundTapBehavior.none]
  final BackgroundTapBehavior backgroundTapBehavior;

  /// Determines how the carousel behaves after a child is tapped. See [ChildTapBehavior] for available options.
  ///
  /// Defaults to [ChildTapBehavior.stopAndSnapToChild]
  final ChildTapBehavior childTapBehavior;

  /// Whether the carousel should respond to drag gestures.
  ///
  /// Defaults to true
  final bool isDragInteractive;

  /// Determines how the carousel behaves after a drag interaction ends. See [DragEndBehavior] for available options.
  ///
  /// Defaults to [DragEndBehavior.snapToNearest]
  final DragEndBehavior dragEndBehavior;

  /// Whether only widgets in the front half of the carousel should be rendered
  ///
  /// Defaults to false
  final bool hideForeground;

  /// Whether only widgets in the back half of the carousel should be rendered
  ///
  /// Defaults to false
  final bool hideBackground;

  /// The amount of blur effect applied to background children.
  ///
  /// Defaults to 3.0
  final double backgroundBlur;

  /// The direction the children of the carousel will be oriented towards.
  ///
  /// Defaults to [ChildOrientation.backingCenter].
  final ChildOrientation childOrientation;

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

  /// The curve os the snap behaviour.
  final Curve snapCurve;

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
    this.backgroundTapBehavior = BackgroundTapBehavior.none,
    this.childTapBehavior = ChildTapBehavior.stopAndSnapToChild,
    this.isDragInteractive = true,
    this.dragEndBehavior = DragEndBehavior.snapToNearest,
    this.hideForeground = false,
    this.hideBackground = false,
    this.backgroundBlur = 3.0,
    this.childOrientation = ChildOrientation.backingCenter,
    this.roll = const ConstantInputFunction(value: 0),
    this.pitch = const ConstantInputFunction(value: 0),
    this.yaw = const ConstantInputFunction(value: 0),
    this.snapTimeInMillis = 100,
    this.snapCurve = Curves.linear,
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

// TODO: Programmatically freeze or move to the next and previous object in the carousel

class _CarouselWidget3DState extends State<CarouselWidget3D>
    with TickerProviderStateMixin {
  // The theta angle between successive elements in the carousel
  late double _stepAngle;

  // Instead of using AnimationController, we are using a Ticker object to track time progress
  late Ticker _ticker;
  Duration _elapsedTime = const Duration();

  late final AnimationController rollAngleController;
  late final AnimationController pitchAngleController;
  late final AnimationController yawAngleController;

  @override
  void initState() {
    super.initState();
    rollAngleController = AnimationController(
      vsync: this,
      value: 0,
      lowerBound: 0,
      upperBound: math.pi * 2,
    );
    pitchAngleController = AnimationController(
      vsync: this,
      value: 0,
      lowerBound: 0,
      upperBound: math.pi * 2,
    );
    yawAngleController = AnimationController(
      vsync: this,
      value: 0,
      lowerBound: 0,
      upperBound: math.pi * 2,
    );

    _stepAngle = (2 * math.pi) / widget.children.length;

    _ticker = createTicker((Duration elapsed) {
      _elapsedTime = elapsed;
      _getUpdatedAngles(elapsedTime: _elapsedTime);
    });

    _ticker.start();
  }

  @override
  void didUpdateWidget(covariant CarouselWidget3D oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Everything set up in `initState()` needs to be monitored here:

    if (widget.children.length != oldWidget.children.length) {
      _stepAngle = (2 * math.pi) / widget.children.length;
    }

    if (widget.roll != oldWidget.roll ||
        widget.pitch != oldWidget.pitch ||
        widget.yaw != oldWidget.yaw ||
        widget.childOrientation != oldWidget.childOrientation ||
        widget.snapCurve != oldWidget.snapCurve
    ) {
      // TODO: What to do if someone sets the motion to stop
      if (_ticker.isActive) {
        _restartTicker();
      }
    }
  }

  @override
  void dispose() {
    _ticker.stop(canceled: true);
    _ticker.dispose();

    rollAngleController.dispose();
    pitchAngleController.dispose();
    yawAngleController.dispose();

    super.dispose();
  }

  void _getUpdatedAngles({
    required Duration elapsedTime,
    double? newInitialRollValue,
    double? newInitialPitchValue,
    double? newInitialYawValue,
  }) {
    final double newRollAngle = widget.roll.getCurrentValue(
      elapsedTime: elapsedTime,
      newInitialValue: newInitialRollValue,
    );
    final double newPitchAngle = widget.pitch.getCurrentValue(
      elapsedTime: elapsedTime,
      newInitialValue: newInitialPitchValue,
    );
    final double newYawAngle = widget.yaw.getCurrentValue(
      elapsedTime: elapsedTime,
      newInitialValue: newInitialYawValue,
    );

    if (widget.onRollAngleChanged != null &&
        rollAngleController.value != newRollAngle) {
      widget.onRollAngleChanged!(newRollAngle);
    }
    if (widget.onPitchAngleChanged != null &&
        pitchAngleController.value != newPitchAngle) {
      widget.onPitchAngleChanged!(newPitchAngle);
    }
    if (widget.onYawAngleChanged != null &&
        yawAngleController.value != newYawAngle) {
      widget.onYawAngleChanged!(newYawAngle);
    }

    rollAngleController.value = newRollAngle;
    pitchAngleController.value = newPitchAngle;
    yawAngleController.value = newYawAngle;
  }

  void _restartTicker() {
    final double newInitialRollValue = rollAngleController.value;
    final double newInitialPitchValue = pitchAngleController.value;
    final double newInitialYawValue = yawAngleController.value;

    _ticker = createTicker((Duration elapsed) {
      _elapsedTime = elapsed;
      _getUpdatedAngles(
        elapsedTime: elapsed,
        newInitialRollValue: newInitialRollValue,
        newInitialPitchValue: newInitialPitchValue,
        newInitialYawValue: newInitialYawValue,
      );
    });
    _ticker.start();
  }

  void _onBackgroundTap() {
    switch (widget.backgroundTapBehavior) {
      case BackgroundTapBehavior.startOrSnapToNearest:
        if (_ticker.isActive) {
          _ticker.stop();
          animateToClosestStep();
        } else {
          _restartTicker();
        }
        break;
      case BackgroundTapBehavior.startOrFreeze:
        if (_ticker.isActive) {
          _ticker.stop();
        } else {
          _restartTicker();
        }
        break;
      case BackgroundTapBehavior.none:
        break;
    }
  }

  void _onChildTap(int index) {
    switch (widget.childTapBehavior) {
      case ChildTapBehavior.doNothing:
        break;
      case ChildTapBehavior.transparent:
        _onBackgroundTap();
        break;
      case ChildTapBehavior.stopAndSnapToChild:
        bringItemIntoFocus(index);
        break;
    }
    if (widget.children[index].onTap != null) {
      widget.children[index].onTap!();
    }
  }

  Future<void> animateToClosestStep() async {
    if (widget.children.isEmpty) return;

    // Find the index with the zTranslation closest to -1.0
    (int, double) indexAndZTranslation = (0, 0);
    for (int i = 0; i < widget.children.length; i++) {
      double zTranslation = getZTranslation(i);
      if (zTranslation < indexAndZTranslation.$2) {
        indexAndZTranslation = (i, zTranslation);
      }
    }
    await bringItemIntoFocus(indexAndZTranslation.$1);
  }

  // This function should bring the item to the center of the carousel,
  // to the closest location to the user.
  // It could be implemented in different ways, that is, in what axis
  // position should the carousel come to rest in?
  // We can add more customization options later for the user to define the behaviour.
  // TODO: FIXXXXXXX
  Future<void> bringItemIntoFocus(int index) async {
    await animateTo(
      angleController: rollAngleController,
      newAngle:
          ((math.pi * 2) - (index * _stepAngle) + widget.roll.initialValue) %
              (2 * math.pi),
    );
  }

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

  Future<void> animateTo({
    required AnimationController angleController,
    required double newAngle,
  }) async {
    // If the direct linear path between _controller.value and the target angle
    // is shorter than half the circle (pi radians), directly animate to the target angle
    if ((angleController.value - newAngle).abs() < math.pi) {
      await angleController.animateTo(
        newAngle,
        duration: Duration(milliseconds: widget.snapTimeInMillis),
        curve: widget.snapCurve,
      );
    } else {
      late final double duration1;
      if (angleController.value <= math.pi) {
        duration1 = widget.snapTimeInMillis *
            ((angleController.value - angleController.lowerBound) /
                ((angleController.value - angleController.lowerBound) +
                    (angleController.upperBound - newAngle)));
        await angleController.animateTo(
          angleController.lowerBound,
          duration: Duration(milliseconds: duration1.round()),
          curve: widget.snapCurve,
        );
        angleController.value = angleController.upperBound;
      } else {
        duration1 = widget.snapTimeInMillis *
            ((angleController.upperBound - angleController.value) /
                ((angleController.upperBound - angleController.value) +
                    (newAngle - angleController.lowerBound)));
        await angleController.animateTo(
          angleController.upperBound,
          duration: Duration(milliseconds: duration1.round()),
          curve: widget.snapCurve,
        );
        angleController.value = angleController.lowerBound;
      }
      await angleController.animateTo(
        newAngle,
        duration: Duration(
          milliseconds: widget.snapTimeInMillis - duration1.round(),
        ),
        curve: widget.snapCurve,
      );
    }
  }

  (double, double) initialDragPosition = (0, 0);

  void onDragStart(DragStartDetails details) {
    initialDragPosition = (
      details.globalPosition.dx,
      details.globalPosition.dy,
    );
  }

  void onDragUpdate(DragUpdateDetails details) {
    final (double, double) dragDistance = (
      initialDragPosition.$1 - details.globalPosition.dx,
      initialDragPosition.$2 - details.globalPosition.dy,
    );
    initialDragPosition = (
      details.globalPosition.dx,
      details.globalPosition.dy,
    );

    // Length of an arc = radius * central angle in radians
    final double horizontalAngleChange =
        (dragDistance.$1 / widget.radius) * widget.dragSensitivity;
    final double verticalAngleChange =
        (dragDistance.$1 / widget.radius) * widget.dragSensitivity;

    // TODO:
    // animateTo(
    //   (thetaController.value - angleInRadian) % (2 * math.pi),
    //   0,
    // );
  }

  void onDragEnd(DragEndDetails details) {
    switch (widget.dragEndBehavior) {
      case DragEndBehavior.remainFrozen:
        break;
      case DragEndBehavior.snapToNearest:
        animateToClosestStep();
        break;
      case DragEndBehavior.returnToDefault:
        _restartTicker();
        break;
    }
  }

  double getRollOffset(int index) =>
      (rollAngleController.value + (index * _stepAngle)) % (2 * math.pi);

  // The translation of the objects in the carousel is represented by the
  // last column of Transformation1.
  final Transformation positionTransformation = Transformation1();

  double getXTranslation(int index) =>
      -widget.radius *
      positionTransformation.get20(
        rollAngle: getRollOffset(index),
        pitchAngle: pitchAngleController.value,
        yawAngle: yawAngleController.value,
      );

  double getYTranslation(int index) =>
      -widget.radius *
      positionTransformation.get21(
        rollAngle: getRollOffset(index),
        pitchAngle: pitchAngleController.value,
        yawAngle: yawAngleController.value,
      );

  double getZTranslation(int index) =>
      -widget.radius *
      positionTransformation.get22(
        rollAngle: getRollOffset(index),
        pitchAngle: pitchAngleController.value,
        yawAngle: yawAngleController.value,
      );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([
          rollAngleController,
          pitchAngleController,
          yawAngleController,
        ]),
        builder: (context, child) {
          // To render them in order of how far they are to the screen
          List<(int, double)> indexToZDistance = [];
          for (int i = 0; i < widget.children.length; i++) {
            indexToZDistance.add((i, getZTranslation(i)));
          }
          indexToZDistance.sort((a, b) => b.$2.compareTo(a.$2));

          int getIndexOf(int index) => indexToZDistance[index].$1;

          return GestureDetector(
            onTap: _onBackgroundTap,
            onHorizontalDragStart:
                widget.isDragInteractive ? onDragStart : null,
            onHorizontalDragUpdate:
                widget.isDragInteractive ? onDragUpdate : null,
            onHorizontalDragEnd: widget.isDragInteractive ? onDragEnd : null,
            onVerticalDragStart: widget.isDragInteractive ? onDragStart : null,
            onVerticalDragUpdate:
                widget.isDragInteractive ? onDragUpdate : null,
            onVerticalDragEnd: widget.isDragInteractive ? onDragEnd : null,
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
                            pitchAngle: pitchAngleController.value,
                            yawAngle: yawAngleController.value,
                            childOrientation: widget.childOrientation,
                            child: widget.children[getIndexOf(i)].child,
                            onTap: () => _onChildTap(getIndexOf(i)),
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
                            pitchAngle: pitchAngleController.value,
                            yawAngle: yawAngleController.value,
                            childOrientation: widget.childOrientation,
                            child: widget.children[getIndexOf(i)].child,
                            onTap: () => _onChildTap(getIndexOf(i)),
                          ),

                    // // For debugging
                    // Column(
                    //   mainAxisSize: MainAxisSize.min,
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       (getZTranslation(0) / widget.radius)
                    //           .toStringAsFixed(2),
                    //       style: TextStyle(fontSize: 30),
                    //     ),
                    //     // Text(
                    //     //   (getRollOffset(0) * 180 / math.pi).toStringAsFixed(2),
                    //     //   style: TextStyle(fontSize: 30),
                    //     // ),
                    //     const SizedBox(height: 300),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
