import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/gallery/sections/badges_section.dart';
import 'package:metro_mobile/design_system/gallery/sections/buttons_section.dart';
import 'package:metro_mobile/design_system/gallery/sections/inputs_section.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

class AtomsPage extends StatelessWidget {
  const AtomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: MetroSpacing.xl),
      children: const [ButtonsSection(), InputsSection(), BadgesSection()],
    );
  }
}
