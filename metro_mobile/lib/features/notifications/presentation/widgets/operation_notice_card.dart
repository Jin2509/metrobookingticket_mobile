import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/notifications/presentation/controllers/prefs_controller.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `Thông báo vận hành · ⚠ Bảo trì thang cuốn ga Ba Son ▸` (P10).
class OperationNoticeCard extends ConsumerWidget {
  const OperationNoticeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final news = ref.watch(newsProvider).value ?? const [];
    final notice = news.where((n) => n.operational).firstOrNull;
    if (notice == null) return const SizedBox.shrink();
    final m = context.metro;
    return MetroCard(
      onTap: () => context.push(Routes.pNews),
      child: Row(
        children: [
          Icon(LucideIcons.triangleAlert, color: m.accent),
          MetroSpacing.gapSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.operationNotice,
                  style: context.text.labelSmall,
                ),
                Text(notice.title, style: context.text.bodyLarge),
              ],
            ),
          ),
          Icon(LucideIcons.chevronRight, color: m.mutedForeground),
        ],
      ),
    );
  }
}
