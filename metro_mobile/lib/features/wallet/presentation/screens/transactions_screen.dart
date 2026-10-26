import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/wallet/presentation/controllers/wallet_controllers.dart';
import 'package:metro_mobile/features/wallet/presentation/widgets/my_tickets/load_more_footer.dart';
import 'package:metro_mobile/features/wallet/presentation/widgets/transactions/transaction_tile.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P52. Lịch sử giao dịch cá nhân (UC9-01), tải dần.
class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(transactionsProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.menuTransactions)),
      body: AsyncValueView(
        value: ref.watch(transactionsProvider),
        onRetry: () => ref.invalidate(transactionsProvider),
        data: (s) => s.items.isEmpty
            ? EmptyState(
                icon: LucideIcons.receipt,
                title: context.l10n.noTransactions,
              )
            : NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (n.metrics.extentAfter < 300) unawaited(ctrl.loadMore());
                  return false;
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(MetroSpacing.md),
                  itemCount: s.items.length + 1,
                  separatorBuilder: (_, _) => MetroSpacing.gapSm,
                  itemBuilder: (_, i) => i == s.items.length
                      ? LoadMoreFooter(
                          loading: s.loadingMore,
                          hasMore: s.hasMore,
                          error: s.moreError,
                          onRetry: ctrl.loadMore,
                        )
                      : TransactionTile(tx: s.items[i]),
                ),
              ),
      ),
    );
  }
}
