/// Bộ lọc P40 (UC8-02), map sang `?status=` của `/api/tickets/my`.
enum TicketFilter {
  all('Tất cả', []),
  unused('Chưa dùng', ['PAID']),
  inUse('Đang dùng', ['IN_USE']),
  expired('Hết hạn', ['USED', 'EXPIRED', 'CANCELLED', 'REFUNDED']);

  TicketFilter(this.label, this.statuses);
  final String label;
  final List<String> statuses;

  bool matches(String status) => statuses.isEmpty || statuses.contains(status);
}
