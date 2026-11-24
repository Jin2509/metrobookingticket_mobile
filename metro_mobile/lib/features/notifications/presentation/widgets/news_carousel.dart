import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/notifications/domain/entities/notification_entities.dart';
import 'package:metro_mobile/features/notifications/presentation/controllers/prefs_controller.dart';
import 'package:metro_mobile/features/notifications/presentation/widgets/news_card.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `Tin tức Metro  [Xem tất cả]` + băng thẻ tin cuộn ngang (P10).
class NewsCarousel extends ConsumerWidget {
  const NewsCarousel({super.key});

  static const _cardWidth = 248.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final async = ref.watch(newsProvider);
    final news = async.value ?? const [];
    // Luôn giữ tiêu đề mục: trước đây rỗng/lỗi thì ẩn hẳn, trông như mất
    // tính năng Tin tức.
    final Widget body;
    if (news.isNotEmpty) {
      body = _strip(news);
    } else if (async.isLoading) {
      body = const _Placeholder(child: LinearProgressIndicator());
    } else if (async.hasError) {
      body = _Placeholder(
        icon: LucideIcons.wifiOff,
        text: async.error is Failure
            ? (async.error! as Failure).message
            : l.newsLoadFailed,
        action: TextButton(
          onPressed: () => ref.invalidate(newsProvider),
          child: Text(l.retry),
        ),
      );
    } else {
      body = _Placeholder(icon: LucideIcons.newspaper, text: l.noNews);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MetroSectionHeader(
          title: l.menuNews,
          actionLabel: l.viewAll,
          onAction: () => context.push(Routes.pNews),
        ),
        body,
      ],
    );
  }

  Widget _strip(List<NewsItem> news) => SingleChildScrollView(
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
  );
}

/// Một dòng gọn thay cho băng tin khi đang tải, chưa có tin hoặc tải lỗi.
class _Placeholder extends StatelessWidget {
  const _Placeholder({this.icon, this.text, this.action, this.child});

  final IconData? icon;
  final String? text;
  final Widget? action;
  final Widget? child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: MetroSpacing.sm),
    child:
        child ??
        Row(
          children: [
            Icon(icon, size: 20, color: context.colors.onSurfaceVariant),
            MetroSpacing.gapSm,
            Expanded(child: Text(text ?? '', style: context.text.bodyMedium)),
            ?action,
          ],
        ),
  );
}
