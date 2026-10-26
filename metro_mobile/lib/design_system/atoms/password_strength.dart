import 'package:metro_mobile/l10n/l10n.dart';

/// Độ mạnh mật khẩu, giống thanh đo của `PasswordField.tsx` trên web.
enum PasswordStrength {
  empty(0),
  weak(1),
  fair(2),
  good(3),
  strong(4);

  PasswordStrength(this.level);
  final int level;

  String label(AppLocalizations l) => switch (this) {
    empty => '',
    weak => l.strengthWeak,
    fair => l.strengthFair,
    good => l.strengthGood,
    strong => l.strengthStrong,
  };

  static PasswordStrength of(String value) {
    if (value.isEmpty) return empty;
    var score = 0;
    if (value.length >= 8) score++;
    if (RegExp('[A-Z]').hasMatch(value) && RegExp('[a-z]').hasMatch(value)) {
      score++;
    }
    if (RegExp(r'\d').hasMatch(value)) score++;
    if (RegExp('[^A-Za-z0-9]').hasMatch(value)) score++;
    if (value.length < 6) score = 0;
    return values[score.clamp(1, 4)];
  }
}
