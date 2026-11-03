import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/features/network/presentation/controllers/map_panel_controller.dart';
import 'package:metro_mobile/features/network/presentation/screens/explore_screen.dart';
import 'package:metro_mobile/features/network/presentation/screens/line_detail_screen.dart';
import 'package:metro_mobile/features/network/presentation/screens/network_3d_screen.dart';
import 'package:metro_mobile/features/network/presentation/screens/network_map_screen.dart';
import 'package:metro_mobile/features/network/presentation/screens/route_search_screen.dart';
import 'package:metro_mobile/features/network/presentation/screens/station_detail_screen.dart';

/// Tab Khám phá: P20–P27, lồng trong tab (giữ bottom nav).
final exploreRoute = GoRoute(
  path: Routes.pExplore,
  builder: (_, _) => const ExploreScreen(),
  routes: [
    GoRoute(path: 'network', builder: (_, _) => const Network3dScreen()),
    GoRoute(
      path: 'map',
      builder: (_, s) => NetworkMapScreen(
        stationId: s.uri.queryParameters['station'],
        nearby: s.uri.queryParameters['nearby'] == '1',
        panel: s.uri.queryParameters['panel'] == 'places'
            ? MapPanel.places
            : MapPanel.nearby,
      ),
    ),
    GoRoute(
      path: 'route',
      builder: (_, s) => RouteSearchScreen(
        from: s.uri.queryParameters['from'],
        to: s.uri.queryParameters['to'],
      ),
    ),
    GoRoute(
      path: 'lines/:lineId',
      builder: (_, s) => LineDetailScreen(lineId: s.pathParameters['lineId']!),
    ),
    GoRoute(
      path: 'stations/:stationId',
      builder: (_, s) =>
          StationDetailScreen(stationId: s.pathParameters['stationId']!),
    ),
  ],
);
