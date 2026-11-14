import 'package:dio/dio.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/features/staff/parking_control/domain/entities/parking_control_entities.dart';
import 'package:metro_mobile/features/staff/parking_control/domain/repositories/parking_control_repository.dart';
import 'package:metro_mobile/features/staff/scan_history/data/sources/staff_scan_log.dart';
import 'package:metro_mobile/features/staff/scan_history/domain/entities/scan_log_entry.dart';

typedef _Json = Map<String, Object?>;

/// Quét QR đặt chỗ `POST /api/v1/parking/bookings/scan` (PAID → CHECKED_IN
/// → COMPLETED), xe đang gửi = phiên PARKED của bãi, sức chứa từ
/// `/public/parking-lots/{lotId}`.
class ParkingControlRemoteSource implements ParkingControlRepository {
  const ParkingControlRemoteSource(this._dio, this._log);
  final Dio _dio;
  final StaffScanLog _log;

  static const _base = '/api/v1';

  Future<T> _call<T>(
    String method,
    String path, {
    _Json? body,
    Map<String, Object?>? query,
  }) async {
    try {
      final res = await _dio.request<T>(
        '$_base$path',
        data: body,
        queryParameters: query,
        options: Options(method: method),
      );
      return res.data as T;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  static String _appStatus(Object? s) => switch (s) {
    'CHECKED_IN' => 'DANG_GUI',
    'COMPLETED' => 'LAY_XE',
    _ => 'CHUA_GUI',
  };

  @override
  Future<ParkingCheck> checkQr(String qrToken, String lotId) async {
    final j = await _call<_Json>(
      'POST',
      '/parking/bookings/scan',
      body: {'qrToken': qrToken},
    );
    final to = _appStatus(j['status']);
    final check = ParkingCheck(
      plate: j['plateNumber'] as String? ?? '${j['bookingCode']}',
      vehicle: j['vehicleType']! as String,
      fromStatus: to == 'DANG_GUI' ? 'CHUA_GUI' : 'DANG_GUI',
      toStatus: to,
      at: DateTime.now(),
    );
    _log.add(
      ScanLogEntry(
        at: check.at,
        parking: true,
        entry: check.isEntry,
        code: check.plate,
        valid: true,
        label: j['lotName'] as String? ?? '',
      ),
    );
    return check;
  }

  @override
  Future<List<ParkedVehicle>> getParked(String lotId) async {
    final page = await _call<_Json>(
      'GET',
      '/parking-lots/$lotId/sessions',
      query: {'status': 'PARKED', 'size': 100},
    );
    return [
      for (final j in page['content']! as List)
        ParkedVehicle(
          plate:
              (j as _Json)['plateNumber'] as String? ?? '${j['sessionCode']}',
          vehicle: j['vehicleType']! as String,
          since: j['checkInAt'] == null
              ? null
              : DateTime.parse(j['checkInAt']! as String),
        ),
    ];
  }

  @override
  Future<LotStatus> getLotStatus(String lotId) async {
    final j = await _call<_Json>('GET', '/public/parking-lots/$lotId');
    return LotStatus(
      lotName: j['name']! as String,
      usage: [
        for (final v in j['vehicles'] as List? ?? const [])
          (
            (v as _Json)['vehicleType']! as String,
            (v['occupied'] as num?)?.toInt() ?? 0,
            (v['capacity'] as num?)?.toInt() ?? 0,
          ),
      ],
    );
  }
}
