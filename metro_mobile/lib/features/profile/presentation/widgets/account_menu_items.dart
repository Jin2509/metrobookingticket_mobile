import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/features/auth/domain/entities/role.dart';
import 'package:metro_mobile/l10n/gen/app_localizations.dart';

/// `route` = màn đích; `null` = chưa làm (hiện thông báo).
typedef AccountMenuItem = ({
  IconData icon,
  String label,
  String code,
  String? route,
});

/// Mục trong tab Tài khoản theo vai trò (P50, S40). `code` = mã màn.
List<AccountMenuItem> accountMenuFor(Role role, AppLocalizations l) =>
    switch (role) {
      Role.staffStation => [
        (
          icon: LucideIcons.idCard,
          label: l.menuStaffProfile,
          code: 'S40',
          route: Routes.sProfile,
        ),
        (
          icon: LucideIcons.building2,
          label: l.menuStation,
          code: 'S00',
          route: null,
        ),
      ],
      _ => [
        (
          icon: LucideIcons.idCard,
          label: l.menuProfile,
          code: 'P51',
          route: Routes.pProfile,
        ),
        (
          icon: LucideIcons.receipt,
          label: l.menuTransactions,
          code: 'P52',
          route: Routes.pTransactions,
        ),
        (
          icon: LucideIcons.award,
          label: l.menuLoyalty,
          code: 'P53',
          route: Routes.pLoyalty,
        ),
        (
          icon: LucideIcons.bellRing,
          label: l.menuNotificationSettings,
          code: 'P54',
          route: Routes.pNotificationSettings,
        ),
        (
          icon: LucideIcons.newspaper,
          label: l.menuNews,
          code: 'P61',
          route: Routes.pNews,
        ),
      ],
    };
