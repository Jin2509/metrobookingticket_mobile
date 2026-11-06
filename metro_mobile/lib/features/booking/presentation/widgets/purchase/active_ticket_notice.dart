import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket.dart';
import 'package:metro_mobile/features/wallet/presentation/controllers/wallet_controllers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Báo vì sao chưa mua được vé mới: vé trước còn hiệu lực, kèm lối mở vé đó.
class ActiveTicketNotice extends ConsumerWidget {
  const ActiveTicketNotice({required this.ticket, super.key});

  final Ticket ticket;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return MetroCard(
      padding: const EdgeInsets.all(MetroSpacing.sm),
      color: context.metro.accent.withValues(alpha: .1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.ticketLimitTitle, style: context.text.titleSmall),
          MetroSpacing.gapXxs,
          Text(
            l.ticketLimitBody(ticket.typeName, dateTime(ticket.validUntil)),
            style: context.text.bodySmall,
          ),
          MetroSpacing.gapXs,
          MetroButton(
            label: l.ticketLimitOpen,
            expand: true,
            size: MetroButtonSize.sm,
            variant: MetroButtonVariant.outline,
            onPressed: () => context.push(Routes.ticketDetail(ticket.id)),
          ),
          // Tài khoản demo luôn có vé còn hạn, cần lối này để thử luồng mua.
          if (Env.useFakeData)
            TextButton(
              onPressed: () =>
                  ref.read(ticketLimitBypassProvider.notifier).enable(),
              child: Text(l.ticketLimitDemo),
            ),
        ],
      ),
    );
  }
}
