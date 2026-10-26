import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/notifications/domain/entities/notification_entities.dart';
import 'package:metro_mobile/features/notifications/presentation/controllers/prefs_controller.dart';
import 'package:metro_mobile/features/notifications/presentation/widgets/pref_switch_tile.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P54. Cài đặt thông báo (UC13-03).
class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  Future<void> _save(
    BuildContext context,
    WidgetRef ref,
    NotificationPrefs next,
  ) async {
    final error = await ref.read(prefsProvider.notifier).save(next);
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.menuNotificationSettings)),
      body: AsyncValueView(
        value: ref.watch(prefsProvider),
        onRetry: () => ref.invalidate(prefsProvider),
        data: (p) => ListView(
          padding: const EdgeInsets.all(MetroSpacing.md),
          children: [
            PrefSwitchTile(
              title: l.prefPush,
              value: p.push,
              onChanged: (v) => _save(context, ref, p.copyWith(push: v)),
            ),
            PrefSwitchTile(
              title: 'Email',
              value: p.email,
              onChanged: (v) => _save(context, ref, p.copyWith(email: v)),
            ),
            PrefSwitchTile(
              title: l.prefPromotion,
              value: p.promotion,
              onChanged: (v) => _save(context, ref, p.copyWith(promotion: v)),
            ),
            PrefSwitchTile(
              title: l.prefSmart,
              subtitle: l.prefSmartBody,
              value: p.smart,
              onChanged: (v) => _save(context, ref, p.copyWith(smart: v)),
            ),
            const Divider(height: MetroSpacing.lg),
            PrefSwitchTile(
              title: l.prefOperation,
              subtitle: l.prefOperationBody,
              value: p.operation,
              locked: true,
              onChanged: (_) {},
            ),
            PrefSwitchTile(
              title: l.prefPayment,
              subtitle: l.prefPaymentBody,
              value: p.payment,
              locked: true,
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}
