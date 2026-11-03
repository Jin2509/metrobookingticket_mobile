import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:metro_mobile/features/green/domain/green_impact.dart';
import 'package:metro_mobile/features/green/presentation/controllers/green_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cấp vừa đạt được và chưa chúc mừng. Mỗi lần lên cấp chỉ báo một lần, lưu theo
/// từng tài khoản. Lần đầu thấy tài khoản chỉ ghi nhận, không chúc mừng nhầm.
final greenTierUpProvider = NotifierProvider<GreenTierWatcher, GreenTier?>(
  GreenTierWatcher.new,
);

class GreenTierWatcher extends Notifier<GreenTier?> {
  @override
  GreenTier? build() {
    ref.listen(greenSummaryProvider, (_, next) {
      final summary = next.value;
      final userId = ref.read(authControllerProvider).value?.id;
      if (summary != null && userId != null) {
        unawaited(_check(userId, summary.tier));
      }
    }, fireImmediately: true);
    return null;
  }

  Future<void> _check(String userId, GreenTier tier) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'green_tier_seen_$userId';
    final seen = prefs.getInt(key);
    if (seen == tier.index) return;
    await prefs.setInt(key, tier.index);
    if (seen != null && tier.index > seen && ref.mounted) state = tier;
  }

  void dismiss() => state = null;
}
