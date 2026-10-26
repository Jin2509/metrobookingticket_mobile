import 'package:metro_mobile/features/wallet/domain/entities/paged.dart';
import 'package:metro_mobile/features/wallet/domain/entities/parking_pass.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket_filter.dart';
import 'package:metro_mobile/features/wallet/domain/entities/wallet_transaction.dart';
import 'package:metro_mobile/features/wallet/domain/repositories/wallet_repository.dart';

const walletPageSize = 20;

/// UC8-02 Danh sách vé đã mua, lọc theo trạng thái, tải dần.
class GetMyTickets {
  const GetMyTickets(this._repo);
  final WalletRepository _repo;

  Future<Paged<Ticket>> call(TicketFilter filter, {int page = 0}) =>
      _repo.getMyTickets(filter, page, walletPageSize);
}

/// UC8-03 Chi tiết vé.
class GetTicketDetail {
  const GetTicketDetail(this._repo);
  final WalletRepository _repo;

  Future<Ticket> call(String id) => _repo.getTicket(id);
}

/// UC9-01 Lịch sử giao dịch cá nhân.
class GetMyTransactions {
  const GetMyTransactions(this._repo);
  final WalletRepository _repo;

  Future<Paged<WalletTransaction>> call({int page = 0}) =>
      _repo.getTransactions(page, walletPageSize);
}

/// UC10-02 Lượt gửi xe đang hiệu lực.
class GetActiveParking {
  const GetActiveParking(this._repo);
  final WalletRepository _repo;

  Future<List<ParkingPass>> call() => _repo.getActiveParking();

  Future<ParkingPass> byId(String id) => _repo.getParkingPass(id);
}
