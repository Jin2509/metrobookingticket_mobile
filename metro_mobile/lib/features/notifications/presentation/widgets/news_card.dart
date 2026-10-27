import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/notifications/domain/entities/notification_entities.dart';
import 'package:metro_mobile/features/notifications/presentation/widgets/news_tag.dart';

/// Thẻ tin: ảnh tiêu đề, nhãn + ngày, tiêu đề, tóm tắt. Chạm → P62.
/// [compact] dùng cho băng tin ngang ở Trang chủ (ẩn tóm tắt).
class NewsCard extends StatelessWidget {
  const NewsCard({required this.item, this.compact = false, super.key});

  final NewsItem item;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return MetroCard(
      padding: EdgeInsets.zero,
      onTap: () => context.push(Routes.newsDetail(item.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MetroImage(src: item.imageUrl),
          Padding(
            padding: const EdgeInsets.all(MetroSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NewsTag(item: item),
                MetroSpacing.gapXxs,
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleSmall,
                ),
                if (!compact) ...[
                  MetroSpacing.gapXxs,
                  Text(item.summary, style: context.text.bodySmall),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
