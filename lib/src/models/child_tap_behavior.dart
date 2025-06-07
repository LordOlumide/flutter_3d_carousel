/// Defines how the carousel responds when one of its children is tapped.
enum ChildTapBehavior {
  /// The carousel stops rotating if it was rotating, and snaps to the nearest node.
  stopAndSnapToChild,

  /// The carousel does not respond. It continues with its previous state.
  doNothing,
}