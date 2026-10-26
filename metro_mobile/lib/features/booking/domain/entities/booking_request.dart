import 'package:flutter/foundation.dart';

/// Yêu cầu đặt vé, khớp query `/p/book?type&from&to`.
@immutable
class BookingRequest {
  const BookingRequest({required this.typeCode, this.fromId, this.toId});

  final String typeCode;
  final String? fromId;
  final String? toId;

  @override
  bool operator ==(Object other) =>
      other is BookingRequest &&
      other.typeCode == typeCode &&
      other.fromId == fromId &&
      other.toId == toId;

  @override
  int get hashCode => Object.hash(typeCode, fromId, toId);
}
