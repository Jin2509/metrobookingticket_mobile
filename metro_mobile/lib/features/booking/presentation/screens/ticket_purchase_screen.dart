import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/booking/domain/entities/booking_request.dart';
import 'package:metro_mobile/features/booking/domain/entities/ticket_type.dart';
import 'package:metro_mobile/features/booking/presentation/controllers/booking_controllers.dart';
import 'package:metro_mobile/features/booking/presentation/controllers/purchase_controller.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/purchase/purchase_bar.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/purchase/purchase_form.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/purchase/student_status_card.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/student/student_providers.dart';
import 'package:metro_mobile/features/wallet/presentation/controllers/wallet_controllers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P29. Mua vé – bước 1/3: chọn loại vé (+ ga nếu vé lượt) → P30.
class TicketPurchaseScreen extends ConsumerWidget {
  const TicketPurchaseScreen({required this.initial, super.key});

  final BookingRequest initial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = ref.watch(purchaseProvider(initial));
    final table = ref.watch(fareTableProvider);
    final type = table.value?.types
        .where((t) => t.code == r.typeCode)
        .firstOrNull;
    final needsStations = type?.needsStations ?? false;
    final plan = needsStations
        ? ref.watch(routePlanProvider((r.fromId, r.toId))).value
        : null;
    final price = needsStations ? plan?.fare : type?.price;
    // Vé HSSV chưa được xác nhận thì khóa, thông báo nằm dưới danh sách vé.
    final student = ref.watch(studentVerificationProvider).value;
    final blocked =
        ref.watch(blockingTicketProvider) != null ||
        (r.typeCode == studentTicketCode &&
            !(student?.isActive(clock.now()) ?? false));
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.buyTicket),
        actions: [
          TextButton(
            onPressed: () => context.push(Routes.fares),
            child: Text(context.l10n.fares),
          ),
        ],
      ),
      bottomNavigationBar: PurchaseBar(
        price: price,
        onContinue: price == null || blocked
            ? null
            : () => context.push(
                Routes.bookWith(
                  r.typeCode,
                  from: needsStations ? r.fromId : null,
                  to: needsStations ? r.toId : null,
                ),
              ),
      ),
      body: AsyncValueView(
        value: table,
        onRetry: () => ref.invalidate(fareTableProvider),
        data: (t) => Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                MetroSpacing.md,
                MetroSpacing.sm,
                MetroSpacing.md,
                0,
              ),
              child: StudentStatusCard(),
            ),
            Expanded(
              child: PurchaseForm(initial: initial, table: t, plan: plan),
            ),
          ],
        ),
      ),
    );
  }
}
