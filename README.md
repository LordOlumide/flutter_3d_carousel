# flutter_3d_carousel

This is a 3d carousel animation project built in flutter. The 3D carousel responds to button clicks and swipes and can rotate infinitely.

It is implemented natively in flutter. No external dependencies are used.


## Example:

Basic Example:
```dart
  @override
  Widget build(BuildContext context) {
    return CarouselWidget3D(
      radius: MediaQuery.sizeOf(context).width,
      children: List.generate(
        6,
        (index) => Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          color: Colors.blue,
        ),
      ),
    );
  }
```


With full customization:
```dart

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

```


## Screen Recording

<img src="assets/gifs/recording_1.gif" width="350" alt="Screen recording of the animation"> 


## Ideas for features to add:
Ideas and feature requests are welcome. Here are some ideas for future updates:
- Add support for anticlockwise rotation
- Add Axis option to make it a vertical carousel
- Add a way to stop and start the animation from outside the widget
- Add multiple ways for the widgets to spin while rotating. For example, an option would be that when the carousel revolves once, each widget will spin twice. Or the spin direction will change when they pass the center of focus.
- 2d carousel where the items move on a straight line (slideshow)
- Add option to add only some of the children to the carousel. For example, 100 children, show 12.


## Contributing
Contributions from anyone are welcome. To contribute to the project, please follow these steps:
- Fork the repository.
- Create a new branch for your feature or bugfix.
- Make your changes and commit them.
- Push your changes to your forked repository.
- Open a pull request against the main branch of this repository.

Please ensure that your code follows the project's coding standards and includes appropriate tests.
