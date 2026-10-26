import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Khung QR toàn màn hình (P41/P42): `✕   Mã: VE-…`, QR lớn, thông tin.
/// Bọc `ScreenGuard`: độ sáng 100% + chống chụp màn hình.
class PassQrLayout extends StatelessWidget {
  const PassQrLayout({
    required this.code,
    required this.qr,
    required this.info,
    super.key,
  });

  final String code;
  final Widget qr;
  final Widget info;

  @override
  Widget build(BuildContext context) {
    return ScreenGuard(
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(MetroSpacing.md),
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: context.l10n.close,
                    icon: const Icon(LucideIcons.x),
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go(Routes.pTickets),
                  ),
                  const Spacer(),
                  Text(
                    context.l10n.codeLabel(code),
                    style: context.text.labelMedium,
                  ),
                ],
              ),
              MetroSpacing.gapLg,
              Center(child: qr),
              MetroSpacing.gapLg,
              info,
            ],
          ),
        ),
      ),
    );
  }
}
