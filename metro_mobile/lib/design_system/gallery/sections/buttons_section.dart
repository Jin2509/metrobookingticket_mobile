import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/atoms/metro_button.dart';
import 'package:metro_mobile/design_system/atoms/metro_icon_button.dart';
import 'package:metro_mobile/design_system/gallery/sections/gallery_section.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

class ButtonsSection extends StatelessWidget {
  const ButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    void noop() {}
    return GallerySection(
      title: 'MetroButton · MetroIconButton',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MetroButton(
            label: 'Thanh toán',
            icon: LucideIcons.qrCode,
            expand: true,
            onPressed: noop,
          ),
          MetroSpacing.gapXs,
          Wrap(
            spacing: MetroSpacing.xs,
            runSpacing: MetroSpacing.xs,
            children: [
              for (final v in MetroButtonVariant.values.skip(1))
                MetroButton(label: v.name, variant: v, onPressed: noop),
            ],
          ),
          MetroSpacing.gapXs,
          Wrap(
            spacing: MetroSpacing.xs,
            runSpacing: MetroSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              MetroButton(
                label: 'sm',
                size: MetroButtonSize.sm,
                onPressed: noop,
              ),
              MetroButton(
                label: 'lg',
                size: MetroButtonSize.lg,
                onPressed: noop,
              ),
              const MetroButton(
                label: 'Đang gửi',
                loading: true,
                onPressed: null,
              ),
              const MetroButton(label: 'Khóa', onPressed: null),
              MetroIconButton(
                icon: LucideIcons.bell,
                tooltip: 'Thông báo',
                badgeCount: 3,
                onPressed: noop,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
