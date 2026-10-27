import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/molecules/metro_card.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Một dòng thông tin chuyển khoản; [copy] khác null thì có nút sao chép.
class TransferRow {
  const TransferRow(
    this.label,
    this.value, {
    this.copy,
    this.highlight = false,
  });
  final String label;
  final String value;
  final String? copy;
  final bool highlight;
}

/// Khối "chuyển khoản thủ công" dưới mã QR: ngân hàng, số TK, chủ TK,
/// số tiền, nội dung. Dùng khi thanh toán ngay trên điện thoại đang
/// hiện mã (không tự quét được).
class TransferDetailsCard extends StatelessWidget {
  const TransferDetailsCard({
    required this.title,
    required this.rows,
    this.note,
    super.key,
  });

  final String title;
  final List<TransferRow> rows;
  final String? note;

  Future<void> _copy(BuildContext context, String v) async {
    await Clipboard.setData(ClipboardData(text: v));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.l10n.copied(v))));
  }

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final t = Theme.of(context).textTheme;
    return MetroCard(
      padding: const EdgeInsets.fromLTRB(
        MetroSpacing.md,
        MetroSpacing.sm,
        MetroSpacing.xxs,
        MetroSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: t.titleSmall),
          for (final r in rows)
            ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: MetroSpacing.minTouch,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 104,
                    child: Text(r.label, style: t.bodySmall),
                  ),
                  Expanded(
                    child: Text(
                      r.value,
                      style: (r.highlight ? t.titleMedium : t.bodyLarge)
                          ?.copyWith(
                            color: r.highlight
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                    ),
                  ),
                  if (r.copy != null)
                    IconButton(
                      tooltip: context.l10n.copy,
                      icon: Icon(
                        LucideIcons.copy,
                        size: 18,
                        color: m.mutedForeground,
                      ),
                      onPressed: () => _copy(context, r.copy!),
                    )
                  else
                    const SizedBox(width: MetroSpacing.minTouch),
                ],
              ),
            ),
          if (note != null)
            Padding(
              padding: const EdgeInsets.only(right: MetroSpacing.sm),
              child: Text(
                note!,
                style: t.bodySmall?.copyWith(color: m.accentForeground),
              ),
            ),
        ],
      ),
    );
  }
}
