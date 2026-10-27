import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/mappers/network_view_mappers.dart';
import 'package:metro_mobile/features/network/presentation/widgets/places/nearby_places_view.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P27. Tiện ích quanh ga: chọn ga, lọc bệnh viện, chợ, xe buýt...
class NearbyPlacesScreen extends ConsumerStatefulWidget {
  const NearbyPlacesScreen({this.stationId, super.key});

  final String? stationId;

  @override
  ConsumerState<NearbyPlacesScreen> createState() => _State();
}

class _State extends ConsumerState<NearbyPlacesScreen> {
  String? _id;

  Future<void> _pick() async {
    final catalog = await ref.read(catalogProvider.future);
    if (!mounted) return;
    final picked = await StationPickerSheet.show(
      context,
      title: context.l10n.chooseStation,
      stations: catalog.options,
    );
    if (picked != null) setState(() => _id = picked.id);
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(catalogProvider).value;
    final id =
        _id ??
        widget.stationId ??
        catalog?.stations.values.where((s) => s.active).firstOrNull?.id;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.nearbyPlacesTitle)),
      body: ListView(
        padding: const EdgeInsets.all(MetroSpacing.md),
        children: [
          StationField(
            label: context.l10n.stationShort,
            value: id == null ? null : catalog?.station(id)?.name,
            dotColor: context.colors.primary,
            onTap: _pick,
          ),
          MetroSpacing.gapMd,
          if (id != null)
            AsyncValueView(
              value: ref.watch(stationDetailProvider(id)),
              onRetry: () => ref.invalidate(stationDetailProvider(id)),
              data: (d) => MetroCard(child: NearbyPlacesView(detail: d)),
            ),
        ],
      ),
    );
  }
}
