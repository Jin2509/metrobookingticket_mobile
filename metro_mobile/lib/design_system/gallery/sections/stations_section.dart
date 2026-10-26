import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/atoms/metro_button.dart';
import 'package:metro_mobile/design_system/gallery/gallery_sample_data.dart';
import 'package:metro_mobile/design_system/gallery/sections/gallery_section.dart';
import 'package:metro_mobile/design_system/molecules/metro_card.dart';
import 'package:metro_mobile/design_system/molecules/station_picker/station_picker_sheet.dart';
import 'package:metro_mobile/design_system/molecules/station_tile.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

class StationsSection extends StatelessWidget {
  const StationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GallerySection(
      title: 'StationTile · StationPickerSheet',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MetroCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                StationTile(
                  station: GallerySample.benThanh,
                  trailing: '2 phút',
                  onTap: () {},
                ),
                StationTile(
                  station: GallerySample.baSon,
                  trailing: '350 m',
                  onTap: () {},
                ),
                const StationTile(station: GallerySample.taoDan),
              ],
            ),
          ),
          MetroSpacing.gapSm,
          MetroButton(
            label: 'Mở StationPickerSheet',
            icon: LucideIcons.mapPin,
            variant: MetroButtonVariant.outline,
            expand: true,
            onPressed: () => StationPickerSheet.show(
              context,
              title: 'Chọn ga đi',
              stations: GallerySample.stations,
              recent: const [GallerySample.thuDuc, GallerySample.benThanh],
            ),
          ),
        ],
      ),
    );
  }
}
