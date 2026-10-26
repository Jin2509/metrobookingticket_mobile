import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/models/station_option.dart';
import 'package:metro_mobile/design_system/molecules/empty_state.dart';
import 'package:metro_mobile/design_system/molecules/station_picker/recent_stations.dart';
import 'package:metro_mobile/design_system/molecules/station_picker/station_filter.dart';
import 'package:metro_mobile/design_system/molecules/station_picker/station_group_list.dart';
import 'package:metro_mobile/design_system/molecules/station_picker/station_search_field.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Bottom sheet chọn ga: tìm không dấu, "Gần đây", nhóm theo tuyến.
class StationPickerSheet extends StatefulWidget {
  const StationPickerSheet({
    required this.title,
    required this.stations,
    this.recent = const [],
    this.disabledId,
    this.scrollController,
    super.key,
  });

  final String title;
  final List<StationOption> stations;
  final List<StationOption> recent;
  final String? disabledId;
  final ScrollController? scrollController;

  /// Mở sheet, trả ga được chọn hoặc `null` nếu đóng.
  static Future<StationOption?> show(
    BuildContext context, {
    required String title,
    required List<StationOption> stations,
    List<StationOption> recent = const [],
    String? disabledId,
  }) {
    return showModalBottomSheet<StationOption>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: .85,
        maxChildSize: .95,
        builder: (_, controller) => StationPickerSheet(
          title: title,
          stations: stations,
          recent: recent,
          disabledId: disabledId,
          scrollController: controller,
        ),
      ),
    );
  }

  @override
  State<StationPickerSheet> createState() => _StationPickerSheetState();
}

class _StationPickerSheetState extends State<StationPickerSheet> {
  String _query = '';

  void _select(StationOption s) => Navigator.of(context).maybePop(s);

  @override
  Widget build(BuildContext context) {
    final groups = groupStations(widget.stations, _query);
    final showRecent = _query.isEmpty && widget.recent.isNotEmpty;
    return ListView(
      controller: widget.scrollController,
      padding: const EdgeInsets.only(bottom: MetroSpacing.lg),
      children: [
        Padding(
          padding: MetroSpacing.screenPadding,
          child: Text(widget.title, style: context.text.titleLarge),
        ),
        MetroSpacing.gapSm,
        StationSearchField(onChanged: (q) => setState(() => _query = q)),
        if (showRecent) ...[
          MetroSpacing.gapMd,
          RecentStations(stations: widget.recent, onSelected: _select),
        ],
        if (groups.isEmpty)
          EmptyState(
            icon: LucideIcons.mapPinOff,
            title: context.l10n.errStationNotFound,
            message: context.l10n.stationSearchEmptyHint,
          )
        else
          StationGroupList(
            groups: groups,
            disabledId: widget.disabledId,
            onSelected: _select,
          ),
      ],
    );
  }
}
