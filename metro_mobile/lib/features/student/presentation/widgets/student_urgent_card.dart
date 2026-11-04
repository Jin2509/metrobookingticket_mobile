import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Nói rõ thời gian duyệt và lối đi gấp: mua vé ngày giá thường để đi ngay.
class StudentUrgentCard extends StatelessWidget {
  const StudentUrgentCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return MetroCard(
      padding: const EdgeInsets.all(MetroSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(LucideIcons.clock, size: 20, color: context.metro.accent),
              MetroSpacing.gapXs,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.studentWaitTitle, style: context.text.titleSmall),
                    Text(l.studentWaitBody, style: context.text.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          MetroSpacing.gapXs,
          MetroButton(
            label: l.studentBuyDay,
            icon: LucideIcons.ticket,
            variant: MetroButtonVariant.outline,
            expand: true,
            onPressed: () => context.push(Routes.buy(type: 'DAY')),
          ),
        ],
      ),
    );
  }
}
