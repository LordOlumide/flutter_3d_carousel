/// This determines what happens after a drag interaction is completed,
enum DragEndBehavior {
  /// The carousel will snap to the nearest child position.
  snapToNearest,

  /// The carousel will maintain its exact current position without any adjustment.
  doNothing,

  /// The carousel will continue rotating with the default speed decided by the [CarouselWidget3D.timeForFullRevolution].
  /// This only takes effect if [CarouselWidget3D.shouldRotate] is true. Else it will behave like [snapToNearest].
  continueRotating,
}
