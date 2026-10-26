import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/atoms/metro_button.dart';
import 'package:metro_mobile/design_system/gallery/sections/gallery_section.dart';
import 'package:metro_mobile/design_system/molecules/route_summary_bar.dart';
import 'package:metro_mobile/design_system/molecules/section_card.dart';
import 'package:metro_mobile/design_system/molecules/stat_card.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

class CardsSection extends StatelessWidget {
  const CardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    void noop() {}
    return GallerySection(
      title: 'SectionCard · RouteSummaryBar · StatCard',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionCard(
            title: 'Đặt vé nhanh',
            actionLabel: 'Bảng giá',
            onAction: noop,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const RouteSummaryBar(
                  from: 'Bến Thành',
                  to: 'Thủ Đức',
                  fare: 12000,
                  minutes: 22,
                  stationCount: 10,
                ),
                MetroSpacing.gapSm,
                MetroButton(label: 'Thanh toán', expand: true, onPressed: noop),
              ],
            ),
          ),
          MetroSpacing.gapSm,
          const Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'Điểm tích lũy',
                  value: '820',
                  hint: 'Hạng Bạc',
                  icon: LucideIcons.award,
                ),
              ),
              MetroSpacing.gapSm,
              Expanded(
                child: StatCard(
                  label: 'Vào ga hôm nay',
                  value: '412',
                  hint: '7 từ chối',
                  icon: LucideIcons.logIn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
