import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/notifications/domain/entities/notification_entities.dart';

/// Thẻ tin: nhãn Vận hành/Tin tức, tiêu đề, tóm tắt. Chạm xem chi tiết.
class NewsCard extends StatelessWidget {
  const NewsCard({required this.item, super.key});

  final NewsItem item;

  void _open(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.fromLTRB(
        MetroSpacing.lg,
        0,
        MetroSpacing.lg,
        MetroSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title, style: ctx.text.titleLarge),
          Text(dateTime(item.publishedAt), style: ctx.text.labelSmall),
          MetroSpacing.gapMd,
          Text(item.body, style: ctx.text.bodyMedium),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final tint = item.operational ? m.accent : context.colors.primary;
    return MetroCard(
      onTap: () => _open(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            item.operational
                ? LucideIcons.triangleAlert
                : LucideIcons.newspaper,
            color: tint,
          ),
          MetroSpacing.gapSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.operational ? 'VẬN HÀNH' : 'TIN TỨC',
                  style: context.text.labelSmall?.copyWith(color: tint),
                ),
                Text(item.title, style: context.text.titleSmall),
                Text(item.summary, style: context.text.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
