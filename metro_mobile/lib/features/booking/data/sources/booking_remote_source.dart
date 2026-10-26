import 'package:dio/dio.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/core/network/stomp_client.dart';
import 'package:metro_mobile/features/booking/data/dtos/booking_dtos.dart';
import 'package:metro_mobile/features/booking/data/sources/booking_source.dart';
import 'package:metro_mobile/features/booking/domain/entities/booking_request.dart';
import 'package:metro_mobile/features/booking/domain/entities/order_preview.dart';
import 'package:metro_mobile/features/booking/domain/entities/payment.dart';
import 'package:metro_mobile/features/booking/domain/entities/ticket_type.dart';

class BookingRemoteSource implements BookingSource {
  const BookingRemoteSource(this._dio, this._stomp);
  final Dio _dio;
  final MetroStompClient _stomp;

  Future<Json> _call(String method, String path, [Json? body]) async {
    try {
      final res = await _dio.request<Json>(
        path,
        data: body,
        options: Options(method: method),
      );
      return res.data ?? const {};
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  /// Bảng `ticket_type` + `ticket_price`; endpoint cần thống nhất.
  @override
  Future<FareTable> fetchFareTable() async =>
      BookingDtos.fareTable(await _call('GET', '/api/ticket-types'));

  @override
  Future<OrderPreview> preview(BookingRequest r) async => BookingDtos.preview(
    await _call('POST', '/api/orders/preview', BookingDtos.request(r)),
    r,
  );

  @override
  Future<PaymentSession> createPayment(
    BookingRequest r, {
    required bool usePoints,
  }) async => BookingDtos.session(
    await _call('POST', '/api/payments/create', {
      ...BookingDtos.request(r),
      'usePoints': usePoints,
    }),
  );

  @override
  Future<PaymentSession> fetchSession(String orderId) async =>
      BookingDtos.session(await _call('GET', '/api/payments/$orderId'));

  @override
  Future<PaymentUpdate> fetchStatus(String orderId) async =>
      BookingDtos.update(await _call('GET', '/api/payments/$orderId'));

  @override
  Future<PaymentSession> renew(String orderId) async =>
      BookingDtos.session(await _call('POST', '/api/payments/$orderId/renew'));

  @override
  Future<void> cancel(String orderId) =>
      _call('POST', '/api/payments/$orderId/cancel');

  @override
  Stream<PaymentUpdate> paymentEvents(String orderId) => _stomp
      .subscribe('/user/queue/payments')
      .where((j) => j is Json)
      .map((j) => BookingDtos.update(j! as Json))
      .where((u) => u.orderId == orderId);
}
