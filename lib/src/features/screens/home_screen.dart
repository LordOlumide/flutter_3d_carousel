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

  bool isRotating = false;

  void _rotateInfinitely() => _controller.repeat();

  void _stopInfiniteRotation() {
    animateToClosestStep();
  }

  void animateToClosestStep() {
    final int closestStep = (_controller.value / stepAngle).round();
    final double closestStepAngle = closestStep * stepAngle;
    if (closestStepAngle < _controller.value) {
      animateBackTo(closestStepAngle, 100);
    } else {
      animateForwardTo(closestStepAngle, 100);
    }
  }

  void animateToPreviousStep() {
    final int currentStep = (_controller.value / stepAngle).round();
    final int nextStep = currentStep - 1;
    final double nextAngle = nextStep * stepAngle;
    animateBackTo(nextAngle);
  }

  void animateToNextStep() {
    final int currentStep = (_controller.value / stepAngle).round();
    final int nextStep = currentStep + 1;
    final double nextAngle = nextStep * stepAngle;
    animateForwardTo(nextAngle);
  }

  void animateBackTo(
    double nextAngle, [
    int durationInMillis = animationTimeMillis,
  ]) {
    if (nextAngle >= _controller.lowerBound) {
      _controller.animateTo(
        nextAngle,
        duration: Duration(milliseconds: durationInMillis),
      );
    } else {
      _controller.animateTo(
        _controller.lowerBound,
        duration: const Duration(milliseconds: 0),
      );
      _controller.value = _controller.upperBound;
      _controller.animateTo(
        nextAngle % (2 * math.pi),
        duration: Duration(milliseconds: durationInMillis),
      );
    }
  }

  void animateForwardTo(
    double nextAngle, [
    int durationInMillis = animationTimeMillis,
  ]) {
    if (nextAngle <= _controller.upperBound) {
      _controller.animateTo(
        nextAngle,
        duration: Duration(milliseconds: durationInMillis),
      );
    } else {
      _controller.animateTo(
        _controller.upperBound,
        duration: const Duration(milliseconds: 0),
      );
      _controller.value = _controller.lowerBound;
      _controller.animateTo(
        nextAngle % (2 * math.pi),
        duration: Duration(milliseconds: durationInMillis),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CarouselWidget3D(
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
            Positioned(
              bottom: MediaQuery.sizeOf(context).height / 15,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed:
                        isRotating ? _stopInfiniteRotation : _rotateInfinitely,
                    icon: Icon(
                      isRotating ? Icons.cancel_outlined : Icons.rotate_left,
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
