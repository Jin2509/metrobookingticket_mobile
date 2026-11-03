import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/home/data/home_banner_source.dart';

/// Một trang của băng banner: ảnh, lớp phủ tối và chữ. Chỉ mở màn trong app.
class BannerPage extends StatelessWidget {
  const BannerPage({required this.banner});

  final HomeBanner banner;

  @override
  Widget build(BuildContext context) {
    final link = banner.linkPath;
    return Semantics(
      button: link != null,
      label: banner.title,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: link == null || !link.startsWith('/p/')
            ? null
            : () => context.push(link),
        child: Stack(
          fit: StackFit.expand,
          children: [
            MetroImage(src: banner.image, aspectRatio: 2.1),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00000000), Color(0xCC06192C)],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(MetroSpacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      banner.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: MetroTypography.titleSmall.copyWith(
                        color: MetroColors.primaryForeground,
                      ),
                    ),
                    if (banner.subtitle != null)
                      Text(
                        banner.subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: MetroTypography.label.copyWith(
                          color: MetroColors.primaryForeground,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
