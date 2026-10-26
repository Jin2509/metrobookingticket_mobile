import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/atoms/metro_button_content.dart';
import 'package:metro_mobile/design_system/atoms/metro_button_style.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

export 'metro_button_style.dart' show MetroButtonSize, MetroButtonVariant;

/// Nút chuẩn của app (mục 5.1). `onPressed == null` hoặc `loading` thì
/// nút bị khóa, tránh gửi trùng.
class MetroButton extends StatelessWidget {
  const MetroButton({
    required this.label,
    required this.onPressed,
    this.variant = MetroButtonVariant.primary,
    this.size = MetroButtonSize.md,
    this.icon,
    this.loading = false,
    this.expand = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final MetroButtonVariant variant;
  final MetroButtonSize size;
  final IconData? icon;
  final bool loading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final colors = resolveButtonColors(context, variant);
    final enabled = onPressed != null && !loading;

    final visual = Opacity(
      opacity: enabled || loading ? 1 : 0.5,
      child: Material(
        color: colors.bg,
        shape: RoundedRectangleBorder(
          borderRadius: MetroRadius.brLg,
          side: colors.border == null
              ? BorderSide.none
              : BorderSide(color: colors.border!),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          child: Container(
            height: size.height,
            padding: EdgeInsets.symmetric(horizontal: size.paddingX),
            child: MetroButtonContent(
              label: label,
              icon: icon,
              loading: loading,
              expand: expand,
              size: size,
              color: colors.fg,
            ),
          ),
        ),
      ),
    );
    // Nút nhỏ (sm, cao 40) vẫn có vùng chạm + vùng ngữ nghĩa 48dp.
    return Semantics(
      button: true,
      enabled: enabled,
      child: size.height >= MetroSpacing.minTouch
          ? visual
          : GestureDetector(
              behavior: HitTestBehavior.translucent,
              excludeFromSemantics: true,
              onTap: enabled ? onPressed : null,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: MetroSpacing.minTouch,
                ),
                child: Align(widthFactor: 1, child: visual),
              ),
            ),
    );
  }
}
