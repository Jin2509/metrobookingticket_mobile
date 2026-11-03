import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/green/domain/green_impact.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_format.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Nội dung ảnh thành tích. Tháng này chưa đi chuyến nào thì dùng số tổng.
class GreenShareCard extends StatelessWidget {
  const GreenShareCard({required this.summary, super.key});

  final GreenSummary summary;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final m = context.metro;
    final month = summary.monthTrips > 0;
    final kg = month ? summary.monthSavedKg : summary.savedKg;
    final trips = month ? summary.monthTrips : summary.trips;
    final km = month ? summary.monthKm : summary.km;
    const white = MetroColors.primaryForeground;
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [m.sidebar, const Color(0xFF0A5A4A)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(MetroSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MetroMascot(size: 88, mood: MascotMood.happy),
              const Spacer(),
              Text(
                month ? l.greenShareMonth : l.greenShareTotal,
                style: MetroTypography.titleSmall.copyWith(color: white),
              ),
              Text(
                '${greenNumber(kg)} kg CO₂',
                style: MetroTypography.display.copyWith(
                  color: const Color(0xFF7CF0B5),
                  fontSize: 38,
                ),
              ),
              Text(
                l.greenShareBy,
                style: MetroTypography.body.copyWith(color: white),
              ),
              MetroSpacing.gapSm,
              Text(
                l.greenShareStats(
                  trips,
                  greenNumber(km),
                  greenNumber(treeDays(kg)),
                ),
                style: MetroTypography.label.copyWith(
                  color: m.sidebarForeground,
                ),
              ),
              const Spacer(),
              Text(
                'METRO TP.HCM',
                style: MetroTypography.titleSmall.copyWith(
                  color: white,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                l.greenShareEstimate,
                style: MetroTypography.label.copyWith(
                  color: m.sidebarForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
