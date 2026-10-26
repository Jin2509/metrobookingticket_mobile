import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Từ chối quyền camera: hướng dẫn bật lại + dùng nhập mã thủ công.
class CameraDeniedView extends StatelessWidget {
  const CameraDeniedView({
    required this.permanently,
    required this.onRetry,
    required this.onOpenSettings,
    super.key,
  });

  final bool permanently;
  final VoidCallback onRetry;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return MetroCard(
      child: EmptyState(
        icon: LucideIcons.cameraOff,
        title: l.cameraDeniedTitle,
        message: permanently ? l.cameraDeniedForever : l.cameraRationale,
        actionLabel: permanently ? l.openSettings : l.grantCamera,
        onAction: permanently ? onOpenSettings : onRetry,
      ),
    );
  }
}
