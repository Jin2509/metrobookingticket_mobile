import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/widgets/explore/network_diagram_section.dart';
import 'package:metro_mobile/features/network/presentation/widgets/network3d/network_3d_live_view.dart';
import 'package:metro_mobile/features/network/presentation/widgets/network3d/network_3d_toolbar.dart';
import 'package:metro_mobile/features/network/presentation/widgets/network3d/selected_station_card.dart';

/// Sơ đồ mạng lưới toàn màn hình: 3D tương tác, chuyển được sang sơ đồ 2D.
class Network3dScreen extends ConsumerStatefulWidget {
  const Network3dScreen({super.key});

  @override
  ConsumerState<Network3dScreen> createState() => _Network3dScreenState();
}

class _Network3dScreenState extends ConsumerState<Network3dScreen> {
  var _is3d = true;
  String? _lineId;
  String? _selectedId;

  Widget _scene(NetworkCatalog catalog) => Stack(
    children: [
      Positioned.fill(
        child: Network3dLiveView(
          catalog: catalog,
          selectedId: _selectedId,
          lineId: _lineId,
          onStationTap: (id) => setState(() => _selectedId = id),
        ),
      ),
      Positioned(
        left: MetroSpacing.md,
        right: MetroSpacing.md,
        bottom: MetroSpacing.md,
        child: SelectedStationCard(
          catalog: catalog,
          stationId: _selectedId,
          onClose: () => setState(() => _selectedId = null),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(catalogProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Theme(
        data: MetroTheme.staff,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Network3dToolbar(
                  is3d: _is3d,
                  onModeChanged: (v) => setState(() => _is3d = v),
                  lines: catalog.value?.lines ?? const [],
                  lineId: _lineId,
                  onLineChanged: (id) => setState(() => _lineId = id),
                ),
                Expanded(
                  child: _is3d
                      ? AsyncValueView(
                          value: catalog,
                          onRetry: () => ref.invalidate(catalogProvider),
                          loading: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          data: _scene,
                        )
                      : const SingleChildScrollView(
                          padding: EdgeInsets.all(MetroSpacing.md),
                          child: NetworkDiagramSection(),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
