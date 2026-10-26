import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/wallet/domain/entities/paged.dart';

@immutable
class PagedState<T> {
  const PagedState({
    required this.items,
    required this.page,
    required this.hasMore,
    this.loadingMore = false,
    this.moreError,
  });

  final List<T> items;
  final int page;
  final bool hasMore;
  final bool loadingMore;

  /// Lỗi khi tải thêm (trang đầu lỗi thì do `AsyncValue` xử lý).
  final String? moreError;
}

/// Danh sách tải dần (infinite scroll). Trang đầu là `AsyncValue` để có
/// đủ skeleton / lỗi / dữ liệu; các trang sau nối vào cuối.
abstract class PagedController<T> extends AsyncNotifier<PagedState<T>> {
  Future<Paged<T>> fetch(int page);

  @override
  Future<PagedState<T>> build() async {
    final first = await fetch(0);
    return PagedState(items: first.items, page: 0, hasMore: first.hasMore);
  }

  Future<void> loadMore() async {
    final cur = state.value;
    if (cur == null || !cur.hasMore || cur.loadingMore) return;
    state = AsyncData(_copy(cur, loadingMore: true));
    try {
      final next = await fetch(cur.page + 1);
      if (!ref.mounted) return;
      state = AsyncData(
        PagedState(
          items: [...cur.items, ...next.items],
          page: next.page,
          hasMore: next.hasMore,
        ),
      );
    } on Failure catch (f) {
      if (ref.mounted) state = AsyncData(_copy(cur, moreError: f.message));
    }
  }

  /// Kéo để làm mới.
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  PagedState<T> _copy(
    PagedState<T> s, {
    bool loadingMore = false,
    String? moreError,
  }) => PagedState(
    items: s.items,
    page: s.page,
    hasMore: s.hasMore,
    loadingMore: loadingMore,
    moreError: moreError,
  );
}
