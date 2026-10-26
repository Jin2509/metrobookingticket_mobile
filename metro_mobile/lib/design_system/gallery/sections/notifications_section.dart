import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/gallery/sections/gallery_section.dart';
import 'package:metro_mobile/design_system/models/notification_kind.dart';
import 'package:metro_mobile/design_system/molecules/metro_card.dart';
import 'package:metro_mobile/design_system/molecules/notification_tile.dart';

class NotificationsSection extends StatelessWidget {
  const NotificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const GallerySection(
      title: 'NotificationTile',
      child: MetroCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            NotificationTile(
              kind: NotificationKind.payment,
              title: 'Thanh toán thành công',
              body: 'Vé lượt Bến Thành – Thủ Đức',
              timeLabel: '10:02',
              unread: true,
            ),
            NotificationTile(
              kind: NotificationKind.ticketExpiry,
              title: 'Vé tháng còn 3 ngày',
              timeLabel: 'Hôm qua',
              unread: true,
            ),
            NotificationTile(
              kind: NotificationKind.operation,
              title: 'Tuyến 1 chạy chậm 10 phút',
              timeLabel: '20/10',
            ),
          ],
        ),
      ),
    );
  }
}
