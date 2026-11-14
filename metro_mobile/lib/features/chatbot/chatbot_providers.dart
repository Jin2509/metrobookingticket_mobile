import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/features/chatbot/data/sources/chat_remote_source.dart';
import 'package:metro_mobile/features/chatbot/domain/repositories/chat_repository.dart';
import 'package:metro_mobile/features/chatbot/domain/usecases/chat_usecases.dart';

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRemoteSource(ref.watch(dioProvider)),
);

final chatWithBotProvider = Provider(
  (ref) => ChatWithBot(ref.watch(chatRepositoryProvider)),
);
