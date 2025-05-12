import 'dart:math' as math;

import 'package:_3d_carousel/src/features/models/drag_behaviour.dart';
import 'package:flutter/material.dart';
import 'package:_3d_carousel/src/features/features.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<(Color color, String asset)> screens = List.generate(
    6,
    (index) => (colors[index], 'assets/images/0${index + 1}.jpg'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              child: CarouselWidget3D(
                radius: MediaQuery.sizeOf(context).width / 3,
                childScale: 0.7,
                backgroundBlur: 5,
                dragEndBehavior: DragEndBehavior.snapToNearest,
                shouldRotateInfinitely: true,
                spinWhileRotating: true,
                children: List.generate(
                  screens.length,
                  (index) => SingleDisplayWidget(
                    backgroundColor: screens[index].$1,
                    assetPath: screens[index].$2,
                    // onForwardPressed: animateToPreviousStep,
                    // onBackPressed: animateToNextStep,
                    onForwardPressed: () {},
                    onBackPressed: () {},
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.sizeOf(context).height / 15,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // IconButton(
                  //   onPressed:
                  //       isRotating && !isDragging
                  //           ? _stopInfiniteRotation
                  //           : _rotateInfinitely,
                  //   icon: Icon(
                  //     isRotating && !isDragging
                  //         ? Icons.cancel_outlined
                  //         : Icons.rotate_left,
                  //     size: 30,
                  //   ),
                  // ),
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
