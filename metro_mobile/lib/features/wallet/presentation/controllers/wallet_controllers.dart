import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/features/wallet/domain/entities/paged.dart';
import 'package:metro_mobile/features/wallet/domain/entities/parking_pass.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket_filter.dart';
import 'package:metro_mobile/features/wallet/domain/entities/wallet_transaction.dart';
import 'package:metro_mobile/features/wallet/presentation/controllers/paged_controller.dart';
import 'package:metro_mobile/features/wallet/wallet_providers.dart';

/// P40: vé theo bộ lọc.
final ticketsProvider = AsyncNotifierProvider.autoDispose
    .family<TicketsController, PagedState<Ticket>, TicketFilter>(
      TicketsController.new,
    );

class TicketsController extends PagedController<Ticket> {
  TicketsController(this.filter);
  final TicketFilter filter;

  @override
  Future<Paged<Ticket>> fetch(int page) =>
      ref.read(getMyTicketsProvider).call(filter, page: page);
}

/// P52: lịch sử giao dịch.
final transactionsProvider =
    AsyncNotifierProvider.autoDispose<
      TransactionsController,
      PagedState<WalletTransaction>
    >(TransactionsController.new);

class TransactionsController extends PagedController<WalletTransaction> {
  @override
  Future<Paged<WalletTransaction>> fetch(int page) =>
      ref.read(getMyTransactionsProvider).call(page: page);
}

final ticketDetailProvider = FutureProvider.autoDispose.family<Ticket, String>(
  (ref, id) => ref.watch(getTicketDetailProvider).call(id),
);

/// Vé còn dùng được, cho thẻ "Vé đang hiệu lực" ở Trang chủ.
final activeTicketsProvider = FutureProvider.autoDispose<List<Ticket>>((
  ref,
) async {
  final usable = await ref
      .watch(getMyTicketsProvider)
      .call(TicketFilter.unused);
  final inUse = await ref.watch(getMyTicketsProvider).call(TicketFilter.inUse);
  return [...inUse.items, ...usable.items];
});

/// Chỉ dùng khi demo: tài khoản mẫu luôn có vé còn hạn, cần tạm bỏ ràng buộc
/// để thử được luồng mua.
final ticketLimitBypassProvider = NotifierProvider<TicketLimitBypass, bool>(
  TicketLimitBypass.new,
);

class TicketLimitBypass extends Notifier<bool> {
  TicketLimitBypass({this.initial = false});
  final bool initial;

  @override
  bool build() => initial;

  void enable() => state = true;
  void disable() => state = false;
}

/// Vé tàu còn hiệu lực khiến chưa được mua vé mới, `null` nếu mua được. Backend
/// cũng phải kiểm tra lại vì đây chỉ là ràng buộc trên giao diện.
final blockingTicketProvider = Provider.autoDispose<Ticket?>((ref) {
  if (ref.watch(ticketLimitBypassProvider)) return null;
  final tickets = ref.watch(activeTicketsProvider).value ?? const <Ticket>[];
  final now = clock.now();
  return tickets
      .where((t) => t.isUsable && t.validUntil.isAfter(now))
      .firstOrNull;
});

final activeParkingProvider = FutureProvider.autoDispose<List<ParkingPass>>(
  (ref) => ref.watch(getActiveParkingProvider).call(),
);

final parkingHistoryProvider = FutureProvider.autoDispose<List<ParkingPass>>(
  (ref) => ref.watch(getActiveParkingProvider).history(),
);

final parkingPassProvider = FutureProvider.autoDispose
    .family<ParkingPass, String>(
      (ref, id) => ref.watch(getActiveParkingProvider).byId(id),
    );

/// Gọi sau khi mua vé / gửi xe để các danh sách tải lại.
void refreshWallet(WidgetRef ref) {
  ref
    ..invalidate(ticketsProvider)
    ..invalidate(activeTicketsProvider)
    ..invalidate(activeParkingProvider)
    ..invalidate(parkingHistoryProvider)
    ..invalidate(transactionsProvider);
}
