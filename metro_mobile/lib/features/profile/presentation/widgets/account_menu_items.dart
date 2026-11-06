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
      ],
      _ => [
        (
          icon: LucideIcons.idCard,
          label: l.menuProfile,
          code: 'P51',
          route: Routes.pProfile,
        ),
        (
          icon: LucideIcons.history,
          label: l.bookingHistory,
          code: 'P43',
          route: Routes.bookingHistory,
        ),
        (
          icon: LucideIcons.receipt,
          label: l.menuTransactions,
          code: 'P52',
          route: Routes.pTransactions,
        ),
        (
          icon: LucideIcons.graduationCap,
          label: l.studentVerifyTitle,
          code: 'P56',
          route: Routes.pStudentVerify,
        ),
        (
          icon: LucideIcons.leaf,
          label: l.greenTitle,
          code: 'P53',
          route: Routes.pGreen,
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
