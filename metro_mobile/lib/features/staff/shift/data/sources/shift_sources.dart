import 'package:dio/dio.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/features/staff/scan_history/data/sources/staff_scan_log.dart';
import 'package:metro_mobile/features/staff/shift/domain/entities/staff_shift.dart';
import 'package:metro_mobile/features/staff/shift/domain/repositories/shift_repository.dart';

typedef _Json = Map<String, Object?>;

/// Ga phụ trách = `GET /api/v1/me/stations` (lấy ga đầu tiên), bãi xe = bãi
/// đầu tiên của ga đó. Backend chưa có ca làm và thống kê ca: thống kê đếm
/// từ các lượt quét trên máy ([StaffScanLog]).
class ShiftRemoteSource implements ShiftRepository {
  const ShiftRemoteSource(this._dio, this._log);
  final Dio _dio;
  final StaffScanLog _log;

  Future<List<_Json>> _list(String path, [Map<String, Object?>? query]) async {
    try {
      final res = await _dio.get<List<dynamic>>(path, queryParameters: query);
      return [for (final j in res.data ?? const []) j as _Json];
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<StaffShift> getShift() async {
    final stations = await _list('/api/v1/me/stations');
    if (stations.isEmpty) {
      throw const ForbiddenFailure('Bạn chưa được phân công ga nào');
    }
    final s = stations.first;
    final stationId = '${s['stationId']}';
    final lots = await _list('/api/v1/public/parking-lots', {
      'stationId': stationId,
    });
    final lot = lots.firstOrNull;
    return StaffShift(
      stationId: stationId,
      stationName: s['stationName'] as String? ?? '',
      shiftLabel: '',
      lotId: lot == null ? '' : '${lot['id']}',
      lotName: lot?['name'] as String? ?? '',
    );
  }

  @override
  Future<ShiftStats> getTodayStats() async {
    final tickets = _log.today().where((e) => !e.parking);
    return ShiftStats(
      entries: tickets.where((e) => e.valid && e.entry).length,
      exits: tickets.where((e) => e.valid && !e.entry).length,
      rejected: tickets.where((e) => !e.valid).length,
    );
  }
}
