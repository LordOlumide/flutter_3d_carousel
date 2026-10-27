// More examples can be found in this repo: https://github.com/LordOlumide/flutter_3d_carousel_example

import 'dart:math' as math;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_3d_carousel/flutter_3d_carousel.dart';

class Example1 extends StatelessWidget {
  const Example1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    'Horizontal Carousel',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Expanded(
                  child: CarouselWidget3D.horizontal(
                    radius: MediaQuery.sizeOf(context).width / 2,
                    roll: LinearInputFunction(gradient: math.pi / 12),
                    children: List.generate(
                      colors.length,
                      (index) => CarouselChild(
                        child: Container(
                          width: MediaQuery.sizeOf(context).width / 2,
                          height: MediaQuery.sizeOf(context).height / 4,
                          color: colors[index],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    'Vertical Carousel',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Expanded(
                  child: CarouselWidget3D.vertical(
                    radius: MediaQuery.sizeOf(context).width / 2,
                    roll: LinearInputFunction(gradient: math.pi / 12),
                    children: List.generate(
                      colors.length,
                      (index) => CarouselChild(
                        child: Container(
                          width: MediaQuery.sizeOf(context).width / 2,
                          height: MediaQuery.sizeOf(context).height / 4,
                          color: colors[index],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Example2 extends StatefulWidget {
  const Example2({super.key});

  @override
  State<Example2> createState() => _Example2State();
}

class _Example2State extends State<Example2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text('Roll', style: TextStyle(fontSize: 25)),
                ),
                Expanded(
                  child: CarouselWidget3D(
                    radius: 70,
                    backgroundBlur: 0,
                    backgroundTapBehavior: BackgroundTapBehavior.none,
                    childTapBehavior: ChildTapBehavior.doNothing,
                    dragBehaviour: DragBehaviour.none,
                    roll: LinearInputFunction(gradient: math.pi / 3),
                    core: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue, width: 3),
                      ),
                    ),
                    children: List.generate(colors.length * 3, (index) {
                      return CarouselChild(
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: colors[index % colors.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text('Pitch', style: TextStyle(fontSize: 25)),
                ),
                Expanded(
                  child: CarouselWidget3D(
                    radius: 70,
                    backgroundBlur: 0,
                    backgroundTapBehavior: BackgroundTapBehavior.none,
                    childTapBehavior: ChildTapBehavior.doNothing,
                    dragBehaviour: DragBehaviour.none,
                    pitch: LinearInputFunction(gradient: math.pi / 3),
                    core: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue, width: 3),
                      ),
                    ),
                    children: List.generate(colors.length * 3, (index) {
                      return CarouselChild(
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: colors[index % colors.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Yaw (with pitch at 45 degrees)',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Expanded(
                  child: CarouselWidget3D(
                    radius: 70,
                    backgroundBlur: 0,
                    backgroundTapBehavior: BackgroundTapBehavior.none,
                    childTapBehavior: ChildTapBehavior.doNothing,
                    dragBehaviour: DragBehaviour.none,
                    pitch: LinearInputFunction(initialValue: math.pi / 4),
                    yaw: LinearInputFunction(gradient: math.pi / 3),
                    core: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue, width: 3),
                      ),
                    ),
                    children: List.generate(colors.length * 3, (index) {
                      return CarouselChild(
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: colors[index % colors.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
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

class Example3 extends StatefulWidget {
  const Example3({super.key});

  @override
  State<Example3> createState() => _Example3State();
}

class _Example3State extends State<Example3> {
  final List<String> _values = ['Roll', 'Pitch', 'Yaw'];
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _values.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                'Intermittent Input Function example',
                style: TextStyle(fontSize: 25),
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 3, color: Colors.red),
                    ),
                  ),
                  CarouselWidget3D(
                    radius: 200,
                    roll: IntermittentInputFunction(
                      motionFunction: LinearInputFunction(
                        gradient: math.pi / 2.6,
                        initialValue: 0,
                      ),
                      movementDuration: const Duration(seconds: 2),
                      pauseDuration: const Duration(seconds: 4),
                      timeOffset: const Duration(seconds: 0),
                    ),
                    pitch: IntermittentInputFunction(
                      motionFunction: LinearInputFunction(
                        gradient: math.pi / 2.5,
                        initialValue: 0,
                      ),
                      movementDuration: const Duration(seconds: 2),
                      pauseDuration: const Duration(seconds: 4),
                      timeOffset: const Duration(seconds: 2),
                    ),
                    yaw: IntermittentInputFunction(
                      motionFunction: LinearInputFunction(
                        gradient: math.pi / 2,
                        initialValue: 0,
                      ),
                      movementDuration: const Duration(seconds: 2),
                      pauseDuration: const Duration(seconds: 4),
                      timeOffset: const Duration(seconds: 4),
                    ),
                    children: List.generate(
                      20,
                      (index) => CarouselChild(
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.rectangle,
                            border: Border.all(),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                      ),
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
