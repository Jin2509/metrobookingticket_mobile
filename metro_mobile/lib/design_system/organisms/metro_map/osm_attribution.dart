import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

/// Ghi nguồn bắt buộc theo chính sách tile của OSM.
class OsmAttribution extends StatelessWidget {
  const OsmAttribution({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleAttributionWidget(
      source: Text('OpenStreetMap contributors'),
    );
  }
}
