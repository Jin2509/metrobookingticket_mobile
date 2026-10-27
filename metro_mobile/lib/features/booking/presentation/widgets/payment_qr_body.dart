import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/booking/domain/entities/payment.dart';
import 'package:metro_mobile/features/booking/presentation/controllers/payment_controller.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/purchase/booking_steps.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Ghép `PaymentQrSheet` với controller: bước 3/3, mã VietQR (SePay),
/// thông tin chuyển khoản, đếm ngược, tạo mã mới, hủy.
class PaymentQrBody extends ConsumerWidget {
  const PaymentQrBody({
    required this.orderId,
    this.showSteps = false,
    super.key,
  });

  final String orderId;
  final bool showSteps;

  static Future<void> confirmCancel(
    BuildContext context,
    WidgetRef ref,
    String orderId,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.cancelTransactionTitle),
        content: Text(ctx.l10n.cancelTransactionBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(ctx.l10n.continuePayment),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(ctx.l10n.cancelTransaction),
          ),
        ],
      ),
    );
    if (!(ok ?? false) || !context.mounted) return;
    await ref.read(paymentControllerProvider(orderId).notifier).cancel();
    if (context.mounted) context.go(Routes.pHome);
  }

  static Widget? _details(BuildContext context, PaymentSession s) {
    final t = s.transfer;
    if (t == null) return null;
    final l = context.l10n;
    return TransferDetailsCard(
      title: l.manualTransfer,
      rows: [
        TransferRow(l.bank, t.bankName),
        TransferRow(l.accountNumber, t.accountNumber, copy: t.accountNumber),
        TransferRow(l.accountName, t.accountName),
        TransferRow(l.amount, money(s.amount), copy: '${s.amount}'),
        TransferRow(
          l.transferContent,
          t.content,
          copy: t.content,
          highlight: true,
        ),
      ],
      note: Env.useFakeData ? l.transferNoteDemo : l.transferNote,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paymentControllerProvider(orderId));
    final ctrl = ref.read(paymentControllerProvider(orderId).notifier);
    final session = state.session;
    if (state.error != null) {
      return ErrorState(
        message: state.error!,
        onRetry: () => context.go(Routes.pHome),
      );
    }
    if (session == null) {
      return const Center(child: MetroSkeleton(width: 252, height: 252));
    }
    final left = session.expiresAt.difference(DateTime.now().toUtc());
    return ListView(
      padding: const EdgeInsets.all(MetroSpacing.md),
      children: [
        if (showSteps) ...[const BookingSteps(current: 2), MetroSpacing.gapMd],
        PaymentQrSheet(
          qrData: session.qrContent,
          amount: session.amount,
          orderCode: session.orderCode,
          timeLeft: left.isNegative ? Duration.zero : left,
          expired: state.expired || left.isNegative,
          cancelling: state.cancelling,
          onExpired: ctrl.expire,
          onRenew: ctrl.renew,
          onCancel: () => confirmCancel(context, ref, orderId),
          details: _details(context, session),
        ),
      ],
    );
  }
}
