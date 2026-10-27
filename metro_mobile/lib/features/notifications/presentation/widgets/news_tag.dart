import 'package:flutter/material.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/notifications/domain/entities/notification_entities.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `VẬN HÀNH · 27/10/2026` hoặc `TIN TỨC · ...` phía trên tiêu đề tin.
class NewsTag extends StatelessWidget {
  const NewsTag({required this.item, super.key});

  final NewsItem item;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final tint = item.operational
        ? context.metro.accentForeground
        : context.colors.primary;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: (item.operational ? l.newsTagOperation : l.newsTagNews)
                .toUpperCase(),
            style: TextStyle(color: tint, fontWeight: FontWeight.w700),
          ),
          TextSpan(text: ' · ${dateOnly(item.publishedAt)}'),
        ],
      ),
      style: context.text.labelSmall,
    );
  }
}
