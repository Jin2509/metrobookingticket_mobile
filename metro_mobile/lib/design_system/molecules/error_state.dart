import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/atoms/metro_button.dart';
import 'package:metro_mobile/design_system/molecules/empty_state.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Trạng thái lỗi + "Thử lại" (nhánh A-x của use case).
class ErrorState extends StatelessWidget {
  const ErrorState({
    required this.message,
    this.title,
    this.onRetry,
    super.key,
  });

  /// Mặc định "Đã có lỗi xảy ra".
  final String? title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return EmptyState(
      icon: LucideIcons.cloudOff,
      title: title ?? l.errorTitle,
      message: localizeMessage(l, message),
      actionLabel: onRetry == null ? null : l.retry,
      onAction: onRetry,
      actionVariant: MetroButtonVariant.outline,
    );
  }
}
