import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/green/domain/green_impact.dart';
import 'package:metro_mobile/features/green/presentation/controllers/green_controller.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_earth.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_format.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Thẻ "Hành trình xanh" nổi bật ở Trang chủ: Trái Đất, Futu, CO2, CPoint.
class GreenImpactCard extends ConsumerWidget {
  const GreenImpactCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s =
        ref.watch(greenSummaryProvider).value ??
        const GreenSummary(trips: 0, km: 0);
    return Semantics(
      button: true,
      child: ClipRRect(
        borderRadius: MetroRadius.brXl,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: greenSceneGradient(context, begin: Alignment.topLeft),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () => context.push(Routes.pGreen),
              child: Padding(
                padding: const EdgeInsets.all(MetroSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  l.greenTitle,
                                  style: context.text.titleSmall?.copyWith(
                                    color: MetroColors.primaryForeground,
                                  ),
                                ),
                              ),
                              const Icon(
                                LucideIcons.chevronRight,
                                size: 16,
                                color: MetroColors.primaryForeground,
                              ),
                            ],
                          ),
                          MetroSpacing.gapXxs,
                          Text(
                            s.trips == 0
                                ? l.greenEmpty
                                : l.greenSavedKg(greenNumber(s.savedKg)),
                            style: context.text.titleLarge?.copyWith(
                              color: greenMint,
                            ),
                          ),
                          if (s.trips > 0)
                            Text(
                              greenCpointLine(l, s),
                              style: context.text.labelMedium?.copyWith(
                                color: MetroColors.primaryForeground,
                              ),
                            ),
                          MetroSpacing.gapXxs,
                          Text(
                            greenFutuLine(l, s),
                            style: context.text.bodySmall?.copyWith(
                              color: context.metro.sidebarForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    MetroSpacing.gapXs,
                    SizedBox.square(
                      dimension: 112,
                      child: Stack(
                        children: [
                          GreenEarth(size: 112, health: greenHealth(s.savedKg)),
                          const Positioned(
                            left: 0,
                            bottom: 0,
                            child: IgnorePointer(
                              child: ExcludeSemantics(
                                child: MetroMascot(
                                  size: 48,
                                  mood: MascotMood.happy,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
