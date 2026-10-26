import 'package:metro_mobile/l10n/l10n.dart';

/// Tông màu của nhãn trạng thái (mục 3.5).
enum StatusTone { success, muted, accent, primary, destructive, secondary }

/// Bảng mã → (nhãn, tông), map 1-1 với `statusMap` trong
/// `src/components/shared.tsx` của web. Mã theo CHECK constraint DB.
Map<String, (String, StatusTone)> statusBadgeMap(AppLocalizations l) => {
  'ACTIVE': (l.statusActive, StatusTone.success),
  'INACTIVE': (l.statusInactive, StatusTone.muted),
  'PENDING': (l.statusPendingPayment, StatusTone.accent),
  'PENDING_PAYMENT': (l.statusPendingPayment, StatusTone.accent),
  'PAID': (l.statusPaid, StatusTone.primary),
  'IN_USE': (l.statusInUse, StatusTone.accent),
  'USED': (l.statusUsed, StatusTone.muted),
  'EXPIRED': (l.statusExpired, StatusTone.muted),
  'CANCELLED': (l.statusCancelled, StatusTone.destructive),
  'REFUNDED': (l.statusRefunded, StatusTone.primary),
  'SUCCESS': (l.statusSuccess, StatusTone.success),
  'FAILED': (l.statusFailed, StatusTone.destructive),
  // Gửi xe (backend PAID → CHECKED_IN → COMPLETED, xem mục 7.5)
  'CHUA_GUI': (l.statusNotParked, StatusTone.secondary),
  'DANG_GUI': (l.statusParked, StatusTone.accent),
  'LAY_XE': (l.statusPickedUp, StatusTone.muted),
  'HET_HAN': (l.statusExpired, StatusTone.muted),
};

/// Nhãn + tông cho [status]. Mã lạ thì hiển thị nguyên mã, tông muted.
(String, StatusTone) resolveStatus(AppLocalizations l, String status) =>
    statusBadgeMap(l)[status] ?? (status, StatusTone.muted);
