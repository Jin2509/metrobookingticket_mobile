import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:metro_mobile/design_system/models/map_models.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Chấm vị trí hiện tại (hoặc điểm người dùng chọn trên bản đồ).
class UserLocationLayer extends StatelessWidget {
  const UserLocationLayer({required this.point, super.key});

  final LatLng point;

  @override
  Widget build(BuildContext context) {
    final c = context.colors.primary;
    return MarkerLayer(
      markers: [
        Marker(
          point: point,
          width: 28,
          height: 28,
          child: Semantics(
            label: context.l10n.yourLocation,
            child: Container(
              decoration: BoxDecoration(
                color: c.withValues(alpha: .2),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.metro.card, width: 2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
