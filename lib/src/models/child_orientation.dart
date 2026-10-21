//TODO: Document and implement
import 'package:equatable/equatable.dart';

/// This determines what direction the objects in the carousel face.
sealed class ChildOrientation extends Equatable {
  double? get tiltAngle;

  const ChildOrientation();
}

/// The children should always be backing the center point of the carousel.
class OrientedBackingCenter extends ChildOrientation {
  @override
  final double? tiltAngle = null;

  const OrientedBackingCenter();

  @override
  List<Object?> get props => [tiltAngle];
}

/// The children should always be facing the screen of the user,
/// regardless of the roll, pitch, and yaw.
class OrientedFacingScreen extends ChildOrientation {
  @override
  final double? tiltAngle = null;

  const OrientedFacingScreen();

  @override
  List<Object?> get props => [tiltAngle];
}

/// The children are tilted around the X axis with [tiltAngle].
class OrientedWithXTilt extends ChildOrientation {
  @override
  final double tiltAngle;

  const OrientedWithXTilt(this.tiltAngle);

  @override
  List<Object?> get props => [tiltAngle];
}

/// The children are tilted around the Y axis with [tiltAngle].
class OrientedWithYTilt extends ChildOrientation {
  @override
  final double tiltAngle;

  const OrientedWithYTilt(this.tiltAngle);

  @override
  List<Object?> get props => [tiltAngle];
}

/// The children are tilted around the Z axis with [tiltAngle].
class OrientedWithZTilt extends ChildOrientation {
  @override
  final double tiltAngle;

  const OrientedWithZTilt(this.tiltAngle);

  @override
  List<Object?> get props => [tiltAngle];
}
