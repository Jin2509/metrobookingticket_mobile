import 'package:dio/dio.dart';
import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/features/staff/shift/domain/entities/staff_shift.dart';
import 'package:metro_mobile/features/staff/shift/domain/repositories/shift_repository.dart';
import 'package:metro_mobile/features/staff/staff_demo.dart';

/// Ca làm demo; thống kê = số liệu nền + các lượt quét trong `DemoLedger`.
class ShiftFakeSource implements ShiftRepository {
  const ShiftFakeSource(this._ledger);
  final DemoLedger _ledger;

  @override
  Future<StaffShift> getShift() async => const StaffShift(
    stationId: StaffDemo.stationId,
    stationName: StaffDemo.stationName,
    shiftLabel: StaffDemo.shiftLabel,
    lotId: StaffDemo.lotId,
    lotName: StaffDemo.lotName,
  );

  @override
  Future<ShiftStats> getTodayStats() async {
    final tickets = _ledger.scanLog.where((e) => e['parking'] != true);
    int n(bool Function(Record) f) => tickets.where(f).length;
    return ShiftStats(
      entries:
          StaffDemo.baseEntries +
          n((e) => e['valid'] == true && e['entry'] == true),
      exits:
          StaffDemo.baseExits +
          n((e) => e['valid'] == true && e['entry'] != true),
      rejected: StaffDemo.baseRejected + n((e) => e['valid'] != true),
    );
  }
}

/// Endpoint ca làm chưa có trong bảng API mục 9, cần thống nhất.
class ShiftRemoteSource implements ShiftRepository {
  const ShiftRemoteSource(this._dio);
  final Dio _dio;

  Future<Map<String, Object?>> _get(String path) async {
    try {
      return (await _dio.get<Map<String, Object?>>(path)).data ?? const {};
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<StaffShift> getShift() async {
    final j = await _get('/api/staff/shift');
    return StaffShift(
      stationId: '${j['stationId']}',
      stationName: j['stationName']! as String,
      shiftLabel: j['shiftLabel'] as String? ?? '',
      lotId: '${j['lotId']}',
      lotName: j['lotName'] as String? ?? '',
    );
  }

  @override
  Future<ShiftStats> getTodayStats() async {
    final j = await _get('/api/staff/stats/today');
    return ShiftStats(
      entries: (j['entries'] as num?)?.toInt() ?? 0,
      exits: (j['exits'] as num?)?.toInt() ?? 0,
      rejected: (j['rejected'] as num?)?.toInt() ?? 0,
    );
  }
}
