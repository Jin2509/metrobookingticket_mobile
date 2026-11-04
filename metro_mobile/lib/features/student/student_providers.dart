import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/features/student/data/sources/student_fake_source.dart';
import 'package:metro_mobile/features/student/data/sources/student_remote_source.dart';
import 'package:metro_mobile/features/student/domain/entities/student_verification.dart';
import 'package:metro_mobile/features/student/domain/repositories/student_repository.dart';

final studentRepositoryProvider = Provider<StudentRepository>(
  (ref) => Env.useFakeData
      ? StudentFakeSource(ref.watch(demoLedgerProvider))
      : StudentRemoteSource(ref.watch(dioProvider)),
);

/// Trạng thái xác nhận. Đang chờ duyệt thì tự tải lại khi có màn đang xem.
final studentVerificationProvider =
    FutureProvider.autoDispose<StudentVerification>((ref) async {
      final result = await ref.watch(studentRepositoryProvider).getMine();
      if (result.status == StudentStatus.pending) {
        final timer = Timer(const Duration(seconds: 10), ref.invalidateSelf);
        ref.onDispose(timer.cancel);
      }
      return result;
    });

/// Chụp hoặc chọn ảnh thẻ. Thu nhỏ để không vượt giới hạn tải lên của backend.
final studentCardPickerProvider =
    Provider<Future<Uint8List?> Function(ImageSource)>(
      (_) => (source) async {
        final file = await ImagePicker().pickImage(
          source: source,
          maxWidth: 1600,
          imageQuality: 85,
        );
        return await file?.readAsBytes();
      },
    );
