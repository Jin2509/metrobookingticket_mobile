import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';
import 'package:metro_mobile/features/network/presentation/mappers/place_groups.dart';
import 'package:metro_mobile/features/network/presentation/widgets/places/nearby_place_tile.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Quanh ga (UC6): lọc theo nhóm (Xe buýt, Y tế, Chợ & mua sắm...),
/// gần nhất trước. Chỉ hiện nhóm có dữ liệu.
class NearbyPlacesView extends StatefulWidget {
  const NearbyPlacesView({required this.detail, super.key});

  final StationDetail detail;

  @override
  State<NearbyPlacesView> createState() => _NearbyPlacesViewState();
}

class _NearbyPlacesViewState extends State<NearbyPlacesView> {
  PlaceGroup? _group;

  @override
  void didUpdateWidget(NearbyPlacesView old) {
    super.didUpdateWidget(old);
    if (old.detail.station.id != widget.detail.station.id) _group = null;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final places = NearbyPlace.of(widget.detail);
    if (places.isEmpty) {
      return EmptyState(icon: LucideIcons.mapPinned, title: l.noAmenities);
    }
    final groups = [
      for (final g in PlaceGroup.values)
        if (places.any((p) => p.group == g)) g,
    ];
    final shown = _group == null
        ? places
        : places.where((p) => p.group == _group).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _chip(l.all, null),
              for (final g in groups) _chip(placeGroupLabel(l, g), g),
            ],
          ),
        ),
        MetroSpacing.gapXs,
        for (final p in shown) NearbyPlaceTile(place: p),
      ],
    );
  }

  Widget _chip(String label, PlaceGroup? g) => Padding(
    padding: const EdgeInsets.only(right: MetroSpacing.xs),
    child: ChoiceChip(
      label: Text(label),
      showCheckmark: false,
      selected: _group == g,
      onSelected: (_) => setState(() => _group = g),
    ),
  );
}
