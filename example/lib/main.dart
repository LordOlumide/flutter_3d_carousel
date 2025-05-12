import 'package:flutter_3d_carousel/flutter_3d_carousel.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CarouselWidget3D(
          radius: MediaQuery.sizeOf(context).width,
          childScale: 0.9,
          backgroundBlur: 3,
          dragEndBehavior: DragEndBehavior.snapToNearest,
          tapBehavior: TapBehavior.startAndFreeze,
          isDragInteractive: true,
          shouldRotate: true,
          spinWhileRotating: true,
          timeForFullRevolution: 20000,
          snapTimeInMillis: 100,
          perspectiveStrength: 0.001,
          dragSensitivity: 1.0,
          onValueChanged: (newValue) {
            // ignore: avoid_print
            print(newValue);
          },
          children: List.generate(
            colors.length,
                (index) => Container(
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
