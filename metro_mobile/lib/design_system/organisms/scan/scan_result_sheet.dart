import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/colors.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// Kết quả quét (S11): nền XANH = hợp lệ, ĐỎ = không hợp lệ kèm lý do.
/// Tự gọi [onClose] sau [autoClose] (mặc định 2,5s).
class ScanResultSheet extends StatefulWidget {
  const ScanResultSheet({
    required this.valid,
    required this.title,
    required this.lines,
    required this.onClose,
    this.actions = const [],
    this.autoClose = const Duration(milliseconds: 2500),
    super.key,
  });

  final bool valid;
  final String title;
  final List<String> lines;
  final VoidCallback onClose;
  final List<Widget> actions;
  final Duration? autoClose;

  @override
  State<ScanResultSheet> createState() => _ScanResultSheetState();
}

class _ScanResultSheetState extends State<ScanResultSheet> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final d = widget.autoClose;
    if (d != null) _timer = Timer(d, widget.onClose);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Màu đậm cố định cho mọi theme: chữ trắng vẫn đọc được ngoài trời.
    final bg = widget.valid ? MetroColors.success : MetroColors.destructive;
    const fg = Colors.white;
    return Semantics(
      liveRegion: true,
      label: widget.title,
      child: Container(
        width: double.infinity,
        color: bg,
        padding: const EdgeInsets.fromLTRB(
          MetroSpacing.lg,
          MetroSpacing.lg,
          MetroSpacing.lg,
          MetroSpacing.xl,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    widget.valid
                        ? LucideIcons.circleCheck
                        : LucideIcons.octagonX,
                    color: fg,
                    size: 32,
                  ),
                  MetroSpacing.gapSm,
                  Expanded(
                    child: Text(
                      widget.title,
                      style: context.text.titleLarge?.copyWith(color: fg),
                    ),
                  ),
                ],
              ),
              MetroSpacing.gapSm,
              for (final l in widget.lines)
                Text(l, style: context.text.bodyLarge?.copyWith(color: fg)),
              if (widget.actions.isNotEmpty) ...[
                MetroSpacing.gapMd,
                Row(children: widget.actions),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
