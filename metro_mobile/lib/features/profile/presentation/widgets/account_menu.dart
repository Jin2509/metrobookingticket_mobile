import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/profile/presentation/widgets/account_menu_items.dart';
import 'package:metro_mobile/l10n/gen/app_localizations.dart';

/// Danh sách mục tài khoản. Các màn đích làm ở giai đoạn sau.
class AccountMenu extends StatelessWidget {
  const AccountMenu({required this.items, super.key});

  final List<AccountMenuItem> items;

  void _soon(BuildContext context, AccountMenuItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).comingSoon(item.label)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return MetroCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (final item in items)
            ListTile(
              leading: Icon(item.icon, color: context.colors.primary),
              title: Text(item.label, style: context.text.bodyLarge),
              trailing: Icon(
                LucideIcons.chevronRight,
                color: m.mutedForeground,
              ),
              onTap: () => item.route == null
                  ? _soon(context, item)
                  : context.push(item.route!),
            ),
        ],
      ),
    );
  }
}
