import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Thanh bước dùng chung cho P29 → P30 → P32.
class BookingSteps extends StatelessWidget {
  const BookingSteps({required this.current, super.key});

  final int current;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BookingStepper(
      steps: [l.stepChoose, l.stepConfirm, l.stepPay],
      current: current,
    );
  }
}
