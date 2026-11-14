import 'package:dio/dio.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/features/parking/domain/entities/parking_lot.dart';
import 'package:metro_mobile/features/parking/domain/repositories/parking_repository.dart';

typedef _Json = Map<String, Object?>;

/// Gói Lượt/Ngày = đặt chỗ `POST /api/v1/parking/bookings` (Lượt: tới hết
/// ngày, Ngày: 24 giờ); gói Tháng = `POST /parking/monthly-passes`. Cả hai
/// trả `payment.orderCode` để dùng chung màn QR thanh toán.
class ParkingRemoteSource implements ParkingRepository {
  ParkingRemoteSource(this._dio, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;
  final Dio _dio;
  final DateTime Function() _clock;

  static const _base = '/api/v1';

  Future<T> _call<T>(String method, String path, [_Json? body]) async {
    try {
      final res = await _dio.request<T>(
        '$_base$path',
        data: body,
        options: Options(method: method),
      );
      return res.data as T;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  static int _int(Object? v) => (v as num?)?.toInt() ?? 0;

  @override
  Future<List<ParkingLot>> getLots() async => [
    for (final j in await _call<List<dynamic>>('GET', '/public/parking-lots'))
      if ((j as _Json)['status'] == 'ACTIVE')
        ParkingLot(
          id: '${j['id']}',
          name: j['name']! as String,
          stationName: j['stationName'] as String? ?? '',
          capacities: [
            for (final c in j['vehicles'] as List? ?? const [])
              LotCapacity(
                vehicle: (c as _Json)['vehicleType']! as String,
                free: _int(c['available']),
                total: _int(c['capacity']),
              ),
          ],
        ),
  ];

  /// Khung giờ của gói Lượt/Ngày, tính từ bây giờ.
  (DateTime, DateTime) _window(ParkingPackage p) {
    final now = _clock();
    if (p == ParkingPackage.day) return (now, now.add(const Duration(days: 1)));
    final vn = toVnTime(now);
    final endOfDay = DateTime.utc(vn.year, vn.month, vn.day, 23, 59);
    // `toVnTime` cộng +7: đổi lại về UTC thật.
    return (now, endOfDay.subtract(const Duration(hours: 7)));
  }

  /// Backend không có API xem trước: tính phí theo bảng giá của bãi, cùng
  /// công thức `ParkingFeeCalculator` (giá ngày + số đêm × giá qua đêm).
  @override
  Future<ParkingPreview> preview(ParkingRequest r) async {
    final lot = await _call<_Json>('GET', '/public/parking-lots/${r.lotId}');
    final rate = (lot['vehicles'] as List? ?? const [])
        .cast<_Json>()
        .where((v) => v['vehicleType'] == r.vehicle)
        .firstOrNull;
    if (rate == null) {
      throw const ValidationFailure('Bãi không nhận loại xe này');
    }
    if (r.package == ParkingPackage.month) {
      return ParkingPreview(
        fee: _int(rate['monthlyPriceVnd']),
        validHours: 720,
      );
    }
    final (start, end) = _window(r.package);
    final s = toVnTime(start);
    final e = toVnTime(end);
    final nights = DateTime.utc(
      e.year,
      e.month,
      e.day,
    ).difference(DateTime.utc(s.year, s.month, s.day)).inDays;
    return ParkingPreview(
      fee: _int(rate['dayPriceVnd']) + nights * _int(rate['overnightPriceVnd']),
      validHours: end.difference(start).inMinutes ~/ 60,
    );
  }

  @override
  Future<String> createPayment(ParkingRequest r) async {
    final plate = r.plate.trim().isEmpty ? null : r.plate.trim();
    final _Json res;
    if (r.package == ParkingPackage.month) {
      res = await _call<_Json>('POST', '/parking/monthly-passes', {
        'lotId': int.parse(r.lotId),
        'vehicleType': r.vehicle,
        'plateNumber': plate,
        'paymentMethod': 'SEPAY_QR',
      });
    } else {
      final (start, end) = _window(r.package);
      res = await _call<_Json>('POST', '/parking/bookings', {
        'lotId': int.parse(r.lotId),
        'vehicleType': r.vehicle,
        'plateNumber': ?plate,
        'startAt': start.toUtc().toIso8601String(),
        'endAt': end.toUtc().toIso8601String(),
        'paymentMethod': 'SEPAY_QR',
      });
    }
    final payment = res['payment'] as _Json?;
    if (payment == null) {
      // Phí 0 đ: backend xác nhận ngay, không có đơn thanh toán.
      throw const ValidationFailure('Lượt gửi xe đã được xác nhận miễn phí');
    }
    return payment['orderCode']! as String;
  }
}
