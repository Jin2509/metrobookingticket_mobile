import 'package:dio/dio.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/features/loyalty/domain/entities/loyalty.dart';
import 'package:metro_mobile/features/loyalty/domain/repositories/loyalty_repository.dart';

typedef _Json = Map<String, Object?>;

/// `GET /api/v1/me/loyalty` và `/me/loyalty/transactions`. Hạng tính theo
/// điểm tích lũy trọn đời (`lifetimePoints`), điểm dùng được là
/// `pointsBalance`.
class LoyaltyRemoteSource implements LoyaltyRepository {
  const LoyaltyRemoteSource(this._dio);
  final Dio _dio;

  static const _base = '/api/v1';

  Future<T> _get<T>(String path, [Map<String, Object?>? query]) async {
    try {
      final res = await _dio.get<T>('$_base$path', queryParameters: query);
      return res.data as T;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  static int _int(Object? v) => (v as num?)?.toInt() ?? 0;

  @override
  Future<MemberSummary> getSummary() async {
    final j = await _get<_Json>('/me/loyalty');
    final lifetime = _int(j['lifetimePoints']);
    final tier = j['tier'] as _Json?;
    final next = j['nextTier'] as _Json?;
    final from = _int(tier?['minPoints']);
    final to = _int(next?['minPoints']);
    final perCheckIn = _int(j['pointsPerCheckIn']);
    final maxDiscount = _int(j['maxDiscountVnd']);
    return MemberSummary(
      tierName: tier?['name'] as String? ?? 'Thành viên',
      points: _int(j['pointsBalance']),
      benefits: [
        if (perCheckIn > 0) 'Cộng $perCheckIn CPoint mỗi lượt vào ga',
        if (maxDiscount > 0)
          'Dùng CPoint giảm tới ${money(maxDiscount)} mỗi đơn (1 điểm = 1 ₫)',
      ],
      nextTierName: next?['name'] as String?,
      pointsToNext: next == null ? 0 : (to - lifetime).clamp(0, to),
      progress: next == null || to <= from
          ? 1
          : ((lifetime - from) / (to - from)).clamp(0, 1).toDouble(),
    );
  }

  /// Backend chưa có chương trình ưu đãi.
  @override
  Future<List<Promotion>> getPromotions() async => const [];

  @override
  Future<List<PointsEntry>> getPointsHistory() async {
    final page = await _get<_Json>('/me/loyalty/transactions', {'size': 50});
    return [
      for (final j in page['content']! as List)
        PointsEntry(
          delta: _int((j as _Json)['points']),
          title: j['description'] as String? ?? '',
          createdAt: DateTime.parse(j['createdAt']! as String),
        ),
    ];
  }
}
