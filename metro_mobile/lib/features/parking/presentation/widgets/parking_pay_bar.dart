import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/parking/domain/entities/parking_lot.dart';
import 'package:metro_mobile/features/parking/presentation/controllers/parking_form_controller.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `Phí 5.000 ₫  [Thanh toán]` → dùng lại màn QR thanh toán.
/// A3 hết chỗ / A4 còn lượt: khóa nút và nói rõ lý do.
class ParkingPayBar extends ConsumerWidget {
  const ParkingPayBar({required this.lots, super.key});

  final List<ParkingLot> lots;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(parkingFormProvider);
    final lot = lots.where((l) => l.id == s.lotId).firstOrNull ?? lots.first;
    final full = lot.capacityOf(s.vehicle)?.isFull ?? true;
    final r = s.requestFor(lot.id);
    final preview = r == null
        ? null
        : ref.watch(parkingPreviewProvider(r)).value;
    final blocked = full || preview == null || preview.activePassId != null;
    final reason = full ? context.l10n.errParkingFull : s.error;
    final m = context.metro;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: m.card,
        border: Border(top: BorderSide(color: m.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(MetroSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (reason != null)
                Text(
                  reason,
                  style: context.text.bodySmall?.copyWith(color: m.destructive),
                ),
              Row(
                children: [
                  Text(
                    preview == null
                        ? context.l10n.feeEmpty
                        : context.l10n.fee(money(preview.fee)),
                    style: context.text.titleMedium,
                  ),
                  const Spacer(),
                  MetroButton(
                    label: context.l10n.pay,
                    loading: s.submitting,
                    onPressed: blocked
                        ? null
                        : () async {
                            final ctrl = ref.read(parkingFormProvider.notifier);
                            final id = await ctrl.pay(lot.id);
                            if (id != null && context.mounted) {
                              context.pushReplacement(Routes.payment(id));
                            }
                          },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
