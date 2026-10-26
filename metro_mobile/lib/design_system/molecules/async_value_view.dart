import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/design_system/atoms/metro_skeleton.dart';
import 'package:metro_mobile/design_system/molecules/error_state.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Hiển thị `AsyncValue` đủ trạng thái loading / error / data (mục 10.1).
/// Chỉ nhận giá trị qua constructor, không đọc provider.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    required this.value,
    required this.data,
    this.loading,
    this.onRetry,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;

  /// Skeleton đúng layout; mặc định là 3 dòng.
  final Widget? loading;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => loading ?? const _DefaultSkeleton(),
      error: (e, _) => ErrorState(
        message: e is Failure ? e.message : context.l10n.loadFailed,
        onRetry: onRetry,
      ),
    );
  }
}

class _DefaultSkeleton extends StatelessWidget {
  const _DefaultSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(MetroSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MetroSkeleton(width: 220, height: 18),
          MetroSpacing.gapSm,
          MetroSkeleton(height: 64),
          MetroSpacing.gapSm,
          MetroSkeleton(height: 64),
        ],
      ),
    );
  }
}
