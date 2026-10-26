import 'package:dio/dio.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/features/parking/domain/entities/parking_lot.dart';
import 'package:metro_mobile/features/parking/domain/repositories/parking_repository.dart';

typedef _Json = Map<String, Object?>;

/// Endpoint mục 9 (`/api/parking/...`). `GET /api/parking/lots` chưa có
/// trong bảng API, cần thống nhất với backend.
class ParkingRemoteSource implements ParkingRepository {
  const ParkingRemoteSource(this._dio);
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

  _Json _body(ParkingRequest r) => {
    'lotId': r.lotId,
    'vehicleType': r.vehicle,
    'plate': r.plate,
    'package': r.package.code,
  };

  @override
  Future<List<ParkingLot>> getLots() async => [
    for (final j in await _call<List<dynamic>>('GET', '/api/parking/lots'))
      ParkingLot(
        id: '${(j as _Json)['id']}',
        name: j['name']! as String,
        stationName: j['stationName']! as String,
        capacities: [
          for (final c in j['capacities']! as List)
            LotCapacity(
              vehicle: (c as _Json)['vehicleType']! as String,
              free: (c['free']! as num).toInt(),
              total: (c['total']! as num).toInt(),
            ),
        ],
      ),
  ];

  @override
  Future<ParkingPreview> preview(ParkingRequest r) async {
    final j = await _call<_Json>(
      'POST',
      '/api/parking/bookings/preview',
      _body(r),
    );
    return ParkingPreview(
      fee: (j['fee']! as num).toInt(),
      validHours: (j['validHours'] as num?)?.toInt() ?? 0,
      activePassId: j['activeBookingId'] as String?,
    );
  }

  @override
  Future<String> createPayment(ParkingRequest r) async {
    final j = await _call<_Json>('POST', '/api/parking/payments', _body(r));
    return '${j['orderId']}';
  }
}
