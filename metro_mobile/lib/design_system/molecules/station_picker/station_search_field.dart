import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/atoms/metro_text_field.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Ô tìm ga, gõ không dấu vẫn ra kết quả.
class StationSearchField extends StatelessWidget {
  const StationSearchField({required this.onChanged, super.key});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MetroSpacing.screenPadding,
      child: MetroTextField(
        hint: context.l10n.stationSearchHint,
        prefixIcon: LucideIcons.search,
        textInputAction: TextInputAction.search,
        onChanged: onChanged,
      ),
    );
  }
}
