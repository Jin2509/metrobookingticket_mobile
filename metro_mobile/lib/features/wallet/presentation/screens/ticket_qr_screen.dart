import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/wallet/presentation/controllers/wallet_controllers.dart';
import 'package:metro_mobile/features/wallet/presentation/widgets/pass_qr/pass_qr_layout.dart';
import 'package:metro_mobile/features/wallet/presentation/widgets/pass_qr/ticket_qr_info.dart';
import 'package:metro_mobile/features/wallet/wallet_providers.dart';

/// P41. QR vé toàn màn hình. Vé hết hạn/đã dùng: QR làm mờ (UC8-03 A1).
class TicketQrScreen extends ConsumerWidget {
  const TicketQrScreen({required this.ticketId, super.key});

  final String ticketId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticket = ref.watch(ticketDetailProvider(ticketId));
    return AsyncValueView(
      value: ticket,
      onRetry: () => ref.invalidate(ticketDetailProvider(ticketId)),
      loading: const Scaffold(
        body: Center(child: MetroSkeleton(width: 260, height: 260)),
      ),
      data: (t) => PassQrLayout(
        code: t.code,
        qr: QrPassView(
          data: ref.watch(buildPassQrProvider).ticket(t),
          active: t.isUsable,
        ),
        info: TicketQrInfo(ticket: t),
      ),
    );
  }
}
