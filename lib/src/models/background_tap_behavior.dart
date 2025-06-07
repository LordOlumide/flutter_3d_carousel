/// Defines how the carousel responds when the background is tapped.
enum BackgroundTapBehavior {
  /// If the carousel was not rotating, it starts rotating.
  /// If the carousel was rotating, it stops rotating and snaps to the nearest node.
  startAndSnapToNearest,

  /// If the carousel was not rotating, it starts rotating.
  /// If the carousel was rotating, it stops rotating and freezes in its current position.
  startAndFreeze,

  /// Disables tap-to-rotate functionality.
  none,
}
