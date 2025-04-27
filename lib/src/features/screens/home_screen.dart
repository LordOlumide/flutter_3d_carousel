import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:_3d_onboarding_animation/src/features/features.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final double stepAngle;

  static const int animationTimeMillis = 300;

  List<(Color color, String asset)> screens = List.generate(
    6,
    (index) => (colors[index], 'assets/images/0${index + 1}.jpg'),
  );

  bool isRotating = false;
  bool isDragging = false;

  double initialXPosition = 0;

  @override
  void initState() {
    super.initState();
    stepAngle = (2 * math.pi) / screens.length;

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
    final int closestStep = (_controller.value / stepAngle).round();
    final double closestStepAngle = closestStep * stepAngle;
    if (closestStepAngle < _controller.value) {
      await animateBackTo(closestStepAngle, 100);
    } else {
      await animateForwardTo(closestStepAngle, 100);
    }
  }

  Future<void> animateToPreviousStep() async {
    final int currentStep = (_controller.value / stepAngle).round();
    final int nextStep = currentStep - 1;
    final double nextAngle = nextStep * stepAngle;
    await animateBackTo(nextAngle);
  }

  Future<void> animateToNextStep() async {
    final int currentStep = (_controller.value / stepAngle).round();
    final int nextStep = currentStep + 1;
    final double nextAngle = nextStep * stepAngle;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onHorizontalDragStart: (details) {
                initialXPosition = details.globalPosition.dx;
                setState(() {
                  isDragging = true;
                });
              },
              onHorizontalDragUpdate: (details) {
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
              },
              onHorizontalDragEnd: (details) {
                animateToClosestStep().then((_) {
                  setState(() {
                    isDragging = false;
                  });
                });
              },
              child: CarouselWidget3D(
                radius: MediaQuery.sizeOf(context).width,
                childScale: 0.7,
                stepAngle: stepAngle,
                controller: _controller,
                children: List.generate(
                  screens.length,
                  (index) => SingleDisplayWidget(
                    backgroundColor: screens[index].$1,
                    assetPath: screens[index].$2,
                    onForwardPressed: animateToPreviousStep,
                    onBackPressed: animateToNextStep,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.sizeOf(context).height / 15,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed:
                        isRotating && !isDragging
                            ? _stopInfiniteRotation
                            : _rotateInfinitely,
                    icon: Icon(
                      isRotating && !isDragging
                          ? Icons.cancel_outlined
                          : Icons.rotate_left,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Color> colors = [
  Colors.lightBlue,
  Colors.greenAccent,
  Colors.indigo,
  Colors.grey,
  Colors.yellow,
  Colors.purple,
];
