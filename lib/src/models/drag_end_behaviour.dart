/// This determines what happens after a drag interaction is completed,
enum DragEndBehavior {
  /// The carousel will snap to the nearest child position.
  snapToNearest,

  /// The carousel will maintain its exact current position without any adjustment.
  remainFrozen,

  /// The carousel will continue with the default behaviour.
  returnToDefault,
}
