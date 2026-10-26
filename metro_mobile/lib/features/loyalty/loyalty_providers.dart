import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/features/loyalty/data/sources/loyalty_fake_source.dart';
import 'package:metro_mobile/features/loyalty/data/sources/loyalty_remote_source.dart';
import 'package:metro_mobile/features/loyalty/domain/entities/loyalty.dart';
import 'package:metro_mobile/features/loyalty/domain/repositories/loyalty_repository.dart';
import 'package:metro_mobile/features/loyalty/domain/usecases/loyalty_usecases.dart';

final loyaltyRepositoryProvider = Provider<LoyaltyRepository>(
  (ref) => Env.useFakeData
      ? LoyaltyFakeSource(ref.watch(demoLedgerProvider))
      : LoyaltyRemoteSource(ref.watch(dioProvider)),
);

final memberSummaryProvider = FutureProvider.autoDispose<MemberSummary>(
  (ref) => GetMemberSummary(ref.watch(loyaltyRepositoryProvider)).call(),
);

final promotionsProvider = FutureProvider.autoDispose<List<Promotion>>(
  (ref) => GetPromotions(ref.watch(loyaltyRepositoryProvider)).call(),
);

final pointsHistoryProvider = FutureProvider.autoDispose<List<PointsEntry>>(
  (ref) => GetPointsHistory(ref.watch(loyaltyRepositoryProvider)).call(),
);
