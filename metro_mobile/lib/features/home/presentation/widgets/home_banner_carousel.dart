import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/home/data/home_banner_source.dart';
import 'package:metro_mobile/features/home/presentation/widgets/banner_page.dart';

/// Băng ảnh động ở Trang chủ, tự chuyển sau vài giây. Ảnh do backend quản lý.
class HomeBannerCarousel extends ConsumerStatefulWidget {
  const HomeBannerCarousel({super.key});

  @override
  ConsumerState<HomeBannerCarousel> createState() => _State();
}

class _State extends ConsumerState<HomeBannerCarousel> {
  final _pages = PageController();
  Timer? _timer;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 6), (_) => _advance());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pages.dispose();
    super.dispose();
  }

  void _advance() {
    final count = ref.read(homeBannersProvider).value?.length ?? 0;
    if (count < 2 || !_pages.hasClients || !mounted) return;
    if (MediaQuery.disableAnimationsOf(context) ||
        !TickerMode.valuesOf(context).enabled) {
      return;
    }
    _pages.animateToPage(
      (_page + 1) % count,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final banners = ref.watch(homeBannersProvider).value ?? const [];
    if (banners.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        ClipRRect(
          borderRadius: MetroRadius.brXl,
          child: AspectRatio(
            aspectRatio: 2.1,
            child: PageView.builder(
              controller: _pages,
              itemCount: banners.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (_, i) => BannerPage(banner: banners[i]),
            ),
          ),
        ),
        MetroSpacing.gapXs,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < banners.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _page ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: i == _page
                      ? context.colors.primary
                      : context.metro.border,
                  borderRadius: MetroRadius.brPill,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
