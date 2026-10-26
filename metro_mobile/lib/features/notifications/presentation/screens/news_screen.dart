import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/notifications/presentation/controllers/prefs_controller.dart';
import 'package:metro_mobile/features/notifications/presentation/widgets/news_card.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P61. Tin tức & thông báo vận hành.
class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.menuNews)),
      body: AsyncValueView(
        value: ref.watch(newsProvider),
        onRetry: () => ref.invalidate(newsProvider),
        data: (list) => list.isEmpty
            ? EmptyState(
                icon: LucideIcons.newspaper,
                title: context.l10n.noNews,
              )
            : ListView.separated(
                padding: const EdgeInsets.all(MetroSpacing.md),
                itemCount: list.length,
                separatorBuilder: (_, _) => MetroSpacing.gapSm,
                itemBuilder: (_, i) => NewsCard(item: list[i]),
              ),
      ),
    );
  }
}
