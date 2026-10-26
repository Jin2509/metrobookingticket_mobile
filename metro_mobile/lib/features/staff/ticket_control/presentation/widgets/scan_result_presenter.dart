import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/entities/scan_entities.dart';
import 'package:metro_mobile/features/staff/ticket_control/presentation/controllers/ticket_scan_controller.dart';
import 'package:metro_mobile/features/staff/ticket_control/presentation/mappers/scan_labels.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Nghe kết quả soát vé: hiện `ScanResultSheet` (tự đóng 2,5s), rung
/// ngắn khi hợp lệ, rung dài + âm báo khi không hợp lệ (S11).
class ScanResultPresenter extends ConsumerWidget {
  const ScanResultPresenter({required this.mode, super.key});

  final ScanMode mode;

  static (String, List<String>) describe(AppLocalizations l, ScanResult r) =>
      switch (r) {
        ScanValid() => (
          l.scanValid,
          [
            '${r.typeName}${r.route == null ? '' : ' · ${r.route}'}',
            l.validUntil(dateTime(r.validUntil)),
            l.recordedAt(timeOnly(r.at), scanModeLabel(l, r.mode)),
          ],
        ),
        ScanInvalid() => (
          l.scanInvalid,
          [
            l.rejectReason(rejectReasonLabel(l, r.reason)),
            if (r.code != null) l.ticketLabel(r.route ?? r.code!),
            if (r.currentStation != null) l.currentStation(r.currentStation!),
          ],
        ),
      };

  void _show(BuildContext context, ScanResult r) {
    final valid = r is ScanValid;
    unawaited(
      valid ? HapticFeedback.lightImpact() : HapticFeedback.heavyImpact(),
    );
    if (!valid) unawaited(SystemSound.play(SystemSoundType.alert));
    final (title, lines) = describe(context.l10n, r);
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: false,
        backgroundColor: Colors.transparent,
        builder: (ctx) => ScanResultSheet(
          valid: valid,
          title: title,
          lines: lines,
          onClose: () => Navigator.of(ctx).maybePop(),
          actions: valid
              ? const []
              : [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      ctx.l10n.scanNext,
                      style: const TextStyle(
                        color: MetroColors.primaryForeground,
                      ),
                    ),
                  ),
                ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(ticketScanProvider(mode).select((s) => s.seq), (_, _) {
      final s = ref.read(ticketScanProvider(mode));
      if (s.result != null) _show(context, s.result!);
      if (s.toast != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(localizeMessage(context.l10n, s.toast!))),
          );
      }
    });
    return const SizedBox.shrink();
  }
}
