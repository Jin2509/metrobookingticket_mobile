import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/booking/domain/entities/booking_request.dart';
import 'package:metro_mobile/features/booking/presentation/controllers/booking_controllers.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/booking_confirm/fare_breakdown.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/booking_confirm/pay_button_bar.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/booking_confirm/payment_method_card.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/booking_confirm/trip_header.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/purchase/active_ticket_notice.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/purchase/booking_steps.dart';
import 'package:metro_mobile/features/wallet/presentation/controllers/wallet_controllers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P30. Xác nhận vé – bước 2/3: giá, ưu đãi, phương thức (VietQR).
class BookingConfirmScreen extends ConsumerWidget {
  const BookingConfirmScreen({required this.request, super.key});

  final BookingRequest request;

  Future<void> _pay(BuildContext context, WidgetRef ref) async {
    final ctrl = ref.read(bookingControllerProvider(request).notifier);
    final session = await ctrl.pay();
    if (session != null && context.mounted) {
      context.pushReplacement(Routes.payment(session.orderId, steps: true));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preview = ref.watch(orderPreviewProvider(request));
    final form = ref.watch(bookingControllerProvider(request));
    // Vào thẳng từ chatbot hoặc lộ trình cũng phải qua ràng buộc này.
    final blocking = ref.watch(blockingTicketProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.bookingConfirmTitle)),
      bottomNavigationBar: preview.hasValue
          ? PayButtonBar(
              total: preview.requireValue.total,
              loading: form.submitting,
              error: form.error,
              onPay: blocking != null ? null : () => _pay(context, ref),
            )
          : null,
      body: AsyncValueView(
        value: preview,
        onRetry: () => ref.invalidate(orderPreviewProvider(request)),
        data: (p) => ListView(
          padding: const EdgeInsets.all(MetroSpacing.md),
          children: [
            const BookingSteps(current: 1),
            MetroSpacing.gapMd,
            if (blocking != null) ...[
              ActiveTicketNotice(ticket: blocking),
              MetroSpacing.gapMd,
            ],
            MascotTip(text: context.l10n.mascotBookingConfirm),
            MetroSpacing.gapMd,
            TripHeader(preview: p),
            MetroSpacing.gapMd,
            FareBreakdown(preview: p),
            MetroSpacing.gapMd,
            const PaymentMethodCard(),
          ],
        ),
      ),
    );
  }
}
