import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/design_system/atoms/password_strength.dart';
import 'package:metro_mobile/design_system/atoms/status_badge.dart';
import 'package:metro_mobile/design_system/atoms/status_badge_map.dart';
import 'package:metro_mobile/l10n/l10n.dart';

import '../../helpers/pump_themed.dart';

void main() {
  test('nhãn trạng thái khớp bảng mục 3.5', () {
    final l = lookupAppLocalizations(const Locale('vi'));
    expect(resolveStatus(l, 'PAID'), ('Chưa sử dụng', StatusTone.primary));
    expect(resolveStatus(l, 'IN_USE'), ('Đang sử dụng', StatusTone.accent));
    expect(resolveStatus(l, 'CANCELLED').$2, StatusTone.destructive);
    expect(resolveStatus(l, 'DANG_GUI').$1, 'Đang gửi');
    expect(resolveStatus(l, 'UNKNOWN'), ('UNKNOWN', StatusTone.muted));
  });

  testWidgets('StatusBadge hiển thị nhãn tiếng Việt', (tester) async {
    await pumpThemed(tester, const StatusBadge(status: 'EXPIRED'));
    expect(find.text('Hết hạn'), findsOneWidget);
  });

  test('độ mạnh mật khẩu', () {
    expect(PasswordStrength.of(''), PasswordStrength.empty);
    expect(PasswordStrength.of('abc'), PasswordStrength.weak);
    expect(PasswordStrength.of('metro2026'), PasswordStrength.fair);
    expect(PasswordStrength.of('Metro2026'), PasswordStrength.good);
    expect(PasswordStrength.of('Metro@2026'), PasswordStrength.strong);
  });
}
