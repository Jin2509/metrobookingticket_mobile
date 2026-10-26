import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';

/// Tile OpenStreetMap (giống `LineMapPreview` Leaflet/OSM trên web).
class OsmTileLayer extends StatelessWidget {
  const OsmTileLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'vn.metro.metro_mobile',
      maxZoom: 19,
    );
  }
}
