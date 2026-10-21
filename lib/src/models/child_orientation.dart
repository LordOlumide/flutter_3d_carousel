//TODO: Document and implement
/// This determines what direction the objects in the carousel face.
enum ChildOrientation {
  /// The children should always be backing the center point of the carousel.
  backingCenter,

  /// The children should always be facing the screen of the user.
  facingScreen,

  /// The children should be facing the top of the y axis.
  facingYAxis,
}
