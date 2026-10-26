import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `Bến Thành → Thủ Đức`. Mũi tên vẽ bằng icon vì font Be Vietnam Pro
/// không có ký tự `→`.
class RouteLabel extends StatelessWidget {
  const RouteLabel({
    required this.from,
    required this.to,
    this.style,
    super.key,
  });

  final String from;
  final String to;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final s = style ?? DefaultTextStyle.of(context).style;
    final size = (s.fontSize ?? 14) + 2;
    return Semantics(
      label: context.l10n.fromTo(from, to),
      excludeSemantics: true,
      child: Text.rich(
        TextSpan(
          style: s,
          children: [
            TextSpan(text: from),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(LucideIcons.arrowRight, size: size, color: s.color),
              ),
            ),
            TextSpan(text: to),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
