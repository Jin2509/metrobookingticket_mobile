import 'package:flutter/material.dart';
import 'package:metro_mobile/features/staff/incident/presentation/widgets/incident_report_form.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Báo sự cố mới. Ga tự lấy theo phân công nên không phải chọn.
class IncidentReportScreen extends StatelessWidget {
  const IncidentReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.incidentReport)),
      body: const IncidentReportForm(),
    );
  }
}
