import 'package:flutter/material.dart';

@immutable
class CarouselChild {
  final Widget child;
  final VoidCallback? onTap;

  const CarouselChild({
    required this.child,
    this.onTap,
  });
}
