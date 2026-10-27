import 'package:metro_mobile/features/notifications/domain/entities/notification_entities.dart';

/// Tin demo có ảnh (ảnh trong `assets/news`, nguồn ở
/// `assets/NEWS_CREDITS.md`). Nội dung minh họa.
abstract final class NotificationFakeNews {
  static List<NewsItem> items(DateTime now) => [
    NewsItem(
      id: 'N3',
      title: 'Bảo trì thang cuốn ga Ba Son',
      summary: 'Thang cuốn cửa 2 tạm dừng 07:00–11:00 ngày mai.',
      body:
          'Để bảo đảm an toàn, thang cuốn tại cửa 2 ga Ba Son tạm dừng '
          'hoạt động từ 07:00 đến 11:00 ngày mai.\n\n'
          'Hành khách vui lòng sử dụng thang máy hoặc cửa 1. Nhân viên '
          'ga hỗ trợ người cao tuổi và người khuyết tật trong suốt thời '
          'gian bảo trì.',
      publishedAt: now.subtract(const Duration(hours: 2)),
      operational: true,
      imageUrl: 'assets/news/station_ceiling.jpg',
    ),
    NewsItem(
      id: 'N2',
      title: 'Tăng chuyến giờ cao điểm từ 01/11',
      summary: 'Giãn cách 6 phút/chuyến lúc 07:00–09:00 và 17:00–19:00.',
      body:
          'Từ ngày 01/11, Tuyến 1 Bến Thành – Suối Tiên bổ sung 12 chuyến '
          'mỗi ngày trong giờ cao điểm sáng (07:00–09:00) và chiều '
          '(17:00–19:00), rút giãn cách còn 6 phút/chuyến.\n\n'
          'Ngoài giờ cao điểm, tàu vẫn chạy 8–10 phút/chuyến. Hành khách '
          'xem giờ tàu đến từng ga trong mục Khám phá của ứng dụng.',
      publishedAt: now.subtract(const Duration(days: 2)),
      imageUrl: 'assets/news/train.jpg',
    ),
    NewsItem(
      id: 'N4',
      title: 'Thanh toán vé bằng VietQR qua mọi ngân hàng',
      summary: 'Quét mã hoặc chuyển khoản, vé được xuất tự động.',
      body:
          'Ứng dụng Metro hỗ trợ thanh toán bằng mã VietQR: quét mã bằng '
          'ứng dụng ngân hàng bất kỳ, hoặc chuyển khoản đúng số tiền và '
          'nội dung hiển thị trên màn hình.\n\n'
          'Hệ thống tự đối soát giao dịch trong vài giây và xuất vé ngay '
          'vào mục Vé của tôi, không cần chụp màn hình gửi xác nhận.',
      publishedAt: now.subtract(const Duration(days: 4)),
      imageUrl: 'assets/news/night_entrance.jpg',
    ),
    NewsItem(
      id: 'N1',
      title: 'Mở bán vé tháng HSSV trên ứng dụng',
      summary: 'Giảm 50% so với vé tháng thường.',
      body:
          'Học sinh, sinh viên xác thực thẻ để mua vé tháng HSSV ngay '
          'trên ứng dụng với giá ưu đãi 50% so với vé tháng thường.\n\n'
          'Vé có hiệu lực 30 ngày kể từ lúc mua, đi không giới hạn số '
          'lượt trên Tuyến 1.',
      publishedAt: now.subtract(const Duration(days: 6)),
      imageUrl: 'assets/news/ben_thanh.jpg',
    ),
    NewsItem(
      id: 'N0',
      title: 'Ga trên cao Tuyến 1 thêm bãi gửi xe',
      summary: 'Bãi PK1, PK2 nhận xe máy và ô tô, đặt chỗ trên ứng dụng.',
      body:
          'Các bãi gửi xe tại ga Thủ Đức và Bến xe Suối Tiên đã mở cửa. '
          'Hành khách có thể đăng ký gửi xe theo lượt, ngày hoặc tháng '
          'ngay trên ứng dụng và dùng mã QR để vào/ra bãi.',
      publishedAt: now.subtract(const Duration(days: 9)),
      imageUrl: 'assets/news/elevated_station.jpg',
    ),
  ];
}
