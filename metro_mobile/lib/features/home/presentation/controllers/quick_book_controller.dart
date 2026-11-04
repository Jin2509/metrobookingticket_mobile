import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ga đang chọn ở Trang chủ, giữ khi đổi tab. Dùng cho tàu sắp đến, quanh ga
/// và điền sẵn ga đi khi mua vé.
@immutable
class QuickBookState {
  const QuickBookState({this.fromId = 'BT'});

  final String? fromId;
}

final quickBookProvider = NotifierProvider<QuickBookController, QuickBookState>(
  QuickBookController.new,
);

class QuickBookController extends Notifier<QuickBookState> {
  @override
  QuickBookState build() => const QuickBookState();

  void setFrom(String id) => state = QuickBookState(fromId: id);
}
