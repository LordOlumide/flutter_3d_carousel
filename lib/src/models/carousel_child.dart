import 'package:flutter/material.dart';

/// This is simply a container class for whatever widget is passed into the carousel.
///
@immutable
class CarouselChild {
  /// The child widget that is passed into the carousel.
  final Widget child;

  /// The function that is called when the [child] is tapped.
  final VoidCallback? onTap;

  /// Constructs a new [CarouselChild] object.
  const CarouselChild({
    required this.child,
    this.onTap,
  });
}
