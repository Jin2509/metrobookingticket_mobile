import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/gallery/sections/cards_section.dart';
import 'package:metro_mobile/design_system/gallery/sections/chat_section.dart';
import 'package:metro_mobile/design_system/gallery/sections/feedback_section.dart';
import 'package:metro_mobile/design_system/gallery/sections/notifications_section.dart';
import 'package:metro_mobile/design_system/gallery/sections/passes_section.dart';
import 'package:metro_mobile/design_system/gallery/sections/stations_section.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

class MoleculesPage extends StatelessWidget {
  const MoleculesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: MetroSpacing.xl),
      children: const [
        CardsSection(),
        PassesSection(),
        StationsSection(),
        NotificationsSection(),
        FeedbackSection(),
        ChatSection(),
      ],
    );
  }
}
