/// Thời gian chờ kết nối lại tăng dần 1-2-4-8s (Prompt 6).
class Backoff {
  Backoff({
    this.base = const Duration(seconds: 1),
    this.max = const Duration(seconds: 8),
  });

  final Duration base;
  final Duration max;
  int _attempt = 0;

  Duration next() {
    final ms = base.inMilliseconds * (1 << _attempt);
    if (ms < max.inMilliseconds) _attempt++;
    return Duration(milliseconds: ms.clamp(0, max.inMilliseconds));
  }

  void reset() => _attempt = 0;
}
