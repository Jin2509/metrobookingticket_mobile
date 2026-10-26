import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/domain/entities/role.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';
import 'package:metro_mobile/l10n/gen/app_localizations.dart';

/// Ảnh đại diện chữ cái, tên, email, vai trò / ga phụ trách.
class AccountHeader extends StatelessWidget {
  const AccountHeader({required this.user, super.key});

  final SessionUser user;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final initial = user.name.isEmpty ? '?' : user.name.characters.first;
    final l = AppLocalizations.of(context);
    final roleLabel = user.role == Role.staffStation
        ? l.roleStaff
        : l.rolePassenger;
    return MetroCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: context.colors.primary,
            foregroundColor: context.colors.onPrimary,
            child: Text(
              initial.toUpperCase(),
              style: context.text.titleLarge?.copyWith(
                color: context.colors.onPrimary,
              ),
            ),
          ),
          MetroSpacing.gapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: context.text.titleMedium),
                Text(user.email, style: context.text.bodySmall),
                MetroSpacing.gapXxs,
                Row(
                  children: [
                    Icon(
                      user.stationName == null
                          ? LucideIcons.user
                          : LucideIcons.mapPin,
                      size: 14,
                      color: m.mutedForeground,
                    ),
                    MetroSpacing.gapXxs,
                    Text(
                      user.stationName ?? roleLabel,
                      style: context.text.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
