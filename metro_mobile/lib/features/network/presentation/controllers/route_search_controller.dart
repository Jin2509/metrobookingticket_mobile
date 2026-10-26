import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/network/domain/entities/route_plan.dart';
import 'package:metro_mobile/features/network/network_providers.dart';

/// P25/P26. `inputError` cho A1/A2 (inline), `notFound` cho A3.
@immutable
class RouteSearchState {
  const RouteSearchState({
    this.fromId,
    this.toId,
    this.searching = false,
    this.plan,
    this.inputError,
    this.notFound = false,
    this.error,
  });

  final String? fromId;
  final String? toId;
  final bool searching;
  final RoutePlan? plan;
  final String? inputError;
  final bool notFound;
  final String? error;

  RouteSearchState withStations(String? from, String? to) =>
      RouteSearchState(fromId: from, toId: to);
}

typedef RouteQuery = ({String? from, String? to});

final routeSearchProvider = NotifierProvider.autoDispose
    .family<RouteSearchController, RouteSearchState, RouteQuery>(
      RouteSearchController.new,
    );

class RouteSearchController extends Notifier<RouteSearchState> {
  RouteSearchController(this.query);
  final RouteQuery query;

  @override
  RouteSearchState build() {
    // Mở từ deep link có đủ hai ga thì tra luôn.
    if (query.from != null && query.to != null) {
      unawaited(Future.microtask(search));
    }
    return RouteSearchState(fromId: query.from, toId: query.to);
  }

  void setFrom(String id) => state = state.withStations(id, state.toId);

  void setTo(String id) => state = state.withStations(state.fromId, id);

  void swap() => state = state.withStations(state.toId, state.fromId);

  Future<void> search() async {
    final (from, to) = (state.fromId, state.toId);
    state = RouteSearchState(fromId: from, toId: to, searching: true);
    RouteSearchState next;
    try {
      final plan = await ref.read(searchRouteProvider).call(from, to);
      next = RouteSearchState(fromId: from, toId: to, plan: plan);
    } on ValidationFailure catch (f) {
      next = RouteSearchState(fromId: from, toId: to, inputError: f.message);
    } on NotFoundFailure {
      next = RouteSearchState(fromId: from, toId: to, notFound: true);
    } on Failure catch (f) {
      next = RouteSearchState(fromId: from, toId: to, error: f.message);
    }
    if (ref.mounted) state = next;
  }
}
