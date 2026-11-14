import 'package:dio/dio.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/features/booking/data/dtos/booking_dtos.dart';
import 'package:metro_mobile/features/booking/data/sources/booking_source.dart';
import 'package:metro_mobile/features/booking/domain/entities/booking_request.dart';
import 'package:metro_mobile/features/booking/domain/entities/order_preview.dart';
import 'package:metro_mobile/features/booking/domain/entities/payment.dart';
import 'package:metro_mobile/features/booking/domain/entities/ticket_type.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';

/// Mua vé = `POST /api/v1/tickets` (vé chờ thanh toán + đơn SePay), rồi poll
/// `GET /api/v1/me/payment-orders/{orderCode}` tới khi `PAID`. `orderId` của
/// app chính là `orderCode`.
class BookingRemoteSource implements BookingSource {
  BookingRemoteSource(this._dio, {required this.catalog});
  final Dio _dio;

  /// Tên ga cho màn xác nhận (báo giá chỉ trả id).
  final Future<NetworkCatalog> Function() catalog;

  static const _base = '/api/v1';

  /// Đơn → vé vừa tạo, để mở QR vé khi thanh toán xong.
  final _ticketOf = <String, String>{};

  /// Đơn → yêu cầu gốc, để "Tạo mã mới" đặt lại khi đơn cũ hết hạn.
  final _requestOf = <String, BookingRequest>{};

  /// Đơn cũ → đơn thay thế sau "Tạo mã mới".
  final _renewed = <String, String>{};

  String _latest(String code) {
    var c = code;
    for (var next = _renewed[c]; next != null; next = _renewed[c]) {
      c = next;
    }
    return c;
  }

  Future<T> _call<T>(
    String method,
    String path, {
    Object? body,
    Map<String, dynamic>? query,
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

  Future<List<Json>> _list(String path) async => [
    for (final j in await _call<List<dynamic>>('GET', path)) j as Json,
  ];

  @override
  Future<FareTable> fetchFareTable() async {
    final [products, fares] = await Future.wait([
      _list('/public/ticket-products'),
      _list('/public/fares'),
    ], eagerError: true);
    return BookingDtos.fareTable(products, fares);
  }

  @override
  Future<OrderPreview> preview(BookingRequest r) async {
    final table = await fetchFareTable();
    final type = table.types.where((t) => t.code == r.typeCode).firstOrNull;
    if (type == null) throw const NotFoundFailure('Loại vé không còn bán');
    if (type.price case final price?) {
      return BookingDtos.preview(request: r, type: type, basePrice: price);
    }
    final quote = await _call<Json>(
      'GET',
      '/public/fares/quote',
      query: {
        'fromStationId': r.fromId,
        'toStationId': r.toId,
        'productCode': r.typeCode,
      },
    );
    final net = await catalog();
    return BookingDtos.preview(
      request: r,
      type: type,
      basePrice: (quote['priceVnd']! as num).toInt(),
      fromName: net.station(r.fromId!)?.name,
      toName: net.station(r.toId!)?.name,
    );
  }

  @override
  Future<PaymentSession> createPayment(BookingRequest r) async {
    final ticket = await _call<Json>(
      'POST',
      '/tickets',
      body: BookingDtos.purchase(r),
    );
    final payment = ticket['payment'] as Json?;
    if (payment == null) {
      throw const ServerFailure('Không tạo được đơn thanh toán');
    }
    final session = BookingDtos.session(payment);
    _ticketOf[session.orderId] = '${ticket['id']}';
    _requestOf[session.orderId] = r;
    return session;
  }

  Future<Json> _order(String orderId) =>
      _call<Json>('GET', '/me/payment-orders/${_latest(orderId)}');

  @override
  Future<PaymentSession> fetchSession(String orderId) async =>
      BookingDtos.session(await _order(orderId));

  @override
  Future<PaymentUpdate> fetchStatus(String orderId) async {
    final code = _latest(orderId);
    final u = BookingDtos.update(await _order(code), ticketId: _ticketOf[code]);
    // Màn thanh toán theo dõi theo mã đơn ban đầu.
    return PaymentUpdate(
      orderId: orderId,
      status: u.status,
      ticketId: u.ticketId,
    );
  }

  /// Backend không gia hạn được đơn: đặt lại đơn mới cùng yêu cầu.
  @override
  Future<PaymentSession> renew(String orderId) async {
    final code = _latest(orderId);
    final r = _requestOf[code];
    if (r == null) {
      throw const ValidationFailure('Mã đã hết hạn, vui lòng đặt lại vé');
    }
    final next = await createPayment(r);
    _renewed[code] = next.orderId;
    return next;
  }

  @override
  Future<void> cancel(String orderId) =>
      _call<Json>('POST', '/me/payment-orders/${_latest(orderId)}/cancel');

  /// Backend không đẩy trạng thái đơn qua WS: chỉ dựa vào poll.
  @override
  Stream<PaymentUpdate> paymentEvents(String orderId) => const Stream.empty();
}
