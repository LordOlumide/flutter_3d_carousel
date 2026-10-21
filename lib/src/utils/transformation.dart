import 'dart:math' as math;

import 'package:flutter_3d_carousel/flutter_3d_carousel.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

/// The naming here is [column number][row number].
///
sealed class Transformation {
  /// The entire matrix as a Matrix3 object
  vector_math.Matrix3 getTransformationMatrix({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  });

  /// Column 0, Row 0
  double get00({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  });

  /// Column 0, Row 1
  double get01({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  });

  /// Column 0, Row 2
  double get02({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  });

  /// Column 1, Row 0
  double get10({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  });

  /// Column 1, Row 1
  double get11({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  });

  /// Column 1, Row 2
  double get12({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  });

  /// Column 2, Row 0
  double get20({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  });

  /// Column 2, Row 1
  double get21({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  });

  /// Column 2, Row 2
  double get22({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  });
}

/// This is the transformation that corresponds to [ChildOrientation.backingCenter].
class Transformation1 extends Transformation {
  @override
  vector_math.Matrix3 getTransformationMatrix({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return vector_math.Matrix3(
      get00(rollAngle: rollAngle, pitchAngle: pitchAngle, yawAngle: yawAngle),
      get01(rollAngle: rollAngle, pitchAngle: pitchAngle, yawAngle: yawAngle),
      get02(rollAngle: rollAngle, pitchAngle: pitchAngle, yawAngle: yawAngle),
      get10(rollAngle: rollAngle, pitchAngle: pitchAngle, yawAngle: yawAngle),
      get11(rollAngle: rollAngle, pitchAngle: pitchAngle, yawAngle: yawAngle),
      get12(rollAngle: rollAngle, pitchAngle: pitchAngle, yawAngle: yawAngle),
      get20(rollAngle: rollAngle, pitchAngle: pitchAngle, yawAngle: yawAngle),
      get21(rollAngle: rollAngle, pitchAngle: pitchAngle, yawAngle: yawAngle),
      get22(rollAngle: rollAngle, pitchAngle: pitchAngle, yawAngle: yawAngle),
    );
  }

  @override
  double get00({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return (math.cos(yawAngle) * math.cos(rollAngle)) -
        (math.sin(yawAngle) * math.cos(pitchAngle) * math.sin(rollAngle));
  }

  @override
  double get01({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return math.sin(pitchAngle) * math.sin(rollAngle);
  }

  @override
  double get02({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return (math.sin(yawAngle) * math.cos(rollAngle)) +
        (math.cos(yawAngle) * math.cos(pitchAngle) * math.sin(rollAngle));
  }

  @override
  double get10({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return math.sin(yawAngle) * math.sin(pitchAngle);
  }

  @override
  double get11({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return math.cos(pitchAngle);
  }

  @override
  double get12({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return -(math.cos(yawAngle) * math.sin(pitchAngle));
  }

  @override
  double get20({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return -(math.cos(yawAngle) * math.sin(rollAngle)) -
        (math.sin(yawAngle) * math.cos(pitchAngle) * math.cos(rollAngle));
  }

  @override
  double get21({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return math.sin(pitchAngle) * math.cos(rollAngle);
  }

  @override
  double get22({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return -(math.sin(yawAngle) * math.sin(rollAngle)) +
        (math.cos(yawAngle) * math.cos(pitchAngle) * math.cos(rollAngle));
  }
}

/// This is the transformation that corresponds to [ChildOrientation.facingYAxis].
class Transformation2 extends Transformation {
  final double a = math.pi / 2;

  @override
  vector_math.Matrix3 getTransformationMatrix({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return vector_math.Matrix3(
      get00(rollAngle: rollAngle, pitchAngle: pitchAngle, yawAngle: yawAngle),
      get01(rollAngle: rollAngle, pitchAngle: pitchAngle, yawAngle: yawAngle),
      get02(rollAngle: rollAngle, pitchAngle: pitchAngle, yawAngle: yawAngle),
      get10(rollAngle: rollAngle, pitchAngle: pitchAngle, yawAngle: yawAngle),
      get11(rollAngle: rollAngle, pitchAngle: pitchAngle, yawAngle: yawAngle),
      get12(rollAngle: rollAngle, pitchAngle: pitchAngle, yawAngle: yawAngle),
      get20(rollAngle: rollAngle, pitchAngle: pitchAngle, yawAngle: yawAngle),
      get21(rollAngle: rollAngle, pitchAngle: pitchAngle, yawAngle: yawAngle),
      get22(rollAngle: rollAngle, pitchAngle: pitchAngle, yawAngle: yawAngle),
    );
  }

  @override
  double get00({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return (math.cos(yawAngle) * math.cos(rollAngle)) -
        (math.sin(yawAngle) * math.cos(pitchAngle) * math.sin(rollAngle));
  }

  @override
  double get01({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return math.sin(pitchAngle) * math.sin(rollAngle);
  }

  @override
  double get02({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return (math.sin(yawAngle) * math.cos(rollAngle)) +
        (math.cos(yawAngle) * math.cos(pitchAngle) * math.sin(rollAngle));
  }

  @override
  double get10({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return (math.sin(yawAngle) * math.sin(pitchAngle) * math.cos(a)) -
        (math.cos(yawAngle) * math.sin(rollAngle) * math.sin(a)) -
        (math.sin(yawAngle) *
            math.cos(pitchAngle) *
            math.cos(rollAngle) *
            math.sin(a));
  }

  @override
  double get11({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return (math.cos(pitchAngle) * math.cos(a)) +
        (math.sin(pitchAngle) * math.cos(rollAngle) * math.sin(a));
  }

  @override
  double get12({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return -(math.cos(yawAngle) * math.sin(pitchAngle) * math.cos(a)) -
        (math.sin(yawAngle) * math.sin(rollAngle) * math.sin(a)) +
        (math.cos(yawAngle) *
            math.cos(pitchAngle) *
            math.cos(rollAngle) *
            math.sin(a));
  }

  @override
  double get20({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return -(math.sin(yawAngle) * math.sin(pitchAngle) * math.sin(a)) -
        (math.cos(yawAngle) * math.sin(rollAngle) * math.cos(a)) -
        (math.sin(yawAngle) *
            math.cos(pitchAngle) *
            math.cos(rollAngle) *
            math.cos(a));
  }

  @override
  double get21({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return -(math.cos(pitchAngle) * math.sin(a)) +
        (math.sin(pitchAngle) * math.cos(rollAngle) * math.cos(a));
  }

  @override
  double get22({
    required double rollAngle,
    required double pitchAngle,
    required double yawAngle,
  }) {
    return (math.cos(yawAngle) * math.sin(pitchAngle) * math.sin(a)) -
        (math.sin(yawAngle) * math.sin(rollAngle) * math.cos(a)) +
        (math.cos(yawAngle) *
            math.cos(pitchAngle) *
            math.cos(rollAngle) *
            math.cos(a));
  }
}
