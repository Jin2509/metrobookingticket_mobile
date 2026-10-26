import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:metro_mobile/core/qr/qr_image.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// QR vé / gửi xe trên nền trắng. Vé hết hạn hoặc đã dùng thì QR bị làm
/// mờ kèm nhãn (UC8-03 A1), không quét được.
class QrPassView extends StatelessWidget {
  const QrPassView({
    required this.data,
    this.active = true,
    this.inactiveLabel,
    this.size = 240,
    super.key,
  });

  /// Chuỗi đã mã hóa qua `QrCodec`, chỉ chứa token.
  final String data;
  final bool active;

  /// Mặc định "Vé không còn hiệu lực".
  final String? inactiveLabel;
  final double size;

  @override
  Widget build(BuildContext context) {
    final qr = QrImage(data: data, size: size);
    final inactive = inactiveLabel ?? context.l10n.ticketInactive;
    return Semantics(
      image: true,
      label: active ? context.l10n.qrCode : inactive,
      child: Container(
        padding: const EdgeInsets.all(MetroSpacing.md),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: MetroRadius.brXl,
        ),
        child: active
            ? qr
            : Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: .35,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      child: qr,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: MetroSpacing.sm,
                      vertical: MetroSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: context.metro.muted,
                      borderRadius: MetroRadius.brPill,
                    ),
                    child: Text(
                      inactive,
                      style: context.text.labelMedium?.copyWith(
                        color: context.metro.mutedForeground,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
