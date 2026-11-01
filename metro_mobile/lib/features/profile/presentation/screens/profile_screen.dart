import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/profile/presentation/widgets/change_password_form.dart';
import 'package:metro_mobile/features/profile/presentation/widgets/profile_form.dart';
import 'package:metro_mobile/features/profile/presentation/widgets/two_factor_card.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P51 / S40. Đổi họ tên, email và mật khẩu.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({required this.profilePath, super.key});

  /// Path màn này trong shell hiện tại, để mở màn xác nhận email mới.
  final String profilePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.menuProfile)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          MetroSpacing.md,
          MetroSpacing.md,
          MetroSpacing.md,
          MetroSpacing.fabClearance,
        ),
        children: [
          MetroCard(child: ProfileForm(profilePath: profilePath)),
          MetroSpacing.gapMd,
          const MetroCard(child: ChangePasswordForm()),
          MetroSpacing.gapMd,
          const MetroCard(child: TwoFactorCard()),
        ],
      ),
    );
  }
}
