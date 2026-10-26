import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/gen/app_localizations.dart';

/// Màn tạm cho tab/màn chưa làm, ghi rõ giai đoạn sẽ hiện thực.
class PlaceholderTab extends StatelessWidget {
  const PlaceholderTab({
    required this.title,
    required this.icon,
    required this.phase,
    this.code,
    super.key,
  });

  final String title;
  final IconData icon;
  final int phase;

  /// Mã màn trong tài liệu, VD `P10`.
  final String? code;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: EmptyState(
          icon: icon,
          title: l.placeholderTitle,
          message:
              '${code == null ? '' : '$code · '}${l.placeholderBody(phase)}',
        ),
      ),
    );
  }
}
