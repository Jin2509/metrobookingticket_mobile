import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/forecast/forecast_providers.dart';
import 'package:metro_mobile/features/forecast/presentation/widgets/forecast_format.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Futu gợi ý giờ đi ở kết quả lộ trình. Chỉ hiện khi ga đi đang đông hoặc sắp
/// đông trong 2 giờ tới, còn lại ẩn để màn gọn.
class RouteForecastTip extends ConsumerWidget {
  const RouteForecastTip({
    required this.stationId,
    required this.stationName,
    super.key,
  });

  final String stationId;
  final String stationName;

  static const _warnWithinHours = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final f = ref.watch(stationForecastProvider(stationId)).value;
    if (f == null) return const SizedBox.shrink();
    final l = context.l10n;
    final hour = forecastNow().hour;
    final active = f.activePeak(hour);
    final next = f.nextPeak(hour);
    final String text;
    if (active != null) {
      text = l.forecastTipNow(stationName, forecastHour(active.toHour));
    } else if (next != null && next.fromHour - hour <= _warnWithinHours) {
      text = l.forecastTipBefore(forecastHour(next.fromHour), stationName);
    } else {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: MetroSpacing.md),
      child: MascotTip(
        text: text,
        mood: active != null ? MascotMood.worried : MascotMood.normal,
      ),
    );
  }
}
