import 'package:flutter/material.dart';
import 'package:flutter_3d_carousel/flutter_3d_carousel.dart';

class Example2 extends StatefulWidget {
  const Example2({super.key});

  @override
  State<Example2> createState() => _Example2State();
}

class _Example2State extends State<Example2> {
  Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: Container(color: Colors.blue)),
          Expanded(
            child: CarouselWidget3D(
              radius: MediaQuery.sizeOf(context).width / 2,
              childScale: 0.7,
              dragEndBehavior: DragEndBehavior.snapToNearest,
              backgroundTapBehavior:
              BackgroundTapBehavior.startAndSnapToNearest,
              childTapBehavior: ChildTapBehavior.stopAndSnapToChild,
              isDragInteractive: true,
              onlyRenderForeground: false,
              clockwise: false,
              backgroundBlur: 3,
              spinWhileRotating: false,
              shouldRotate: true,
              timeForFullRevolution: 12000,
              snapTimeInMillis: 100,
              perspectiveStrength: 0.001,
              dragSensitivity: 1.5,
              onValueChanged: (newValue) {
                // print(newValue);
              },
              background: Image.asset(
                'assets/images/background_1.jpg',
                fit: BoxFit.cover,
              ),
              core: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.yellow,
                ),
              ),
              children: List.generate(colors.length, (index) {
                return CarouselChild(
                  child: Container(
                    width: MediaQuery.sizeOf(context).width / 3,
                    height: MediaQuery.sizeOf(context).height / 3,
                    decoration: BoxDecoration(
                      color: colors[index],
                      shape: BoxShape.circle,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedColor = colors[index];
                    });
                  },
                );
              }),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.indigo,
              alignment: Alignment.center,
              child: Container(
                width: 150,
                height: 150,
                color: selectedColor ?? Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<Color> colors = [
  Colors.lightBlue,
  Colors.greenAccent,
  Colors.teal,
  Colors.grey,
  Colors.orangeAccent,
  Colors.purple,
  Colors.red,
  Colors.brown,
  Colors.pink,
];
