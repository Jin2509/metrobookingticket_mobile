import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/core/qr/metro_qr_codec.dart';
import 'package:metro_mobile/features/wallet/data/sources/wallet_fake_source.dart';
import 'package:metro_mobile/features/wallet/data/sources/wallet_remote_source.dart';
import 'package:metro_mobile/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:metro_mobile/features/wallet/domain/usecases/build_pass_qr.dart';
import 'package:metro_mobile/features/wallet/domain/usecases/wallet_usecases.dart';

final walletRepositoryProvider = Provider<WalletRepository>(
  (ref) => Env.useFakeData
      ? WalletFakeSource(ref.watch(demoLedgerProvider))
      : WalletRemoteSource(ref.watch(dioProvider)),
);

final getMyTicketsProvider = Provider(
  (ref) => GetMyTickets(ref.watch(walletRepositoryProvider)),
);
final getTicketDetailProvider = Provider(
  (ref) => GetTicketDetail(ref.watch(walletRepositoryProvider)),
);
final getMyTransactionsProvider = Provider(
  (ref) => GetMyTransactions(ref.watch(walletRepositoryProvider)),
);
final getActiveParkingProvider = Provider(
  (ref) => GetActiveParking(ref.watch(walletRepositoryProvider)),
);
final buildPassQrProvider = Provider((_) => const BuildPassQr(MetroQrCodec()));
