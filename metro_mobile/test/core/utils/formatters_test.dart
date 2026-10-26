import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/core/utils/vn_text.dart';

void main() {
  setUpAll(() => initializeDateFormatting('vi_VN'));

  test('money() định dạng giống web', () {
    expect(money(12000), '12.000 ₫');
    expect(money(11160), '11.160 ₫');
    expect(money(0), '0 ₫');
    expect(count(12345), '12.345');
  });

  test('dateTime() đổi sang giờ Việt Nam (UTC+7)', () {
    final t = DateTime.utc(2026, 11, 23, 16, 59);
    expect(dateTime(t), '23/11/2026 23:59');
    expect(timeOnly(DateTime.utc(2026, 1, 1, 17)), '00:00');
  });

  test('tìm kiếm không dấu', () {
    expect(normalizeVn('  Bến  Thành '), 'ben thanh');
    expect(normalizeVn('Thủ Đức'), 'thu duc');
    expect(vnContains('Ga Suối Tiên', 'suoi tien'), isTrue);
    expect(vnContains('Ga Ba Son', 'tham luong'), isFalse);
  });
}
