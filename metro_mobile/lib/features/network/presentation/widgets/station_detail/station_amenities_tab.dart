import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/core/utils/geo.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';
import 'package:metro_mobile/features/network/presentation/widgets/station_detail/amenity_icons.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Tab Quanh ga: tiện ích theo khoảng cách (UC6).
class StationAmenitiesTab extends StatelessWidget {
  const StationAmenitiesTab({required this.amenities, super.key});

  final List<Amenity> amenities;

  @override
  Widget build(BuildContext context) {
    if (amenities.isEmpty) {
      return EmptyState(
        icon: LucideIcons.store,
        title: context.l10n.noAmenities,
      );
    }
    final sorted = [...amenities]
      ..sort((a, b) => a.distanceM.compareTo(b.distanceM));
    return Column(
      children: [
        for (final a in sorted)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(amenityIcons[a.kind], color: context.colors.primary),
            title: Text(a.name, style: context.text.bodyMedium),
            trailing: Text(
              formatDistance(a.distanceM.toDouble()),
              style: context.text.labelSmall,
            ),
          ),
      ],
    );
  }
}
