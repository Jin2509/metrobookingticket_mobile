import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket_filter.dart';
import 'package:metro_mobile/features/wallet/presentation/controllers/wallet_controllers.dart';
import 'package:metro_mobile/features/wallet/presentation/mappers/ticket_filter_labels.dart';
import 'package:metro_mobile/features/wallet/presentation/widgets/my_tickets/load_more_footer.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Danh sách vé tải dần, kéo để làm mới. Rỗng thì gợi ý đặt vé (A1).
class TicketList extends ConsumerWidget {
  const TicketList({required this.filter, super.key});

  final TicketFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ticketsProvider(filter);
    final ctrl = ref.read(provider.notifier);
    return AsyncValueView(
      value: ref.watch(provider),
      onRetry: () => ref.invalidate(provider),
      data: (s) => s.items.isEmpty
          ? EmptyState(
              icon: LucideIcons.ticket,
              title: filter == TicketFilter.all
                  ? context.l10n.noTickets
                  : context.l10n.noTicketsFiltered(
                      ticketFilterLabel(context.l10n, filter).toLowerCase(),
                    ),
              actionLabel: context.l10n.bookNow,
              onAction: () => context.go(Routes.pHome),
            )
          : NotificationListener<ScrollNotification>(
              onNotification: (n) {
                if (n.metrics.extentAfter < 300) unawaited(ctrl.loadMore());
                return false;
              },
              child: RefreshIndicator(
                onRefresh: ctrl.refresh,
                child: ListView.separated(
                  padding: const EdgeInsets.all(MetroSpacing.md),
                  itemCount: s.items.length + 1,
                  separatorBuilder: (_, _) => MetroSpacing.gapSm,
                  itemBuilder: (context, i) {
                    if (i == s.items.length) {
                      return LoadMoreFooter(
                        loading: s.loadingMore,
                        hasMore: s.hasMore,
                        error: s.moreError,
                        onRetry: ctrl.loadMore,
                      );
                    }
                    final t = s.items[i];
                    return TicketCard(
                      title: t.typeName,
                      from: t.fromName,
                      to: t.toName,
                      status: t.status,
                      validUntil: t.validUntil,
                      onOpenQr: () => context.push(Routes.ticketDetail(t.id)),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
