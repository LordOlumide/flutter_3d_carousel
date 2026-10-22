/// Defines how the carousel responds to drag gestures.
enum DragBehaviour {
  /// Disables drag interactions with the carousel.
  none,

  /// Allows dragging to rotate the carousel along only the roll axis.
  oneDimensional,

  /// Allows dragging to rotate the carousel along two axes simultaneously.
  /// It rotates the roll and pitch when the carousel is closer to horizontal
  /// and the roll and yaw when it is closer to vertical.
  twoDimensional,
}