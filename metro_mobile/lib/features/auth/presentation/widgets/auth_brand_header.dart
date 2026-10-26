import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/brand_mark.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/line_illustration.dart';

/// Phần thương hiệu trên nền navy (giống `LoginBrandPanel` của web).
class AuthBrandHeader extends StatelessWidget {
  const AuthBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        MetroSpacing.lg,
        MetroSpacing.xl,
        MetroSpacing.lg,
        MetroSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [BrandMark(), MetroSpacing.gapLg, LineIllustration()],
      ),
    );
  }
}
