import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/features/loyalty/domain/entities/loyalty.dart';
import 'package:metro_mobile/features/loyalty/domain/repositories/loyalty_repository.dart';
import 'package:metro_mobile/features/loyalty/domain/usecases/loyalty_usecases.dart';

/// Thành viên demo: 820 điểm (hạng Bạc). Lịch sử điểm lấy từ giao dịch
/// thành công trong `DemoLedger` (1 điểm / 1.000 ₫).
class LoyaltyFakeSource implements LoyaltyRepository {
  LoyaltyFakeSource(
    this._ledger, {
    this.latency = const Duration(milliseconds: 300),
  });

  final DemoLedger _ledger;
  final Duration latency;

  static const points = 820;
  static const benefits = {
    'Đồng': ['Tích 1 điểm cho mỗi 1.000 ₫'],
    'Bạc': ['Giảm 5% mọi loại vé', 'Tích 1 điểm cho mỗi 1.000 ₫'],
    'Vàng': ['Giảm 8% mọi loại vé', 'Ưu tiên hỗ trợ tại quầy'],
    'Bạch kim': ['Giảm 12% mọi loại vé', 'Gửi xe miễn phí 4 lượt/tháng'],
  };

  Future<void> _wait() => Future<void>.delayed(latency);

  @override
  Future<MemberSummary> getSummary() async {
    await _wait();
    final t = tierOf(points);
    return MemberSummary(
      tierName: t.tier,
      points: points,
      benefits: benefits[t.tier]!,
      nextTierName: t.next,
      pointsToNext: t.toNext,
      progress: t.progress,
    );
  }

  @override
  Future<List<Promotion>> getPromotions() async {
    await _wait();
    final now = _ledger.clock();
    return [
      Promotion(
        id: 'KM-SV11',
        title: 'SV Tháng 11',
        discountLabel: '-20%',
        validUntil: now.add(const Duration(days: 7)),
        description: 'Giảm 20% vé lượt cho học sinh, sinh viên.',
      ),
      Promotion(
        id: 'KM-GX',
        title: 'Gửi xe cuối tuần',
        discountLabel: '-2.000 ₫',
        validUntil: now.add(const Duration(days: 21)),
        description: 'Áp dụng gói lượt xe máy vào thứ 7, chủ nhật.',
      ),
    ];
  }

  @override
  Future<List<PointsEntry>> getPointsHistory() async {
    await _wait();
    final earned = [
      for (final t in _ledger.transactions.take(10))
        if (t['status'] == 'SUCCESS')
          PointsEntry(
            delta: (t['amount']! as int) ~/ 1000,
            title: t['title']! as String,
            createdAt: DateTime.parse(t['createdAt']! as String),
          ),
    ];
    return [
      ...earned.take(4),
      PointsEntry(
        delta: -100,
        title: 'Đổi điểm giảm giá vé',
        createdAt: _ledger.clock().subtract(const Duration(days: 6)),
      ),
      ...earned.skip(4),
    ];
  }
}
