import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// A4: biển số đang có lượt gửi còn hiệu lực → [Xem QR].
class ActivePassBanner extends StatelessWidget {
  const ActivePassBanner({required this.passId, super.key});

  final String passId;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return Container(
      padding: const EdgeInsets.all(MetroSpacing.sm),
      decoration: BoxDecoration(
        color: m.accent.withValues(alpha: .12),
        borderRadius: MetroRadius.brMd,
      ),
      child: Row(
        children: [
          Icon(LucideIcons.info, color: m.accent),
          MetroSpacing.gapXs,
          Expanded(
            child: Text(
              context.l10n.activePassBanner,
              style: context.text.bodySmall,
            ),
          ),
          TextButton(
            onPressed: () => context.push(Routes.parkingPass(passId)),
            child: Text(context.l10n.viewQr),
          ),
        ],
      ),
    );
  }
}
