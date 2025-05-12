# 3d_carousel

This is a 3d carousel animation project built in flutter. The 3D carousel responds to button clicks and swipes and can rotate infinitely.

It is implemented natively in flutter. No external dependencies are used.


## Screen Recording

<img src="assets/gifs/recording_1.gif" width="350" alt="Screen recording of the animation"> 


## Features to add:
- Support for anticlockwise rotation


## Bugs to fix:
- The widgets in the carousel shift from foreground to background at 90 and 270 degrees. However, due to the perspective added by `Matrix4.identity().setEntry(3, 2, 0.001)`, the widgets in the carousel "appear" to shift from foreground to background at about 83 degrees and about 276 degrees


## Contributing
Contributions from anyone are welcome. To contribute to the project, please follow these steps:
- Fork the repository.
- Create a new branch for your feature or bugfix.
- Make your changes and commit them.
- Push your changes to your forked repository.
- Open a pull request against the main branch of this repository.

Please ensure that your code follows the project's coding standards and includes appropriate tests.
