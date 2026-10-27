import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/chatbot/domain/entities/chat_entities.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Rich card trong câu trả lời, có nút điều hướng. Vé chỉ hiện tên và
/// hạn dùng; QR phải mở ở màn vé (không hiển thị trong chat).
class ChatAttachmentView extends StatelessWidget {
  const ChatAttachmentView({required this.attachment, super.key});

  final ChatAttachment attachment;

  Widget _button(
    BuildContext context,
    String label,
    IconData icon,
    String to,
  ) => MetroButton(
    label: label,
    icon: icon,
    size: MetroButtonSize.sm,
    variant: MetroButtonVariant.secondary,
    onPressed: () {
      // Đang ở sheet Trợ lý: đóng sheet rồi mới mở màn đích.
      final router = GoRouter.of(context);
      if (ModalRoute.of(context) is PopupRoute) Navigator.of(context).pop();
      unawaited(router.push(to));
    },
  );

  @override
  Widget build(BuildContext context) {
    return switch (attachment) {
      TicketAttachment(:final ticketId, :final title, :final validUntil) =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title · ${context.l10n.validUntilShort(dateOnly(validUntil))}',
              style: context.text.labelMedium,
            ),
            MetroSpacing.gapXs,
            _button(
              context,
              context.l10n.viewTicket,
              LucideIcons.ticket,
              Routes.ticketDetail(ticketId),
            ),
          ],
        ),
      StationAttachment(:final stationId, :final name) => _button(
        context,
        context.l10n.viewStation(name),
        LucideIcons.mapPin,
        Routes.stationDetail(stationId),
      ),
      RouteAttachment(:final fromId, :final toId) => Wrap(
        spacing: MetroSpacing.xs,
        runSpacing: MetroSpacing.xs,
        children: [
          _button(
            context,
            context.l10n.route,
            LucideIcons.route,
            Routes.routeSearch(from: fromId, to: toId),
          ),
          _button(
            context,
            context.l10n.book,
            LucideIcons.ticket,
            Routes.bookWith('SINGLE', from: fromId, to: toId),
          ),
        ],
      ),
      BusAttachment(:final stops) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (name, routes) in stops)
            Padding(
              padding: const EdgeInsets.only(bottom: MetroSpacing.xxs),
              child: Text(
                '$name: ${routes.join(', ')}',
                style: context.text.bodySmall,
              ),
            ),
        ],
      ),
    };
  }
}
