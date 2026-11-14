import 'package:dio/dio.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/features/wallet/data/dtos/wallet_dtos.dart';
import 'package:metro_mobile/features/wallet/domain/entities/paged.dart';
import 'package:metro_mobile/features/wallet/domain/entities/parking_pass.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket_filter.dart';
import 'package:metro_mobile/features/wallet/domain/entities/wallet_transaction.dart';
import 'package:metro_mobile/features/wallet/domain/repositories/wallet_repository.dart';

/// Trang trả về dạng Spring `Page` (`content`, `last`).
class WalletRemoteSource implements WalletRepository {
  const WalletRemoteSource(this._dio);
  final Dio _dio;

  static const _base = '/api/v1';

  Future<T> _get<T>(String path, [Map<String, Object?>? query]) async {
    try {
      final res = await _dio.get<T>('$_base$path', queryParameters: query);
      return res.data as T;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Paged<T> _page<T>(
    Json body,
    int page,
    T Function(Json) parse, {
    bool Function(T)? where,
  }) => Paged(
    items: [
      for (final j in body['content']! as List)
        if (parse(j as Json) case final item when where?.call(item) ?? true)
          item,
    ],
    page: page,
    hasMore: body['last'] != true,
  );

  /// Backend chỉ lọc được một trạng thái: lọc nhiều trạng thái thì lấy hết
  /// rồi lọc trên máy.
  @override
  Future<Paged<Ticket>> getMyTickets(TicketFilter f, int page, int size) async {
    final single = f.statuses.length == 1;
    final body = await _get<Json>('/me/tickets', {
      if (single) 'status': WalletDtos.ticketStatusParam(f.statuses.single),
      'page': page,
      'size': size,
    });
    return _page(
      body,
      page,
      WalletDtos.ticket,
      where: single ? null : (t) => f.matches(t.status),
    );
  }

  @override
  Future<Ticket> getTicket(String id) async =>
      WalletDtos.ticket(await _get<Json>('/tickets/$id'));

  /// `TransactionPage` = `{transactions: Page, totalAmountVnd}`.
  @override
  Future<Paged<WalletTransaction>> getTransactions(int page, int size) async {
    final body = await _get<Json>('/me/transactions', {
      'page': page,
      'size': size,
    });
    return _page(body['transactions']! as Json, page, WalletDtos.transaction);
  }

  Future<List<ParkingPass>> _parking() async {
    final body = await _get<Json>('/me/parking-bookings', {'size': 100});
    return [
      for (final j in body['content']! as List) WalletDtos.parking(j as Json),
    ];
  }

  @override
  Future<List<ParkingPass>> getActiveParking() async => [
    for (final p in await _parking())
      if (p.isUsable) p,
  ];

  @override
  Future<List<ParkingPass>> getParkingHistory() async => [
    for (final p in await _parking())
      if (!p.isUsable && p.status != 'PENDING') p,
  ];

  /// Không có API lấy một lượt: tìm trong danh sách của tôi.
  @override
  Future<ParkingPass> getParkingPass(String id) async {
    final found = (await _parking()).where((p) => p.id == id).firstOrNull;
    if (found == null) {
      throw const NotFoundFailure('Không tìm thấy lượt gửi xe');
    }
    return found;
  }
}
