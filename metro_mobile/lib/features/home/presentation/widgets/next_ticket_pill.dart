import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/wallet/presentation/controllers/wallet_controllers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Vé dùng được gần nhất, mở QR một chạm ngay đầu Trang chủ (P3).
class NextTicketPill extends ConsumerWidget {
  const NextTicketPill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickets = ref.watch(activeTicketsProvider).value ?? const [];
    if (tickets.isEmpty) return const SizedBox.shrink();
    final t = tickets.first;
    final m = context.metro;
    final route = t.fromName != null && t.toName != null
        ? '${t.fromName} → ${t.toName}'
        : t.typeName;
    return Padding(
      padding: const EdgeInsets.only(top: MetroSpacing.sm),
      child: Material(
        color: MetroColors.primaryForeground.withValues(alpha: .12),
        borderRadius: MetroRadius.brLg,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(Routes.ticketDetail(t.id)),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: MetroSpacing.sm,
              vertical: MetroSpacing.sm,
            ),
            child: Row(
              children: [
                Icon(LucideIcons.qrCode, color: m.sidebarPrimary),
                MetroSpacing.gapSm,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.homeNextTicket,
                        style: MetroTypography.label.copyWith(
                          color: m.sidebarForeground,
                        ),
                      ),
                      Text(
                        route,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: MetroTypography.titleSmall.copyWith(
                          color: MetroColors.primaryForeground,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  context.l10n.openQr,
                  style: MetroTypography.label.copyWith(
                    color: m.sidebarPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: m.sidebarPrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
