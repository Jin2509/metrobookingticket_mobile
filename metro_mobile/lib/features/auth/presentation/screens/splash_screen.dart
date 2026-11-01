import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/brand_mark.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/line_illustration.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/splash/splash_footer.dart';

/// Splash dùng chung 2 vai trò, hiện trong lúc khôi phục phiên (flow 7.1).
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MetroTheme.staff,
      child: const Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(MetroSpacing.lg),
            child: Column(
              children: [
                Spacer(flex: 3),
                BrandMark(),
                MetroSpacing.gapXl,
                LineIllustration(),
                Spacer(flex: 4),
                SplashFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
