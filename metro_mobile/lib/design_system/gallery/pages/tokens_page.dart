import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/gallery/sections/color_tokens_section.dart';
import 'package:metro_mobile/design_system/gallery/sections/shape_tokens_section.dart';
import 'package:metro_mobile/design_system/gallery/sections/typography_section.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

class TokensPage extends StatelessWidget {
  const TokensPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: MetroSpacing.xl),
      children: const [
        ColorTokensSection(),
        TypographySection(),
        ShapeTokensSection(),
      ],
    );
  }
}
