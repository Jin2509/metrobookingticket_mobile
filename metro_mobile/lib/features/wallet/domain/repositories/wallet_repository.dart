import 'package:metro_mobile/features/wallet/domain/entities/paged.dart';
import 'package:metro_mobile/features/wallet/domain/entities/parking_pass.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket_filter.dart';
import 'package:metro_mobile/features/wallet/domain/entities/wallet_transaction.dart';

/// Chỉ dữ liệu của chính người dùng (endpoint `/my`, mục 10.2).
abstract interface class WalletRepository {
  Future<Paged<Ticket>> getMyTickets(TicketFilter filter, int page, int size);
  Future<Ticket> getTicket(String id);
  Future<Paged<WalletTransaction>> getTransactions(int page, int size);
  Future<List<ParkingPass>> getActiveParking();
  Future<ParkingPass> getParkingPass(String id);
}
