import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/core/network/backoff.dart';
import 'package:metro_mobile/core/utils/geo.dart';

void main() {
  test('backoff kết nối lại 1-2-4-8s, reset khi kết nối được', () {
    final b = Backoff();
    final seq = [for (var i = 0; i < 6; i++) b.next().inSeconds];
    expect(seq, [1, 2, 4, 8, 8, 8]);
    b.reset();
    expect(b.next().inSeconds, 1);
  });

  test('khoảng cách và định dạng', () {
    // Bến Thành → Nhà hát Thành phố ~ 720 m.
    final d = distanceMeters(10.7724, 106.6980, 10.7765, 106.7031);
    expect(d, inInclusiveRange(650, 800));
    expect(formatDistance(350.4), '350 m');
    expect(formatDistance(1234), '1,2 km');
  });
}
