import 'package:flutter/material.dart';

/// Cuộn có quán tính và nảy nhẹ ở mép trên mọi nền tảng, không có hiệu ứng kéo
/// giãn của Android, nên cảm giác lướt đồng nhất toàn app.
class MetroScrollBehavior extends MaterialScrollBehavior {
  const MetroScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}
