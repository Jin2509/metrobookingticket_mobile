import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/green/domain/green_impact.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_format.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/mappers/network_view_mappers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Chọn hai ga để so sánh CO2 của cùng quãng đường theo ba phương tiện.
class GreenCalculatorCard extends ConsumerStatefulWidget {
  const GreenCalculatorCard({super.key});

  @override
  ConsumerState<GreenCalculatorCard> createState() => _State();
}

class _State extends ConsumerState<GreenCalculatorCard> {
  String _from = 'BT';
  String _to = 'TD';

  Future<void> _pick({required bool from}) async {
    final catalog = await ref.read(catalogProvider.future);
    if (!mounted) return;
    final picked = await StationPickerSheet.show(
      context,
      title: from ? context.l10n.chooseFrom : context.l10n.chooseTo,
      stations: catalog.options,
      disabledId: from ? _to : _from,
    );
    if (picked == null) return;
    setState(() => from ? _from = picked.id : _to = picked.id);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final m = context.metro;
    final catalog = ref.watch(catalogProvider).value;
    final plan = ref.watch(routePlanProvider((_from, _to))).value;
    final km = plan == null || catalog == null ? null : routeKm(plan, catalog);
    return SectionCard(
      title: l.greenCalculatorTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StationField(
            label: l.fromShort,
            value: catalog?.station(_from)?.name,
            dotColor: context.colors.primary,
            onTap: () => _pick(from: true),
          ),
          MetroSpacing.gapXs,
          StationField(
            label: l.to,
            value: catalog?.station(_to)?.name,
            dotColor: m.accent,
            onTap: () => _pick(from: false),
          ),
          MetroSpacing.gapMd,
          if (km == null)
            Text(l.greenNoRoute, style: context.text.bodySmall)
          else ...[
            Text(
              l.greenDistance(greenNumber(km)),
              style: context.text.labelMedium,
            ),
            MetroSpacing.gapSm,
            _Bar(
              l.greenModeCar,
              km * GreenFactors.carKgPerKm,
              km,
              m.mutedForeground,
            ),
            _Bar(
              l.greenModeMotorbike,
              km * GreenFactors.motorbikeKgPerKm,
              km,
              m.accent,
            ),
            _Bar(
              l.greenModeMetro,
              km * GreenFactors.metroKgPerKm,
              km,
              m.success,
            ),
            MetroSpacing.gapSm,
            Text(
              l.greenTripSaved(greenNumber(TravelMode.motorbike.savedKg(km))),
              style: context.text.labelLarge?.copyWith(color: m.success),
            ),
            MetroSpacing.gapXxs,
            Text(
              l.greenTrain(motorbikesPerTrain),
              style: context.text.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar(this.label, this.kg, this.km, this.color);

  final String label;
  final double kg;
  final double km;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: MetroSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: context.text.labelMedium)),
              Text(
                context.l10n.greenKg(greenNumber(kg)),
                style: context.text.labelMedium,
              ),
            ],
          ),
          MetroSpacing.gapXxs,
          ClipRRect(
            borderRadius: MetroRadius.brPill,
            child: LinearProgressIndicator(
              value: km == 0 ? 0 : kg / (km * GreenFactors.carKgPerKm),
              minHeight: 10,
              color: color,
              backgroundColor: context.metro.muted,
            ),
          ),
        ],
      ),
    );
  }
}
