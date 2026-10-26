import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/gallery/sections/gallery_section.dart';
import 'package:metro_mobile/design_system/molecules/countdown_chip.dart';
import 'package:metro_mobile/design_system/molecules/empty_state.dart';
import 'package:metro_mobile/design_system/molecules/error_state.dart';
import 'package:metro_mobile/design_system/molecules/metro_card.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

class FeedbackSection extends StatelessWidget {
  const FeedbackSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GallerySection(
      title: 'CountdownChip · EmptyState · ErrorState',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Wrap(
            spacing: MetroSpacing.xs,
            children: [
              CountdownChip(duration: Duration(minutes: 9, seconds: 42)),
              CountdownChip(duration: Duration(seconds: 45)),
            ],
          ),
          MetroSpacing.gapSm,
          MetroCard(
            child: EmptyState(
              icon: LucideIcons.ticket,
              title: 'Bạn chưa có vé nào',
              message: 'Đặt vé chỉ với 3 chạm từ Trang chủ',
              actionLabel: 'Đặt vé ngay',
              onAction: () {},
            ),
          ),
          MetroSpacing.gapSm,
          MetroCard(
            child: ErrorState(
              message: 'Không tải được danh sách ga',
              onRetry: () {},
            ),
          ),
        ],
      ),
    );
  }
}
