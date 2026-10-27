import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/notifications/presentation/controllers/prefs_controller.dart';
import 'package:metro_mobile/features/notifications/presentation/widgets/news_card.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `Tin tức Metro  [Xem tất cả]` + băng thẻ tin cuộn ngang (P10).
class NewsCarousel extends ConsumerWidget {
  const NewsCarousel({super.key});

  static const _cardWidth = 248.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final news = ref.watch(newsProvider).value ?? const [];
    if (news.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.menuNews,
                style: context.text.titleMedium,
              ),
            ),
            TextButton(
              onPressed: () => context.push(Routes.pNews),
              child: Text(context.l10n.viewAll),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (i, n) in news.take(5).indexed) ...[
                  if (i > 0) MetroSpacing.gapSm,
                  SizedBox(
                    width: _cardWidth,
                    child: NewsCard(item: n, compact: true),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
