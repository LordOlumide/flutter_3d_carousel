import 'package:equatable/equatable.dart';
import 'package:flutter_3d_carousel/flutter_3d_carousel.dart';

/// The InputFunction defines an function that describes the angle.
///
sealed class InputFunction extends Equatable {
  const InputFunction();

  /// The value the function was initialized with.
  double get initialValue;

  /// This returns the current value of angle using time passed since the
  /// animation started running.
  /// It should return a value between 0 and (math.pi * 2), no negative values.
  double getCurrentValue({
    required Duration elapsedTime,
    double? newInitialValue,
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
  double get initialValue => value;

  @override
  double getCurrentValue({
    required Duration elapsedTime,
    double? newInitialValue,
  }) {
    return UtilFunctions.normalizeDegreeInRadians(newInitialValue ?? value);
  }

  @override
  List<Object?> get props => [value];
}

/// This is a linear function.
/// It is described by the equation: [y = mx + C], where x is the [elapsedTime].
class LinearInputFunction extends InputFunction {
  /// This is the constant value.
  /// It should range from 0 to 2*[math.pi].
  /// The default value is 0.
  @override
  final double initialValue;

  /// This is the gradient (the speed at which the angle changing) in radians per second.
  /// The default value is 0.
  final double gradient;

  const LinearInputFunction({
    this.initialValue = 0,
    this.gradient = 0,
  });

  @override
  double getCurrentValue({
    required Duration elapsedTime,
    double? newInitialValue,
  }) {
    return UtilFunctions.normalizeDegreeInRadians(
      (gradient * (elapsedTime.inMilliseconds / 1000)) +
          (newInitialValue ?? initialValue),
    );
  }

  @override
  List<Object?> get props => [initialValue, gradient];
}

/// This function describes regular intermittent motion.
///
/// The angle changes according to the provided input function during each
/// movement interval, then remains constant during each pause interval.
class IntermittentInputFunction extends InputFunction {
  /// The initial angle in radians, normalized to [0, 2π].
  @override
  final double initialValue;

  /// Defaults to [LinearInputFunction].
  final InputFunction motionFunction;

  /// Duration of each movement interval.
  final Duration movementDuration;

  /// Duration of each pause interval.
  final Duration pauseDuration;

  /// Duration before the first movement starts.
  final Duration timeOffset;

  const IntermittentInputFunction({
    this.initialValue = 0,
    this.motionFunction = const LinearInputFunction(gradient: 0),
    this.movementDuration = const Duration(seconds: 2),
    this.pauseDuration = const Duration(seconds: 1),
    this.timeOffset = Duration.zero,
  });

  @override
  double getCurrentValue({
    required Duration elapsedTime,
    double? newInitialValue,
  }) {
    final moveMs = movementDuration.inMilliseconds;
    final pauseMs = pauseDuration.inMilliseconds;
    final cycleMs = moveMs + pauseMs;

    final baseValue = newInitialValue ?? initialValue;

    // Remain at the initial value until the first movement starts.
    if (elapsedTime < timeOffset) {
      return UtilFunctions.normalizeDegreeInRadians(baseValue);
    }

    if (moveMs <= 0 || pauseMs < 0 || cycleMs <= 0) {
      return UtilFunctions.normalizeDegreeInRadians(baseValue);
    }

    final activeElapsedMs = (elapsedTime - timeOffset).inMilliseconds;
    final timeInCycle = activeElapsedMs % cycleMs;
    final int noOfCycles = activeElapsedMs ~/ cycleMs;

    // During the pause, retain the angle reached at the end of the movement interval.
    final activeMsInCycle = timeInCycle.clamp(0, moveMs);

    final angle = baseValue +
        motionFunction.getCurrentValue(
          elapsedTime:
              Duration(milliseconds: (noOfCycles * moveMs) + activeMsInCycle),
        );

    return UtilFunctions.normalizeDegreeInRadians(angle);
  }

  @override
  List<Object?> get props => [
        initialValue,
        motionFunction,
        movementDuration,
        pauseDuration,
        timeOffset,
      ];
}
