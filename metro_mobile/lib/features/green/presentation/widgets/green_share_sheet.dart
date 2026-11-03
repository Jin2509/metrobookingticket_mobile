import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/green/domain/green_impact.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_format.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_share_card.dart';
import 'package:metro_mobile/l10n/l10n.dart';
import 'package:share_plus/share_plus.dart';

/// Xem trước thẻ thành tích rồi chia sẻ thành ảnh PNG.
class GreenShareSheet extends StatefulWidget {
  const GreenShareSheet({required this.summary, super.key});

  final GreenSummary summary;

  static Future<void> show(BuildContext context, GreenSummary summary) =>
      showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => GreenShareSheet(summary: summary),
      );

  @override
  State<GreenShareSheet> createState() => _GreenShareSheetState();
}

class _GreenShareSheetState extends State<GreenShareSheet> {
  final _card = GlobalKey();
  bool _sharing = false;

  Future<void> _share() async {
    final l = context.l10n;
    final say = MascotToast.of(context);
    setState(() => _sharing = true);
    try {
      final boundary =
          _card.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      await SharePlus.instance.share(
        ShareParams(
          text: l.greenShareText(greenNumber(widget.summary.savedKg)),
          files: [
            XFile.fromData(
              data!.buffer.asUint8List(),
              mimeType: 'image/png',
              name: 'hanh-trinh-xanh.png',
            ),
          ],
        ),
      );
    } on Object {
      say(l.greenShareFailed, mood: MascotMood.worried);
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        MetroSpacing.md,
        0,
        MetroSpacing.md,
        MetroSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.greenShareTitle, style: context.text.titleMedium),
          MetroSpacing.gapSm,
          ClipRRect(
            borderRadius: MetroRadius.brXl,
            child: RepaintBoundary(
              key: _card,
              child: GreenShareCard(summary: widget.summary),
            ),
          ),
          MetroSpacing.gapMd,
          MetroButton(
            label: l.greenShare,
            icon: LucideIcons.share2,
            expand: true,
            loading: _sharing,
            onPressed: _share,
          ),
        ],
      ),
    );
  }
}
