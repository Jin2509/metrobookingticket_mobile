import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/booking/presentation/controllers/booking_controllers.dart';
import 'package:metro_mobile/features/home/presentation/controllers/quick_book_controller.dart';

/// `(Vé lượt)(Vé ngày)(Vé tháng)` – lấy từ bảng loại vé.
class TicketTypeChips extends ConsumerWidget {
  const TicketTypeChips({super.key});

  static const quickCodes = ['SINGLE', 'DAY', 'MONTH'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final types = ref.watch(fareTableProvider).value?.types ?? const [];
    final selected = ref.watch(quickBookProvider).typeCode;
    return Wrap(
      spacing: MetroSpacing.xs,
      children: [
        for (final t in types.where((t) => quickCodes.contains(t.code)))
          ChoiceChip(
            label: Text(t.name),
            showCheckmark: false,
            selected: t.code == selected,
            onSelected: (_) =>
                ref.read(quickBookProvider.notifier).setType(t.code),
          ),
      ],
    );
  }
}
