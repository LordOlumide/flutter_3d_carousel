import 'dart:async';

class Throttler {
  final Duration delay;
  Timer? _timer;
  bool _isExecuting = false;

  Throttler({required this.delay});

  void run(void Function() action) {
    if (_isExecuting) return;

    _isExecuting = true;
    action();
    _timer = Timer(delay, () => _isExecuting = false);
  }

  void dispose() => _timer?.cancel();
}
