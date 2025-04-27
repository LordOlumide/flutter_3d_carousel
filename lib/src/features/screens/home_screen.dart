import 'package:_3d_onboarding_animation/src/features/features.dart';
import 'package:flutter/material.dart';

List<Color> colors = [
  Colors.lightBlue,
  Colors.greenAccent,
  Colors.indigo,
  Colors.grey,
  Colors.yellow,
  Colors.purple,
];

List<Widget> carouselChildren = List.generate(
  6,
  (index) => SingleDisplayWidget(
    backgroundColor: colors[index],
    assetPath: 'assets/images/0${index + 1}.jpg',
    onForwardPressed: () {},
    onBackPressed: () {},
  ),
);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CarouselWidget3D(
          radius: MediaQuery.sizeOf(context).width,
          childScale: 0.6,
          children: carouselChildren,
        ),
      ),
    );
  }
}
