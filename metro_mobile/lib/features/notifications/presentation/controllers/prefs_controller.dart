import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/notifications/domain/entities/notification_entities.dart';
import 'package:metro_mobile/features/notifications/notification_providers.dart';

final newsProvider = FutureProvider.autoDispose<List<NewsItem>>(
  (ref) => ref.watch(getNewsProvider).call(),
);

/// Một tin theo id (lấy từ danh sách), `null` nếu không còn.
final newsItemProvider = FutureProvider.autoDispose.family<NewsItem?, String>(
  (ref, id) async =>
      (await ref.watch(newsProvider.future))
          .where((n) => n.id == id)
          .firstOrNull,
);

final prefsProvider =
    AsyncNotifierProvider.autoDispose<PrefsController, NotificationPrefs>(
      PrefsController.new,
    );

/// P54. Đổi ngay trên UI, lỗi thì trả về giá trị cũ và báo lỗi.
class PrefsController extends AsyncNotifier<NotificationPrefs> {
  @override
  Future<NotificationPrefs> build() => ref.read(updatePrefsProvider).load();

  /// Trả thông điệp lỗi hoặc `null` khi lưu được.
  Future<String?> save(NotificationPrefs next) async {
    final previous = state.value;
    state = AsyncData(next);
    try {
      state = AsyncData(await ref.read(updatePrefsProvider).call(next));
      return null;
    } on Failure catch (f) {
      if (previous != null && ref.mounted) state = AsyncData(previous);
      return f.message;
    }
  }
}
