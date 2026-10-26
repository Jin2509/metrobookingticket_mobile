import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/organisms/scan/scan_frame_overlay.dart';
import 'package:metro_mobile/design_system/organisms/scan/torch_button.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Khung quét: preview camera sau + khung + đèn flash (S10, S21).
/// [preview] do feature cung cấp (`QrScanner.preview()`).
class ScanView extends StatelessWidget {
  const ScanView({
    required this.preview,
    required this.onTorch,
    this.hint,
    this.busy = false,
    super.key,
  });

  final Widget preview;
  final VoidCallback onTorch;

  /// Mặc định "Đưa mã QR vào khung".
  final String? hint;

  /// Đang gửi kết quả quét lên server.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: MetroRadius.brXl,
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: Colors.black, child: preview),
            CustomPaint(
              painter: ScanFrameOverlay(color: context.metro.sidebarPrimary),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: MetroSpacing.md,
              child: Text(
                busy ? context.l10n.checking : hint ?? context.l10n.scanHint,
                textAlign: TextAlign.center,
                style: context.text.bodyMedium?.copyWith(color: Colors.white),
              ),
            ),
            Positioned(
              right: MetroSpacing.sm,
              top: MetroSpacing.sm,
              child: TorchButton(onToggle: onTorch),
            ),
            if (busy)
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
