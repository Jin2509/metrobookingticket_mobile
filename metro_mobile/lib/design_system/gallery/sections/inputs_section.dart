import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/atoms/metro_text_field.dart';
import 'package:metro_mobile/design_system/atoms/otp_input.dart';
import 'package:metro_mobile/design_system/atoms/password_field.dart';
import 'package:metro_mobile/design_system/gallery/sections/gallery_section.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

class InputsSection extends StatelessWidget {
  const InputsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GallerySection(
      title: 'TextField · PasswordField · OtpInput',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MetroTextField(
            label: 'Email / Số điện thoại',
            hint: 'passenger@metro.vn',
            prefixIcon: LucideIcons.mail,
          ),
          MetroSpacing.gapSm,
          const MetroTextField(
            label: 'Biển số',
            hint: '59X1-234.56',
            error: 'Biển số không đúng định dạng',
          ),
          MetroSpacing.gapSm,
          PasswordField(
            controller: TextEditingController(text: 'Metro2026'),
            showStrength: true,
          ),
          MetroSpacing.gapMd,
          OtpInput(controller: TextEditingController(text: '48')),
          MetroSpacing.gapSm,
          OtpInput(
            controller: TextEditingController(text: '123456'),
            hasError: true,
          ),
        ],
      ),
    );
  }
}
