import 'package:metro_mobile/features/loyalty/domain/entities/loyalty.dart';
import 'package:metro_mobile/features/loyalty/domain/repositories/loyalty_repository.dart';

/// Ngưỡng hạng: tên → điểm tối thiểu (giống trang Thành viên trên web).
const loyaltyTiers = [
  ('Đồng', 0),
  ('Bạc', 500),
  ('Vàng', 2000),
  ('Bạch kim', 5000),
];

/// Tính hạng, hạng kế tiếp, điểm còn thiếu và tiến độ từ số điểm.
({String tier, String? next, int toNext, double progress}) tierOf(int points) {
  var i = 0;
  while (i + 1 < loyaltyTiers.length && points >= loyaltyTiers[i + 1].$2) {
    i++;
  }
  final (name, min) = loyaltyTiers[i];
  if (i + 1 == loyaltyTiers.length) {
    return (tier: name, next: null, toNext: 0, progress: 1);
  }
  final (nextName, nextMin) = loyaltyTiers[i + 1];
  return (
    tier: name,
    next: nextName,
    toNext: nextMin - points,
    progress: (points - min) / (nextMin - min),
  );
}

class GetMemberSummary {
  const GetMemberSummary(this._repo);
  final LoyaltyRepository _repo;

  Future<MemberSummary> call() => _repo.getSummary();
}

class GetPromotions {
  const GetPromotions(this._repo);
  final LoyaltyRepository _repo;

  /// Chỉ ưu đãi còn hạn, sắp hết hạn lên trước.
  Future<List<Promotion>> call({DateTime? now}) async {
    final t = now ?? DateTime.now();
    final list = await _repo.getPromotions();
    return list.where((p) => p.validUntil.isAfter(t)).toList()
      ..sort((a, b) => a.validUntil.compareTo(b.validUntil));
  }
}

class GetPointsHistory {
  const GetPointsHistory(this._repo);
  final LoyaltyRepository _repo;

  Future<List<PointsEntry>> call() => _repo.getPointsHistory();
}
