import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/green/domain/green_impact.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_earth.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_format.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_futu_guide.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_stars_painter.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_tier_path.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Cảnh đầu màn Hành trình xanh: bầu trời sao, Trái Đất, số CO2, Futu và chặng
/// tiến hóa. Nền nối liền với AppBar.
class GreenHero extends StatelessWidget {
  const GreenHero({required this.summary, super.key});

  final GreenSummary summary;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final hasTrips = summary.trips > 0;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: greenSceneGradient(context, begin: Alignment.topCenter),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(MetroRadius.xxl),
        ),
      ),
      child: CustomPaint(
        painter: GreenStarsPainter(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            MetroSpacing.md,
            0,
            MetroSpacing.md,
            MetroSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: _SpinningEarth(health: greenHealth(summary.savedKg)),
              ),
              Text(
                hasTrips
                    ? l.greenSavedKg(greenNumber(summary.savedKg))
                    : l.greenEmpty,
                textAlign: TextAlign.center,
                style: context.text.headlineSmall?.copyWith(color: greenMint),
              ),
              if (hasTrips)
                Text(
                  l.greenCompared,
                  textAlign: TextAlign.center,
                  style: context.text.bodySmall?.copyWith(
                    color: context.metro.sidebarForeground,
                  ),
                ),
              if (hasTrips)
                Text(
                  greenCpointLine(l, summary),
                  textAlign: TextAlign.center,
                  style: context.text.titleSmall?.copyWith(
                    color: MetroColors.primaryForeground,
                  ),
                ),
              MetroSpacing.gapMd,
              GreenFutuGuide(summary: summary),
              MetroSpacing.gapMd,
              GreenTierPath(kg: summary.savedKg),
            ],
          ),
        ),
      ),
    );
  }
}

/// Xoay một vòng khi mở màn rồi dừng để tiết kiệm pin, kéo ngang để xoay tiếp.
class _SpinningEarth extends StatefulWidget {
  const _SpinningEarth({required this.health});

  final double health;

  @override
  State<_SpinningEarth> createState() => _SpinningEarthState();
}

class _SpinningEarthState extends State<_SpinningEarth>
    with SingleTickerProviderStateMixin {
  late final _spin = AnimationController.unbounded(
    vsync: this,
    value: earthFacingVietnam,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || MediaQuery.disableAnimationsOf(context)) return;
      _spin.value = earthFacingVietnam - 360;
      await _spin.animateTo(
        earthFacingVietnam,
        duration: const Duration(seconds: 3),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: context.l10n.greenEarthLabel,
      child: GestureDetector(
        onHorizontalDragStart: (_) => _spin.stop(),
        onHorizontalDragUpdate: (d) => _spin.value += d.delta.dx * .6,
        child: GreenEarth(size: 200, health: widget.health, rotation: _spin),
      ),
    );
  }
}
