import 'package:flutter/foundation.dart';

/// Thông báo trong hộp thư (`notification`, UC13-01/02).
@immutable
class AppNotification {
  const AppNotification({
    required this.id,
    required this.kind,
    required this.title,
    required this.createdAt,
    this.body,
    this.read = false,
    this.link,
  });

  final String id;

  /// `notification_type`: PAYMENT, TICKET_EXPIRY, SUGGESTION, OPERATION...
  final String kind;
  final String title;
  final String? body;
  final DateTime createdAt;
  final bool read;

  /// Đường dẫn trong app khi chạm (VD `/p/tickets/VE-80021`).
  final String? link;

  AppNotification asRead() => AppNotification(
    id: id,
    kind: kind,
    title: title,
    body: body,
    createdAt: createdAt,
    read: true,
    link: link,
  );
}

/// Tin tức & thông báo vận hành (P61).
@immutable
class NewsItem {
  const NewsItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.body,
    required this.publishedAt,
    this.operational = false,
  });

  final String id;
  final String title;
  final String summary;
  final String body;
  final DateTime publishedAt;

  /// Thông báo vận hành (bảo trì, chậm chuyến) hiện ở Trang chủ.
  final bool operational;
}

/// Tùy chọn thông báo (UC13-03). Vận hành và kết quả thanh toán là bắt
/// buộc, không tắt được.
@immutable
class NotificationPrefs {
  const NotificationPrefs({
    this.push = true,
    this.email = true,
    this.promotion = true,
    this.smart = false,
    this.operation = true,
    this.payment = true,
  });

  final bool push;
  final bool email;
  final bool promotion;
  final bool smart;
  final bool operation;
  final bool payment;

  NotificationPrefs copyWith({
    bool? push,
    bool? email,
    bool? promotion,
    bool? smart,
    bool? operation,
    bool? payment,
  }) => NotificationPrefs(
    push: push ?? this.push,
    email: email ?? this.email,
    promotion: promotion ?? this.promotion,
    smart: smart ?? this.smart,
    operation: operation ?? this.operation,
    payment: payment ?? this.payment,
  );
}
