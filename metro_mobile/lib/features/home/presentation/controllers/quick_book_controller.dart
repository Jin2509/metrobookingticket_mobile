import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/features/network/domain/entities/route_plan.dart';
import 'package:metro_mobile/features/network/network_providers.dart';

/// Lựa chọn ở thẻ "Đặt vé nhanh", giữ khi đổi tab.
@immutable
class QuickBookState {
  const QuickBookState({
    this.fromId = 'BT',
    this.toId = 'TD',
    this.typeCode = 'SINGLE',
  });

  final String? fromId;
  final String? toId;
  final String typeCode;
}

final quickBookProvider = NotifierProvider<QuickBookController, QuickBookState>(
  QuickBookController.new,
);

class QuickBookController extends Notifier<QuickBookState> {
  @override
  QuickBookState build() => const QuickBookState();

  void setFrom(String id) => state = QuickBookState(
    fromId: id,
    toId: state.toId,
    typeCode: state.typeCode,
  );

  void setTo(String id) => state = QuickBookState(
    fromId: state.fromId,
    toId: id,
    typeCode: state.typeCode,
  );

  void swap() => state = QuickBookState(
    fromId: state.toId,
    toId: state.fromId,
    typeCode: state.typeCode,
  );

  void setType(String code) => state = QuickBookState(
    fromId: state.fromId,
    toId: state.toId,
    typeCode: code,
  );
}

/// Giá + thời gian + số ga cho `RouteSummaryBar`. Lỗi (trùng ga…) → null.
final quickRouteProvider = FutureProvider.autoDispose
    .family<RoutePlan?, (String?, String?)>((ref, ids) async {
      final (from, to) = ids;
      try {
        return await ref.watch(searchRouteProvider).call(from, to);
      } on Object {
        return null;
      }
    });
