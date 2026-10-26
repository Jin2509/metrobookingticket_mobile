import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/features/chatbot/data/sources/chat_fake_source.dart';
import 'package:metro_mobile/features/chatbot/data/sources/chat_remote_source.dart';
import 'package:metro_mobile/features/chatbot/domain/repositories/chat_repository.dart';
import 'package:metro_mobile/features/chatbot/domain/usecases/chat_usecases.dart';
import 'package:metro_mobile/features/loyalty/loyalty_providers.dart';
import 'package:metro_mobile/features/network/network_providers.dart';
import 'package:metro_mobile/features/wallet/wallet_providers.dart';

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => Env.useFakeData
      ? ChatFakeSource(
          network: ref.watch(networkRepositoryProvider),
          wallet: ref.watch(walletRepositoryProvider),
          loyalty: ref.watch(loyaltyRepositoryProvider),
        )
      : ChatRemoteSource(ref.watch(dioProvider)),
);

final chatWithBotProvider = Provider(
  (ref) => ChatWithBot(ref.watch(chatRepositoryProvider)),
);
