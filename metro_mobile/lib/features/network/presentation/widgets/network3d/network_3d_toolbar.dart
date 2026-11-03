import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/domain/entities/metro_line.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Thanh trên của sơ đồ: quay lại, tiêu đề, chuyển 3D/2D, lọc theo tuyến.
class Network3dToolbar extends StatelessWidget {
  const Network3dToolbar({
    required this.is3d,
    required this.onModeChanged,
    required this.lines,
    required this.lineId,
    required this.onLineChanged,
    super.key,
  });

  final bool is3d;
  final ValueChanged<bool> onModeChanged;
  final List<MetroLine> lines;
  final String? lineId;
  final ValueChanged<String?> onLineChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            MetroSpacing.xxs,
            MetroSpacing.xxs,
            MetroSpacing.md,
            MetroSpacing.xxs,
          ),
          child: Row(
            children: [
              const BackButton(),
              Expanded(
                child: Text(l.network3dTitle, style: context.text.titleLarge),
              ),
              SegmentedButton<bool>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(value: true, label: Text(l.network3dMode)),
                  ButtonSegment(value: false, label: Text(l.network2dMode)),
                ],
                selected: {is3d},
                onSelectionChanged: (s) => onModeChanged(s.first),
              ),
            ],
          ),
        ),
        if (is3d)
          SizedBox(
            height: MetroSpacing.minTouch,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: MetroSpacing.screenPadding,
              children: [
                ChoiceChip(
                  label: Text(l.allLines),
                  showCheckmark: false,
                  selected: lineId == null,
                  onSelected: (_) => onLineChanged(null),
                ),
                for (final line in lines) ...[
                  MetroSpacing.gapXs,
                  ChoiceChip(
                    label: Text(line.code),
                    showCheckmark: false,
                    selected: line.id == lineId,
                    onSelected: (_) => onLineChanged(line.id),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
