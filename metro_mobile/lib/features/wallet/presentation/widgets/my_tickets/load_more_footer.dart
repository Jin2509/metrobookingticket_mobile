import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Chân danh sách tải dần: đang tải / lỗi + thử lại / hết dữ liệu.
class LoadMoreFooter extends StatelessWidget {
  const LoadMoreFooter({
    required this.loading,
    required this.hasMore,
    required this.onRetry,
    this.error,
    super.key,
  });

  final bool loading;
  final bool hasMore;
  final String? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final Widget child;
    if (error != null) {
      final l = context.l10n;
      child = TextButton(
        onPressed: onRetry,
        child: Text('${localizeMessage(l, error!)} · ${l.retry}'),
      );
    } else if (loading) {
      child = const MetroSkeleton(height: 72, radius: MetroRadius.lg);
    } else if (!hasMore) {
      child = Text(context.l10n.allShown, style: context.text.labelSmall);
    } else {
      child = const SizedBox(height: 24);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: MetroSpacing.md),
      child: Center(child: child),
    );
  }
}
