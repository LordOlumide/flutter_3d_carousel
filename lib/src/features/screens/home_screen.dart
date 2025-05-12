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
                radius: MediaQuery.sizeOf(context).width,
                childScale: 0.7,
                backgroundBlur: 3,
                dragEndBehavior: DragEndBehavior.continueRotating,
                shouldRotate: false,
                isDragInteractive: true,
                spinWhileRotating: true,
                timeForFullRevolution: 30000,
                onValueChanged: (newValue) {
                  print(newValue);
                },
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
