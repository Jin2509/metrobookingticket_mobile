import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/student/domain/entities/student_verification.dart';
import 'package:metro_mobile/features/student/presentation/controllers/student_verify_controller.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Họ tên, mã sinh viên, trường như in trên thẻ (backend đối chiếu với ảnh).
class StudentDeclarationFields extends ConsumerStatefulWidget {
  const StudentDeclarationFields({super.key});

  @override
  ConsumerState<StudentDeclarationFields> createState() => _State();
}

class _State extends ConsumerState<StudentDeclarationFields> {
  late final StudentDeclaration _initial = ref
      .read(studentVerifyProvider)
      .declaration;
  late final _name = TextEditingController(text: _initial.fullName);
  late final _code = TextEditingController(text: _initial.studentCode);
  late final _school = TextEditingController(text: _initial.school);

  @override
  void dispose() {
    _name.dispose();
    _code.dispose();
    _school.dispose();
    super.dispose();
  }

  void _changed(String _) => ref
      .read(studentVerifyProvider.notifier)
      .setDeclaration(
        StudentDeclaration(
          fullName: _name.text,
          studentCode: _code.text,
          school: _school.text,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final enabled = !ref.watch(
      studentVerifyProvider.select((s) => s.submitting),
    );
    return Column(
      children: [
        MetroTextField(
          label: l.studentFieldName,
          controller: _name,
          enabled: enabled,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.name],
          onChanged: _changed,
        ),
        MetroSpacing.gapSm,
        MetroTextField(
          label: l.studentFieldCode,
          controller: _code,
          enabled: enabled,
          textInputAction: TextInputAction.next,
          onChanged: _changed,
        ),
        MetroSpacing.gapSm,
        MetroTextField(
          label: l.studentFieldSchool,
          controller: _school,
          enabled: enabled,
          textInputAction: TextInputAction.done,
          onChanged: _changed,
        ),
      ],
    );
  }
}
