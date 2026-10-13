import 'package:flutter_3d_carousel/flutter_3d_carousel.dart';

/// The InputFunction defines an function that describes the angle.
///
sealed class InputFunction {
  const InputFunction();

  double getCurrentValue({
    /// This is the time passed since the animation started running.
    required Duration elapsedTime,
  });
}

/// This is a constant value function.
/// It is described by the equation: [y = Constant].
class ConstantInputFunction extends InputFunction {
  /// This is the constant value.
  /// It should range from 0 to 2*[math.pi].
  /// The default value is 0.
  final double value;

  const ConstantInputFunction({this.value = 0});

  @override
  double getCurrentValue({required Duration elapsedTime}) {
    return value;
  }
}

/// This is a linear function.
/// It is described by the equation: [y = mx + C], where x is the [elapsedTime].
class LinearInputFunction extends InputFunction {
  /// This is the constant value.
  /// It should range from 0 to 2*[math.pi].
  /// The default value is 0.
  final double initialValue;

  /// This is the gradient (the speed at which the angle changing) in radians per second.
  /// The default value is 0.
  final double gradient;

  const LinearInputFunction({
    this.initialValue = 0,
    this.gradient = 0,
  });

  @override
  double getCurrentValue({required Duration elapsedTime}) {
    return UtilFunctions.normalizeDegreeInRadians(
        (gradient * (elapsedTime.inMilliseconds / 1000)) + initialValue);
  }
}
