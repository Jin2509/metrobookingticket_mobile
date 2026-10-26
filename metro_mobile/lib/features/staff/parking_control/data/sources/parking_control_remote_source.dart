import 'package:dio/dio.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/features/staff/parking_control/domain/entities/parking_control_entities.dart';
import 'package:metro_mobile/features/staff/parking_control/domain/repositories/parking_control_repository.dart';

typedef _Json = Map<String, Object?>;

/// `POST /api/parking/check-qr` theo mục 9; danh sách xe và sức chứa
/// là endpoint giả định.
class ParkingControlRemoteSource implements ParkingControlRepository {
  const ParkingControlRemoteSource(this._dio);
  final Dio _dio;

  Future<T> _call<T>(String method, String path, [_Json? body]) async {
    try {
      final res = await _dio.request<T>(
        path,
        data: body,
        options: Options(method: method),
      );
      return res.data as T;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<ParkingCheck> checkQr(String qrToken, String lotId) async {
    final j = await _call<_Json>('POST', '/api/parking/check-qr', {
      'qrToken': qrToken,
      'lotId': lotId,
    });
    return ParkingCheck(
      plate: j['plate']! as String,
      vehicle: j['vehicleType']! as String,
      fromStatus: j['fromStatus']! as String,
      toStatus: j['toStatus']! as String,
      at: DateTime.now(),
    );
  }

  @override
  Future<List<ParkedVehicle>> getParked(String lotId) async => [
    for (final j in await _call<List<dynamic>>(
      'GET',
      '/api/staff/parking/$lotId/parked',
    ))
      ParkedVehicle(
        plate: (j as _Json)['plate']! as String,
        vehicle: j['vehicleType']! as String,
        since: j['since'] == null
            ? null
            : DateTime.parse(j['since']! as String),
      ),
  ];

  @override
  Future<LotStatus> getLotStatus(String lotId) async {
    final j = await _call<_Json>('GET', '/api/staff/parking/$lotId/status');
    return LotStatus(
      lotName: j['lotName']! as String,
      usage: [
        for (final u in j['usage']! as List)
          (
            (u as _Json)['vehicleType']! as String,
            (u['used']! as num).toInt(),
            (u['total']! as num).toInt(),
          ),
      ],
    );
  }
}
