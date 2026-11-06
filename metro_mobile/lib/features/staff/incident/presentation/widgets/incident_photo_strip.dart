import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/incident/domain/entities/station_incident.dart';

/// Ảnh của sự cố: ảnh còn trên máy (demo) hoặc ảnh đã tải lên.
class IncidentPhotoStrip extends StatelessWidget {
  const IncidentPhotoStrip({required this.incident, super.key});

  final StationIncident incident;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: MetroSpacing.xs,
      runSpacing: MetroSpacing.xs,
      children: [
        for (final p in incident.photoBytes)
          ClipRRect(
            borderRadius: MetroRadius.brMd,
            child: Image.memory(
              p,
              width: 104,
              height: 104,
              cacheWidth: 312,
              fit: BoxFit.cover,
            ),
          ),
        for (final u in incident.photoUrls)
          SizedBox.square(
            dimension: 104,
            child: MetroImage(src: u, aspectRatio: 1),
          ),
      ],
    );
  }
}
