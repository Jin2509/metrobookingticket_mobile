import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/atoms/line_chip.dart';
import 'package:metro_mobile/design_system/models/station_option.dart';
import 'package:metro_mobile/design_system/molecules/station_picker/station_filter.dart';
import 'package:metro_mobile/design_system/molecules/station_tile.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// Danh sách ga nhóm theo tuyến, mỗi nhóm có tiêu đề `● Tuyến 1 · tên`.
class StationGroupList extends StatelessWidget {
  const StationGroupList({
    required this.groups,
    required this.onSelected,
    this.disabledId,
    super.key,
  });

  final List<StationGroup> groups;
  final ValueChanged<StationOption> onSelected;

  /// Ga đã chọn ở đầu kia (tránh trùng ga đi/đến, UC5-03 A1).
  final String? disabledId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final g in groups) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              MetroSpacing.md,
              MetroSpacing.md,
              MetroSpacing.md,
              MetroSpacing.xxs,
            ),
            child: Row(
              children: [
                LineChip(line: g.line),
                MetroSpacing.gapXs,
                Expanded(
                  child: Text(
                    g.line.name,
                    style: context.text.labelSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          for (final s in g.stations)
            Opacity(
              opacity: s.id == disabledId ? .4 : 1,
              child: StationTile(
                station: s,
                onTap: s.id == disabledId ? null : () => onSelected(s),
              ),
            ),
          Divider(color: context.metro.border, height: 1),
        ],
      ],
    );
  }
}
