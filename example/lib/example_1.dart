import 'package:flutter/material.dart';
import 'package:flutter_3d_carousel/flutter_3d_carousel.dart';

class Example1 extends StatelessWidget {
  const Example1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarouselWidget3D(
        radius: MediaQuery.sizeOf(context).width,
        childScale: 0.9,
        dragEndBehavior: DragEndBehavior.snapToNearest,
        backgroundTapBehavior: BackgroundTapBehavior.startAndSnapToNearest,
        childTapBehavior: ChildTapBehavior.transparent,
        isDragInteractive: true,
        onlyRenderForeground: false,
        clockwise: false,
        backgroundBlur: 3,
        spinWhileRotating: true,
        shouldRotate: true,
        timeForFullRevolution: 20000,
        snapTimeInMillis: 100,
        perspectiveStrength: 0.001,
        dragSensitivity: 1.0,
        onValueChanged: (newValue) {
          // print(newValue);
        },
        background: null,
        core: null,
        children: List.generate(
          colors.length,
              (index) => CarouselChild(
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              color: colors[index],
            ),
          ),
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
