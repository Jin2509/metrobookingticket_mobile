import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/green/domain/green_impact.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/domain/entities/route_plan.dart';
import 'package:metro_mobile/features/network/network_providers.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket_filter.dart';
import 'package:metro_mobile/features/wallet/wallet_providers.dart';

/// Chỉ tính vé lượt đã đi xong: biết chắc ga đi và ga đến. Vé ngày, vé tháng
/// không có thông tin từng chuyến nên chưa được tính.
final greenSummaryProvider = FutureProvider.autoDispose<GreenSummary>((
  ref,
) async {
  final catalog = await ref.watch(catalogProvider.future);
  final getTickets = ref.watch(getMyTicketsProvider);
  final search = ref.watch(searchRouteProvider);

  final used = <Ticket>[];
  for (var page = 0; page < _maxPages; page++) {
    final result = await getTickets.call(TicketFilter.expired, page: page);
    used.addAll(result.items.where((t) => t.status == 'USED' && t.hasRoute));
    if (!result.hasMore) break;
  }

  String? idOf(String? name) =>
      catalog.stations.values.where((s) => s.name == name).firstOrNull?.id;

  final kmByRoute = <(String, String), double>{};
  final now = clock.now();
  var trips = 0;
  var km = 0.0;
  var monthTrips = 0;
  var monthKm = 0.0;
  for (final t in used) {
    final from = idOf(t.fromName);
    final to = idOf(t.toName);
    if (from == null || to == null) continue;
    final distance = await _km(kmByRoute, (from, to), catalog, search.call);
    if (distance == null) continue;
    trips++;
    km += distance;
    if (t.purchasedAt.year == now.year && t.purchasedAt.month == now.month) {
      monthTrips++;
      monthKm += distance;
    }
  }
  return GreenSummary(
    trips: trips,
    km: km,
    monthTrips: monthTrips,
    monthKm: monthKm,
  );
});

const _maxPages = 10;

Future<double?> _km(
  Map<(String, String), double> cache,
  (String, String) route,
  NetworkCatalog catalog,
  Future<RoutePlan> Function(String?, String?) search,
) async {
  final cached = cache[route];
  if (cached != null) return cached;
  try {
    final plan = await search(route.$1, route.$2);
    return cache[route] = routeKm(plan, catalog);
  } on Failure {
    return null;
  }
}
