import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/parking_control/presentation/controllers/parking_control_controller.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `Đang gửi tại bãi` + tìm biển số.
class ParkedVehicleList extends ConsumerStatefulWidget {
  const ParkedVehicleList({super.key});

  @override
  ConsumerState<ParkedVehicleList> createState() => _ParkedState();
}

class _ParkedState extends ConsumerState<ParkedVehicleList> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final list = ref.watch(parkedVehiclesProvider(_query)).value ?? const [];
    return SectionCard(
      title: context.l10n.parkedAtLot,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MetroTextField(
            hint: context.l10n.searchPlate,
            prefixIcon: LucideIcons.search,
            onChanged: (v) => setState(() => _query = v),
          ),
          MetroSpacing.gapXs,
          if (list.isEmpty)
            Text(context.l10n.noVehicles, style: context.text.bodySmall),
          for (final v in list)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(v.plate, style: context.text.bodyLarge),
              subtitle: Text(vehicleCodeLabel(context.l10n, v.vehicle)),
              trailing: Text(
                v.since == null
                    ? ''
                    : context.l10n.parkedSince(timeOnly(v.since!)),
                style: context.text.labelSmall,
              ),
            ),
        ],
      ),
    );
  }
}
