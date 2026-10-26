import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/core/qr/qr_image.dart';
import 'package:metro_mobile/design_system/atoms/metro_button.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// QR thanh toán. Hết 10 phút thì vô hiệu QR và hiện "Tạo mã mới".
class PaymentQrCode extends StatelessWidget {
  const PaymentQrCode({
    required this.data,
    required this.expired,
    this.onRenew,
    super.key,
  });

  final String data;
  final bool expired;
  final VoidCallback? onRenew;

  @override
  Widget build(BuildContext context) {
    const qrSize = 220.0;
    return Container(
      padding: const EdgeInsets.all(MetroSpacing.md),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: MetroRadius.brXl,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (expired)
            Opacity(
              opacity: .2,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: QrImage(data: data, size: qrSize),
              ),
            )
          else
            QrImage(data: data, size: qrSize),
          if (expired)
            MetroButton(
              label: context.l10n.newCode,
              icon: LucideIcons.refreshCw,
              onPressed: onRenew,
            ),
        ],
      ),
    );
  }
}
