import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/parking/domain/entities/parking_lot.dart';
import 'package:metro_mobile/features/parking/presentation/controllers/parking_form_controller.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Thanh dưới của luồng gửi xe: phí, Quay lại, Tiếp tục hoặc Thanh toán.
/// A3 hết chỗ, A4 còn lượt: khóa nút và nói rõ lý do.
class ParkingStepBar extends ConsumerWidget {
  const ParkingStepBar({
    required this.step,
    required this.lot,
    required this.onStep,
    super.key,
  });

  /// 0 chọn bãi, 1 thông tin, 2 xác nhận.
  final int step;
  final ParkingLot lot;
  final ValueChanged<int> onStep;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s = ref.watch(parkingFormProvider);
    final full = lot.capacityOf(s.vehicle)?.isFull ?? true;
    final r = s.requestFor(lot.id);
    final preview = r == null
        ? null
        : ref.watch(parkingPreviewProvider(r)).value;
    final blocked = preview == null || preview.activePassId != null;
    final canGo = !full && (step == 0 || !blocked);
    final reason = full ? l.errParkingFull : s.error;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.metro.card,
        boxShadow: const [BoxShadow(color: Color(0x12101B2B), blurRadius: 20)],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(MetroSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (reason != null) ...[
                Text(
                  reason,
                  style: context.text.bodySmall?.copyWith(
                    color: context.metro.destructive,
                  ),
                ),
                MetroSpacing.gapXs,
              ],
              if (step == 1) ...[
                Text(
                  preview == null ? l.feeEmpty : l.fee(money(preview.fee)),
                  style: context.text.titleMedium,
                ),
                MetroSpacing.gapXs,
              ],
              Row(
                children: [
                  if (step > 0) ...[
                    MetroButton(
                      label: l.back,
                      variant: MetroButtonVariant.outline,
                      onPressed: () => onStep(step - 1),
                    ),
                    MetroSpacing.gapSm,
                  ],
                  Expanded(
                    child: MetroButton(
                      label: step == 2 ? l.pay : l.continueAction,
                      expand: true,
                      loading: s.submitting,
                      onPressed: !canGo
                          ? null
                          : step < 2
                          ? () => onStep(step + 1)
                          : () async {
                              final ctrl = ref.read(
                                parkingFormProvider.notifier,
                              );
                              final id = await ctrl.pay(lot.id);
                              if (id != null && context.mounted) {
                                context.pushReplacement(Routes.payment(id));
                              }
                            },
                    ),
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
