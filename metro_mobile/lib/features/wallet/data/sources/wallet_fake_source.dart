import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/wallet/data/dtos/wallet_dtos.dart';
import 'package:metro_mobile/features/wallet/domain/entities/paged.dart';
import 'package:metro_mobile/features/wallet/domain/entities/parking_pass.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket_filter.dart';
import 'package:metro_mobile/features/wallet/domain/entities/wallet_transaction.dart';
import 'package:metro_mobile/features/wallet/domain/repositories/wallet_repository.dart';

/// Đọc vé/giao dịch/gửi xe từ `DemoLedger` (chung với Fake đặt vé).
class WalletFakeSource implements WalletRepository {
  WalletFakeSource(
    this._ledger, {
    this.latency = const Duration(milliseconds: 300),
  });

  final DemoLedger _ledger;
  final Duration latency;

  Future<void> _wait() => Future<void>.delayed(latency);

  Paged<T> _slice<T>(List<T> all, int page, int size) {
    final start = page * size;
    final items = all.skip(start).take(size).toList();
    return Paged(items: items, page: page, hasMore: start + size < all.length);
  }

  @override
  Future<Paged<Ticket>> getMyTickets(TicketFilter f, int page, int size) async {
    await _wait();
    final all = [
      for (final r in _ledger.tickets)
        if (f.matches(r['status']! as String)) WalletDtos.ticket(r),
    ];
    return _slice(all, page, size);
  }

  @override
  Future<Ticket> getTicket(String id) async {
    await _wait();
    final r = _ledger.tickets.where((t) => t['id'] == id).firstOrNull;
    if (r == null) throw const NotFoundFailure('Không tìm thấy vé');
    return WalletDtos.ticket(r);
  }

  @override
  Future<Paged<WalletTransaction>> getTransactions(int page, int size) async {
    await _wait();
    return _slice(
      _ledger.transactions.map(WalletDtos.transaction).toList(),
      page,
      size,
    );
  }

  @override
  Future<List<ParkingPass>> getActiveParking() async {
    await _wait();
    return [
      for (final r in _ledger.parking)
        if (r['status'] == 'CHUA_GUI' || r['status'] == 'DANG_GUI')
          WalletDtos.parking(r),
    ];
  }

  @override
  Future<ParkingPass> getParkingPass(String id) async {
    await _wait();
    final r = _ledger.parking.where((p) => p['id'] == id).firstOrNull;
    if (r == null) throw const NotFoundFailure('Không tìm thấy lượt gửi xe');
    return WalletDtos.parking(r);
  }
}
