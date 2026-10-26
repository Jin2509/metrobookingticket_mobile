import 'package:dio/dio.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/features/wallet/data/dtos/wallet_dtos.dart';
import 'package:metro_mobile/features/wallet/domain/entities/paged.dart';
import 'package:metro_mobile/features/wallet/domain/entities/parking_pass.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket_filter.dart';
import 'package:metro_mobile/features/wallet/domain/entities/wallet_transaction.dart';
import 'package:metro_mobile/features/wallet/domain/repositories/wallet_repository.dart';

/// Endpoint mục 9. Trang trả về dạng Spring `Page` (`content`, `last`).
class WalletRemoteSource implements WalletRepository {
  const WalletRemoteSource(this._dio);
  final Dio _dio;

  Future<T> _get<T>(String path, [Map<String, Object?>? query]) async {
    try {
      return (await _dio.get<T>(path, queryParameters: query)).data as T;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Paged<T> _page<T>(Json body, int page, T Function(Json) parse) => Paged(
    items: [for (final j in body['content']! as List) parse(j as Json)],
    page: page,
    hasMore: body['last'] != true,
  );

  @override
  Future<Paged<Ticket>> getMyTickets(
    TicketFilter f,
    int page,
    int size,
  ) async => _page(
    await _get<Json>('/api/tickets/my', {
      if (f.statuses.isNotEmpty) 'status': f.statuses.join(','),
      'page': page,
      'size': size,
    }),
    page,
    WalletDtos.ticket,
  );

  @override
  Future<Ticket> getTicket(String id) async =>
      WalletDtos.ticket(await _get<Json>('/api/tickets/$id'));

  /// Chưa có trong bảng API mục 9 (UC9-01), cần thống nhất với backend.
  @override
  Future<Paged<WalletTransaction>> getTransactions(int page, int size) async =>
      _page(
        await _get<Json>('/api/transactions/my', {'page': page, 'size': size}),
        page,
        WalletDtos.transaction,
      );

  @override
  Future<List<ParkingPass>> getActiveParking() async => [
    for (final j in await _get<List<dynamic>>('/api/parking/bookings/active'))
      WalletDtos.parking(j as Json),
  ];

  @override
  Future<ParkingPass> getParkingPass(String id) async =>
      WalletDtos.parking(await _get<Json>('/api/parking/bookings/$id'));
}
