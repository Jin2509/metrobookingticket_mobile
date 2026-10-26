import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/wallet/domain/entities/wallet_transaction.dart';

/// Một giao dịch: tiêu đề, mã đơn, thời gian, số tiền, trạng thái.
class TransactionTile extends StatelessWidget {
  const TransactionTile({required this.tx, super.key});

  final WalletTransaction tx;

  @override
  Widget build(BuildContext context) {
    final failed = tx.status == 'FAILED';
    return MetroCard(
      child: Row(
        children: [
          Icon(
            failed ? LucideIcons.circleX : LucideIcons.receipt,
            color: failed ? context.metro.destructive : context.colors.primary,
          ),
          MetroSpacing.gapSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.title, style: context.text.titleSmall),
                Text(
                  '${tx.orderCode} · ${dateTime(tx.createdAt)}',
                  style: context.text.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MoneyText(tx.amount, strikeThrough: failed),
              MetroSpacing.gapXxs,
              StatusBadge(status: tx.status),
            ],
          ),
        ],
      ),
    );
  }
}
