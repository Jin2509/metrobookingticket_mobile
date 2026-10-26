import 'package:clock/clock.dart' as clk;

/// Không gửi lại cùng một mã trong [window] (mục 10.2: mỗi lượt soát vé
/// ghi nhận duy nhất; camera đọc được một QR nhiều lần mỗi giây).
class DedupeScan {
  DedupeScan({
    this.window = const Duration(seconds: 3),
    DateTime Function()? clock,
  }) : _clock = clock ?? (() => clk.clock.now());

  final Duration window;
  final DateTime Function() _clock;
  final _seen = <String, DateTime>{};

  /// `true` nếu nên xử lý [key] (lần đầu hoặc đã quá [window]).
  bool accept(String key) {
    final now = _clock();
    _seen.removeWhere((_, t) => now.difference(t) >= window);
    if (_seen.containsKey(key)) return false;
    _seen[key] = now;
    return true;
  }
}
