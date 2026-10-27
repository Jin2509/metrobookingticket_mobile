import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/notifications/presentation/controllers/prefs_controller.dart';
import 'package:metro_mobile/features/notifications/presentation/widgets/news_tag.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P62. Chi tiết tin: ảnh, nhãn + ngày, tiêu đề, nội dung.
class NewsDetailScreen extends ConsumerWidget {
  const NewsDetailScreen({required this.newsId, super.key});

  final String newsId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.menuNews)),
      body: AsyncValueView(
        value: ref.watch(newsItemProvider(newsId)),
        onRetry: () => ref.invalidate(newsProvider),
        data: (n) => n == null
            ? EmptyState(
                icon: LucideIcons.newspaper,
                title: context.l10n.newsNotFound,
              )
            : ListView(
                children: [
                  MetroImage(src: n.imageUrl),
                  Padding(
                    padding: const EdgeInsets.all(MetroSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NewsTag(item: n),
                        MetroSpacing.gapXs,
                        Text(n.title, style: context.text.titleLarge),
                        MetroSpacing.gapMd,
                        Text(
                          n.body,
                          style: context.text.bodyLarge?.copyWith(height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
