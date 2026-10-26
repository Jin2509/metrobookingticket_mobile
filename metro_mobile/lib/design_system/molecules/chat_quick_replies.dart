import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// Hàng gợi ý trả lời nhanh, cuộn ngang (P70).
class ChatQuickReplies extends StatelessWidget {
  const ChatQuickReplies({
    required this.suggestions,
    required this.onSelected,
    super.key,
  });

  final List<String> suggestions;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: MetroSpacing.screenPadding,
        itemCount: suggestions.length,
        separatorBuilder: (_, _) => MetroSpacing.gapXs,
        itemBuilder: (context, i) => Material(
          color: m.secondary,
          shape: const RoundedRectangleBorder(borderRadius: MetroRadius.brPill),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => onSelected(suggestions[i]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Center(
                child: Text(
                  suggestions[i],
                  style: context.text.labelMedium?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
