/// Hằng số path (mục 6.1).
abstract final class Routes {
  static const splash = '/splash';
  static const unsupported = '/unsupported';
  static const designGallery = '/dev/gallery';

  // Auth (dùng chung 2 vai trò)
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const otp = '/auth/otp';
  static const twoFactor = '/auth/two-factor';
  static const forgot = '/auth/forgot';
  static const reset = '/auth/reset';

  // Passenger shell
  static const pHome = '/p/home';
  static const pExplore = '/p/explore';
  static const pTickets = '/p/tickets';
  static const pAssistant = '/p/assistant';
  static const pAccount = '/p/account';

  // Staff shell
  static const sScan = '/s/scan';
  static const sParking = '/s/parking';
  static const sHistory = '/s/history';
  static const sAccount = '/s/account';
  static const sParkingScan = '$sParking/scan';

  // Khám phá (nested trong tab, giữ bottom nav)
  static const pExploreMap = '$pExplore/map';
  static const pExploreRoute = '$pExplore/route';
  static const pExplorePlaces = '$pExplore/places';

  static String lineDetail(String id) => '$pExplore/lines/$id';

  static String stationDetail(String id) => '$pExplore/stations/$id';

  /// Tiện ích quanh ga (P27), mặc định ga đầu tiên đang hoạt động.
  static String places({String? stationId}) =>
      _query(pExplorePlaces, {'station': stationId});

  static String routeSearch({String? from, String? to}) =>
      _query(pExploreRoute, {'from': from, 'to': to});

  /// Bản đồ, có thể căn giữa vào một ga hoặc mở sẵn "Ga gần bạn".
  static String map({String? stationId, bool nearby = false}) => _query(
    pExploreMap,
    {'station': stationId, 'nearby': nearby ? '1' : null},
  );

  // Đặt vé (toàn màn hình, ngoài tab)
  static const book = '/p/book';
  static const fares = '/p/fares';

  /// Bước 1 luồng mua vé (P29): chọn loại vé + hành trình.
  static const pBuy = '/p/buy';

  static String buy({String? type, String? from, String? to}) =>
      _query(pBuy, {'type': type, 'from': from, 'to': to});

  static String bookWith(String type, {String? from, String? to}) =>
      _query(book, {'type': type, 'from': from, 'to': to});

  /// [steps]: hiện thanh bước 3/3 (luồng mua vé tàu).
  static String payment(String orderId, {bool steps = false}) =>
      _query('$book/payment/$orderId', {'steps': steps ? '1' : null});

  static String paymentResult(
    String orderId,
    String status, {
    String? ticketId,
    String? parkingId,
    String? refundCode,
  }) => _query('$book/result', {
    'order': orderId,
    'status': status,
    'ticket': ticketId,
    'parking': parkingId,
    'refund': refundCode,
  });

  static String ticketDetail(String id) => '$pTickets/$id';

  static String parkingPass(String id) => '$pTickets/parking/$id';

  static const pProfile = '$pAccount/profile';
  static const sProfile = '$sAccount/profile';
  static const pTransactions = '$pAccount/transactions';
  static const pLoyalty = '$pAccount/loyalty';
  static const pNews = '$pAccount/news';
  static const pNotificationSettings = '$pAccount/notification-settings';
  static const pNotifications = '/p/notifications';

  static String newsDetail(String id) => '/p/news/$id';
  static const pParkingBook = '/p/parking/book';

  static String _query(String path, Map<String, String?> params) {
    final q = {
      for (final e in params.entries)
        if (e.value != null) e.key: e.value!,
    };
    return q.isEmpty ? path : Uri(path: path, queryParameters: q).toString();
  }

  static String otpFor(String email, {Duration? expiresIn}) =>
      _query(otp, {'email': email, 'expires': expiresIn?.inSeconds.toString()});

  /// Giữ [from] để sau bước 2 về đúng màn đang mở dở.
  static String twoFactorFor({String? from}) =>
      _query(twoFactor, {'from': from});

  static String resetFor(String email) => _query(reset, {'email': email});

  /// Xác nhận đổi email, nằm dưới màn Hồ sơ của shell tương ứng.
  static String verifyNewEmail(String profilePath, String email) =>
      _query('$profilePath/verify-email', {'email': email});
}
