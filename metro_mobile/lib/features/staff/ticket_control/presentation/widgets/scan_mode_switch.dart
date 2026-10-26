import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/entities/scan_entities.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `[ VÀO GA ][ RA GA ]` (UC12-01 / UC12-02).
class ScanModeSwitch extends StatelessWidget {
  const ScanModeSwitch({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final ScanMode value;
  final ValueChanged<ScanMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ScanMode>(
      showSelectedIcon: false,
      segments: [
        ButtonSegment(
          value: ScanMode.entry,
          icon: const Icon(LucideIcons.logIn),
          label: Text(context.l10n.scanEntry.toUpperCase()),
        ),
        ButtonSegment(
          value: ScanMode.exit,
          icon: const Icon(LucideIcons.logOut),
          label: Text(context.l10n.scanExit.toUpperCase()),
        ),
      ],
      selected: {value},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}
