import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/home/presentation/widgets/home_header.dart';
import 'package:metro_mobile/features/home/presentation/widgets/quick_book_card.dart';

/// Đầu Trang chủ: nền thương hiệu chạy sát mép trên, thẻ tìm ga và mua vé nằm
/// đè lên mép dưới của nền để mắt đi thẳng vào thao tác chính.
class HomeHero extends StatelessWidget {
  const HomeHero({super.key});

  static const _cardOverlap = 120.0;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Stack(
        children: [
          Positioned.fill(
            bottom: _cardOverlap,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [m.sidebar, const Color(0xFF0A4A55)],
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(MetroRadius.xxl),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              MetroSpacing.md,
              MediaQuery.paddingOf(context).top + MetroSpacing.sm,
              MetroSpacing.md,
              0,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [HomeHeader(), MetroSpacing.gapSm, QuickBookCard()],
            ),
          ),
        ],
      ),
    );
  }
}
