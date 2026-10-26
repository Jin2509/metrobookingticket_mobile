import 'package:dio/dio.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/features/loyalty/domain/entities/loyalty.dart';
import 'package:metro_mobile/features/loyalty/domain/repositories/loyalty_repository.dart';

typedef _Json = Map<String, Object?>;

/// Endpoint thành viên/ưu đãi chưa có trong bảng API mục 9, cần thống
/// nhất với backend.
class LoyaltyRemoteSource implements LoyaltyRepository {
  const LoyaltyRemoteSource(this._dio);
  final Dio _dio;

  Future<T> _get<T>(String path) async {
    try {
      return (await _dio.get<T>(path)).data as T;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<MemberSummary> getSummary() async {
    final j = await _get<_Json>('/api/loyalty/me');
    return MemberSummary(
      tierName: j['tierName']! as String,
      points: (j['points']! as num).toInt(),
      benefits: [for (final b in j['benefits'] as List? ?? []) '$b'],
      nextTierName: j['nextTierName'] as String?,
      pointsToNext: (j['pointsToNext'] as num?)?.toInt() ?? 0,
      progress: (j['progress'] as num?)?.toDouble() ?? 1,
    );
  }

  @override
  Future<List<Promotion>> getPromotions() async => [
    for (final j in await _get<List<dynamic>>('/api/promotions/active'))
      Promotion(
        id: '${(j as _Json)['id']}',
        title: j['title']! as String,
        discountLabel: j['discountLabel']! as String,
        validUntil: DateTime.parse(j['validUntil']! as String),
        description: j['description'] as String?,
      ),
  ];

  @override
  Future<List<PointsEntry>> getPointsHistory() async => [
    for (final j in await _get<List<dynamic>>('/api/loyalty/transactions'))
      PointsEntry(
        delta: ((j as _Json)['delta']! as num).toInt(),
        title: j['title']! as String,
        createdAt: DateTime.parse(j['createdAt']! as String),
      ),
  ];
}
