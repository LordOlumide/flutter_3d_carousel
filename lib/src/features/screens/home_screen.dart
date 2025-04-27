import 'package:flutter/material.dart';
import 'package:_3d_onboarding_animation/src/features/components/components.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CarouselWidget3D(
          radius: MediaQuery.sizeOf(context).width,
          childScale: 0.6,
          children: [
            Scaffold(backgroundColor: Colors.lightBlue),
            Scaffold(backgroundColor: Colors.greenAccent),
            Scaffold(backgroundColor: Colors.indigo),
            Scaffold(backgroundColor: Colors.grey),
            Scaffold(backgroundColor: Colors.yellow),
            Scaffold(backgroundColor: Colors.purple),
          ],
        ),
      ),
    );
  }
}
