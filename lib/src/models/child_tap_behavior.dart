/// Defines how the carousel animate when one of its children is tapped.
enum ChildTapBehavior {
  /// The carousel stops rotating if it was rotating, and snaps to the nearest node.
  stopAndSnapToChild,

  /// Tapping the carousel's children will have the same effect as tapping the background.
  /// The. exact behavior will depend on the [BackgroundTapBehavior] assigned.
  transparent,

  /// The carousel does not respond. It continues with its previous state.
  doNothing,
}
