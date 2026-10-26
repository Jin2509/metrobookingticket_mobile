import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:metro_mobile/core/platform/screen_guard_service.dart';

/// Bật độ sáng 100% + FLAG_SECURE khi vào, khôi phục khi rời (P41).
class ScreenGuard extends StatefulWidget {
  const ScreenGuard({
    required this.child,
    this.service = const ScreenGuardService(),
    super.key,
  });

  final Widget child;
  final ScreenGuardService service;

  @override
  State<ScreenGuard> createState() => _ScreenGuardState();
}

class _ScreenGuardState extends State<ScreenGuard> {
  @override
  void initState() {
    super.initState();
    unawaited(widget.service.enable());
  }

  @override
  void dispose() {
    unawaited(widget.service.disable());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
