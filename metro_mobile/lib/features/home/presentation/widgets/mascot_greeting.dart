import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:metro_mobile/features/green/presentation/controllers/green_tier_watcher.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_format.dart';
import 'package:metro_mobile/features/home/presentation/widgets/member_chip.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket.dart';
import 'package:metro_mobile/features/wallet/presentation/controllers/wallet_controllers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Vé còn hiệu lực sẽ hết hạn sớm nhất trong vòng 24 giờ.
Ticket? expiringTicket(List<Ticket> tickets, DateTime now) {
  final soon = tickets.where(
    (t) =>
        t.isUsable &&
        t.validUntil.isAfter(now) &&
        t.validUntil.difference(now) <= const Duration(hours: 24),
  );
  if (soon.isEmpty) return null;
  return soon.reduce((a, b) => a.validUntil.isBefore(b.validUntil) ? a : b);
}

/// Futu phản ứng theo hành trình: vé sắp hết hạn, lên cấp, rồi lời chào, mẹo.
class MascotGreeting extends ConsumerStatefulWidget {
  const MascotGreeting({super.key});

  @override
  ConsumerState<MascotGreeting> createState() => _MascotGreetingState();
}

class _MascotGreetingState extends ConsumerState<MascotGreeting> {
  int _index = 0;
  bool _expiryDismissed = false;

  List<String> _lines(BuildContext context, String name) {
    final l = context.l10n;
    final hour = clock.now().hour;
    return [
      if (hour < 12)
        l.futuMorning(name)
      else if (hour < 18)
        l.futuAfternoon(name)
      else
        l.futuEvening(name),
      l.mascotTipQr,
      l.mascotTipParking,
      l.mascotTipMap,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final name = ref.watch(authControllerProvider).value?.name ?? '';
    final lines = _lines(context, name.split(' ').last);
    final tierUp = ref.watch(greenTierUpProvider);
    final now = clock.now();
    final expiring = _expiryDismissed
        ? null
        : expiringTicket(
            ref.watch(activeTicketsProvider).value ?? const [],
            now,
          );

    final String text;
    final MascotMood mood;
    final VoidCallback onTap;
    if (expiring != null) {
      final hours = expiring.validUntil.difference(now).inHours;
      text = hours < 1
          ? l.mascotExpiringSoon(expiring.typeName)
          : l.mascotExpiring(expiring.typeName, hours);
      mood = MascotMood.worried;
      onTap = () {
        setState(() => _expiryDismissed = true);
        context.push(Routes.ticketDetail(expiring.id));
      };
    } else if (tierUp != null) {
      text = l.mascotTierUp(greenTierLabel(l, tierUp));
      mood = MascotMood.happy;
      onTap = () {
        ref.read(greenTierUpProvider.notifier).dismiss();
        context.push(Routes.pGreen);
      };
    } else {
      text = lines[_index];
      mood = MascotMood.normal;
      onTap = () => setState(() => _index = (_index + 1) % lines.length);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MetroMascot(
          size: 56,
          mood: mood,
          celebrate: mood == MascotMood.happy,
          semanticLabel: l.mascotLabel,
          onTap: onTap,
        ),
        MetroSpacing.gapXs,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                excludeFromSemantics: true,
                onTap: onTap,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: MetroColors.primaryForeground.withValues(alpha: .14),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(MetroRadius.lg),
                      topRight: Radius.circular(MetroRadius.lg),
                      bottomRight: Radius.circular(MetroRadius.lg),
                      bottomLeft: Radius.circular(MetroSpacing.xxs),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: MetroSpacing.sm,
                      vertical: MetroSpacing.xs,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        text,
                        key: ValueKey(text),
                        style: MetroTypography.label.copyWith(
                          color: MetroColors.primaryForeground,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const MemberChip(),
            ],
          ),
        ),
      ],
    );
  }
}
