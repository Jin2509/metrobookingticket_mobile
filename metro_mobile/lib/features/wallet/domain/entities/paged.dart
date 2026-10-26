import 'package:flutter/foundation.dart';

/// Một trang dữ liệu (phân trang 20 dòng/trang, mục 10.2).
@immutable
class Paged<T> {
  const Paged({required this.items, required this.page, required this.hasMore});

  final List<T> items;
  final int page;
  final bool hasMore;
}
