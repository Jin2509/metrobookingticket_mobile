// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appSlogan => 'Kỷ nguyên mới, chuyển động mới';

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navExplore => 'Khám phá';

  @override
  String get navTickets => 'Vé';

  @override
  String get navAccount => 'Tài khoản';

  @override
  String get navScan => 'Soát vé';

  @override
  String get navParking => 'Gửi xe';

  @override
  String get navHistory => 'Lịch sử';

  @override
  String get accountTitle => 'Tài khoản';

  @override
  String get rolePassenger => 'Hành khách';

  @override
  String get roleStaff => 'Nhân viên soát vé';

  @override
  String get menuProfile => 'Hồ sơ cá nhân';

  @override
  String get menuTransactions => 'Lịch sử giao dịch';

  @override
  String get menuLoyalty => 'Thành viên';

  @override
  String get menuNotificationSettings => 'Cài đặt thông báo';

  @override
  String get menuNews => 'Tin tức Metro';

  @override
  String get menuStaffProfile => 'Hồ sơ nhân viên';

  @override
  String get menuStation => 'Ga được phân công';

  @override
  String comingSoon(String item) {
    return '$item đang phát triển';
  }

  @override
  String get settingsTitle => 'Cài đặt ứng dụng';

  @override
  String get appearance => 'Giao diện';

  @override
  String get appearanceSystem => 'Theo hệ thống';

  @override
  String get appearanceLight => 'Sáng';

  @override
  String get appearanceDark => 'Tối';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get logoutConfirmTitle => 'Đăng xuất?';

  @override
  String get logoutConfirmBody =>
      'Bạn sẽ cần đăng nhập lại để tiếp tục sử dụng.';

  @override
  String get cancel => 'Hủy';

  @override
  String get unsupportedTitle => 'Vui lòng dùng trang quản trị web';

  @override
  String get unsupportedBody =>
      'Tài khoản này không thao tác trên ứng dụng di động. Hãy đăng nhập trang quản trị Metro trên máy tính.';

  @override
  String get placeholderTitle => 'Đang phát triển';

  @override
  String placeholderBody(int phase) {
    return 'Màn hình này thuộc giai đoạn $phase.';
  }

  @override
  String get errNetwork => 'Không có kết nối mạng';

  @override
  String get errUnauthorized => 'Sai thông tin đăng nhập';

  @override
  String get errForbidden => 'Bạn không có quyền thực hiện';

  @override
  String get errNotFound => 'Không tìm thấy dữ liệu';

  @override
  String get errConflict => 'Dữ liệu đã thay đổi';

  @override
  String get errValidation => 'Dữ liệu không hợp lệ';

  @override
  String get errServer => 'Hệ thống đang bận, thử lại sau';

  @override
  String get errAccountLocked => 'Tài khoản đã bị khóa';

  @override
  String get valEmailRequired => 'Vui lòng nhập email';

  @override
  String get valEmailInvalid => 'Email không hợp lệ';

  @override
  String get valPasswordLength => 'Mật khẩu tối thiểu 8 ký tự';

  @override
  String get valPasswordMismatch => 'Mật khẩu nhập lại không khớp';

  @override
  String get valPasswordRequired => 'Vui lòng nhập mật khẩu';

  @override
  String get valNameRequired => 'Vui lòng nhập họ tên';

  @override
  String get valTermsRequired => 'Vui lòng đồng ý điều khoản sử dụng';

  @override
  String get valOtpFormat => 'Mã OTP gồm 6 chữ số';

  @override
  String get errOtpInvalid => 'Mã OTP không hợp lệ';

  @override
  String get errAccountExists => 'Tài khoản đã tồn tại';

  @override
  String get valQuestionRequired => 'Vui lòng nhập câu hỏi';

  @override
  String get valQuestionLength => 'Câu hỏi tối đa 300 ký tự';

  @override
  String get valStationsRequired => 'Vui lòng chọn ga đi và ga đến';

  @override
  String get valStationsSame => 'Ga đi và ga đến trùng nhau';

  @override
  String get errStationNotFound => 'Không tìm thấy ga';

  @override
  String get errRouteNotFound => 'Không tìm thấy lộ trình phù hợp';

  @override
  String get errOrderNotFound => 'Không tìm thấy đơn';

  @override
  String get errTicketNotFound => 'Không tìm thấy vé';

  @override
  String get errParkingNotFound => 'Không tìm thấy lượt gửi xe';

  @override
  String get errParkingOtherLot => 'Lượt gửi xe thuộc bãi khác';

  @override
  String get errLotNotFound => 'Không tìm thấy bãi xe';

  @override
  String get errParkingActive => 'Xe đang có lượt gửi còn hiệu lực';

  @override
  String get errParkingFull => 'Loại giữ xe đã hết chỗ';

  @override
  String get valPlateRequired => 'Vui lòng nhập biển số';

  @override
  String get valPlateInvalid => 'Biển số không đúng định dạng';

  @override
  String get errQrWrongKind => 'Mã QR không đúng loại';

  @override
  String get errMandatoryNotification => 'Không thể tắt thông báo bắt buộc';

  @override
  String get errMandatoryNotificationKinds =>
      'Thông báo vận hành và kết quả thanh toán là bắt buộc';

  @override
  String errStationInactive(String name) {
    return 'Ga $name chưa hoạt động';
  }

  @override
  String get notSelected => 'chưa chọn';

  @override
  String get chooseStation => 'Chọn ga';

  @override
  String get liveConnected => 'Trực tiếp';

  @override
  String get liveReconnecting => 'Đang kết nối lại…';

  @override
  String get loadFailed => 'Không tải được dữ liệu';

  @override
  String get errorTitle => 'Đã có lỗi xảy ra';

  @override
  String get retry => 'Thử lại';

  @override
  String get interchangeStation => 'Ga chuyển tuyến';

  @override
  String get stationClosed => 'Ngừng hoạt động';

  @override
  String sinceTime(String time) {
    return 'Từ $time';
  }

  @override
  String get feedbackHelpful => 'Hữu ích';

  @override
  String get feedbackNotHelpful => 'Chưa hữu ích';

  @override
  String routeMinutesApprox(int minutes) {
    return '~$minutes phút';
  }

  @override
  String stationCount(int count) {
    return '$count ga';
  }

  @override
  String transferCount(int count) {
    return '$count lần chuyển';
  }

  @override
  String validUntilShort(String date) {
    return 'Hạn $date';
  }

  @override
  String get openQr => 'Mở QR';

  @override
  String get details => 'Chi tiết';

  @override
  String fromTo(String from, String to) {
    return '$from đến $to';
  }

  @override
  String timeLeft(String time) {
    return 'Còn $time';
  }

  @override
  String get stationSearchHint => 'Tìm ga, VD: ben thanh';

  @override
  String get stationSearchEmptyHint => 'Thử gõ tên khác, VD \"suoi tien\"';

  @override
  String get recent => 'Gần đây';

  @override
  String get loading => 'Đang tải';

  @override
  String get password => 'Mật khẩu';

  @override
  String get showPassword => 'Hiện mật khẩu';

  @override
  String get hidePassword => 'Ẩn mật khẩu';

  @override
  String get torchOn => 'Bật đèn';

  @override
  String get torchOff => 'Tắt đèn';

  @override
  String get newCode => 'Tạo mã mới';

  @override
  String get codeExpired => 'Mã đã hết hạn';

  @override
  String get paymentScanHint => 'Quét bằng ứng dụng ngân hàng hoặc ví bất kỳ';

  @override
  String get amount => 'Số tiền';

  @override
  String get orderCode => 'Mã đơn';

  @override
  String get cancelTransaction => 'Hủy giao dịch';

  @override
  String get paymentWaiting => 'Đang chờ xác nhận thanh toán…';

  @override
  String trainLabel(String id) {
    return 'Tàu $id';
  }

  @override
  String get checking => 'Đang kiểm tra…';

  @override
  String get scanHint => 'Đưa mã QR vào khung';

  @override
  String get yourLocation => 'Vị trí của bạn';

  @override
  String busStopLabel(String name) {
    return 'Trạm buýt $name';
  }

  @override
  String get ticketInactive => 'Vé không còn hiệu lực';

  @override
  String get qrCode => 'Mã QR';

  @override
  String get trainApproaching => 'Tàu đang tới';

  @override
  String refreshIn(String time) {
    return 'Làm mới sau $time';
  }

  @override
  String get vehicleMotorbike => 'Xe máy';

  @override
  String get vehicleBicycle => 'Xe đạp';

  @override
  String get vehicleCar => 'Ô tô';

  @override
  String get strengthWeak => 'Yếu';

  @override
  String get strengthFair => 'Trung bình';

  @override
  String get strengthGood => 'Mạnh vừa';

  @override
  String get strengthStrong => 'Mạnh';

  @override
  String get statusActive => 'Hoạt động';

  @override
  String get statusInactive => 'Ngừng';

  @override
  String get statusPendingPayment => 'Chờ thanh toán';

  @override
  String get statusPaid => 'Chưa sử dụng';

  @override
  String get statusInUse => 'Đang sử dụng';

  @override
  String get statusUsed => 'Đã sử dụng';

  @override
  String get statusExpired => 'Hết hạn';

  @override
  String get statusCancelled => 'Đã hủy';

  @override
  String get statusRefunded => 'Hoàn tiền';

  @override
  String get statusSuccess => 'Thành công';

  @override
  String get statusFailed => 'Thất bại';

  @override
  String get statusNotParked => 'Chưa gửi';

  @override
  String get statusParked => 'Đang gửi';

  @override
  String get statusPickedUp => 'Đã lấy xe';

  @override
  String get login => 'Đăng nhập';

  @override
  String get noAccount => 'Chưa có tài khoản?';

  @override
  String get register => 'Đăng ký';

  @override
  String demoPassword(String password) {
    return 'Mật khẩu demo: $password';
  }

  @override
  String get forgotPasswordTitle => 'Quên mật khẩu';

  @override
  String get forgotPasswordIntro =>
      'Quên mật khẩu hả? Cho Futu biết email đã đăng ký nha.';

  @override
  String get registerTitle => 'Tạo tài khoản';

  @override
  String get haveAccount => 'Đã có tài khoản?';

  @override
  String get newPassword => 'Mật khẩu mới';

  @override
  String get resetSessionExpired => 'Phiên đặt lại đã hết hạn';

  @override
  String get resetSessionExpiredBody =>
      'Vui lòng thực hiện lại bước quên mật khẩu.';

  @override
  String get otpTitleRegister => 'Xác thực email';

  @override
  String get otpTitleReset => 'Đặt lại mật khẩu';

  @override
  String get otpSentTo => 'Mã 6 số đã gửi tới ';

  @override
  String demoOtp(String otp) {
    return 'Mã OTP demo: $otp';
  }

  @override
  String lockedBanner(String message) {
    return '$message. Vui lòng liên hệ quầy hỗ trợ tại ga.';
  }

  @override
  String get resetPasswordDone => 'Đổi mật khẩu xong! Đăng nhập lại nha.';

  @override
  String get confirmNewPassword => 'Nhập lại mật khẩu mới';

  @override
  String get saveNewPassword => 'Lưu mật khẩu mới';

  @override
  String get registeredEmail => 'Email đã đăng ký';

  @override
  String get sendCode => 'Gửi mã xác thực';

  @override
  String environment(String flavor) {
    return 'Môi trường: $flavor';
  }

  @override
  String resendCodeIn(int seconds) {
    return 'Gửi lại mã (sau ${seconds}s)';
  }

  @override
  String get resendCode => 'Gửi lại mã';

  @override
  String get otpResent => 'Futu gửi lại mã rồi, xem mail nha!';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get fullName => 'Họ tên';

  @override
  String get otpWillBeSent => 'Mã OTP sẽ gửi tới email này';

  @override
  String get confirmPassword => 'Nhập lại mật khẩu';

  @override
  String get continueLabel => 'Tiếp tục';

  @override
  String get rememberMe => 'Ghi nhớ đăng nhập';

  @override
  String get forgotPasswordLink => 'Quên mật khẩu?';

  @override
  String get otpExpired => 'Mã đã hết hạn, vui lòng gửi lại mã.';

  @override
  String expiresIn(String time) {
    return 'Hết hạn sau $time';
  }

  @override
  String get agreeTo => 'Tôi đồng ý với ';

  @override
  String get termsOfUse => 'Điều khoản sử dụng';

  @override
  String arrivalsAtStation(String station) {
    return 'Tàu sắp đến · Ga $station';
  }

  @override
  String get quickBook => 'Đặt vé nhanh';

  @override
  String get fares => 'Bảng giá';

  @override
  String get pay => 'Thanh toán';

  @override
  String get chooseFrom => 'Chọn ga đi';

  @override
  String get chooseTo => 'Chọn ga đến';

  @override
  String get fromShort => 'Đi';

  @override
  String get to => 'Đến';

  @override
  String get swap => 'Đổi chiều';

  @override
  String memberChip(String tier, String points) {
    return '$tier · $points CPoint';
  }

  @override
  String get notifications => 'Thông báo';

  @override
  String get activePasses => 'Vé đang hiệu lực';

  @override
  String get viewAll => 'Xem tất cả';

  @override
  String get noActivePasses => 'Chưa có vé đang hiệu lực';

  @override
  String get cancelTransactionTitle => 'Hủy giao dịch?';

  @override
  String get cancelTransactionBody =>
      'Vé sẽ không được tạo. Bạn có thể đặt lại sau.';

  @override
  String get continuePayment => 'Tiếp tục thanh toán';

  @override
  String get fareTableTitle => 'Bảng giá vé';

  @override
  String get fareTableNote =>
      'Giá đã gồm VAT. Ưu đãi và giảm theo CPoint được trừ khi thanh toán.';

  @override
  String get bookingConfirmTitle => 'Xác nhận vé';

  @override
  String get noStationsNeeded => 'Không cần chọn ga';

  @override
  String get fare => 'Giá vé';

  @override
  String payByQr(String amount) {
    return 'Thanh toán bằng QR · $amount';
  }

  @override
  String usePoints(int points) {
    return 'Dùng $points điểm';
  }

  @override
  String pointsAvailable(String points) {
    return 'Đang có $points điểm';
  }

  @override
  String fareTierFrom(int count) {
    return 'Từ $count ga trở lên';
  }

  @override
  String fareTierRange(int from, int to) {
    return '$from – $to ga';
  }

  @override
  String get singleFareTitle => 'Vé lượt (theo số ga đi qua)';

  @override
  String get periodPassTitle => 'Vé theo thời hạn';

  @override
  String get paymentCodeExpired => 'Mã thanh toán đã hết hạn';

  @override
  String get paymentFailed => 'Thanh toán thất bại';

  @override
  String get paymentFailedBody => 'Bạn chưa bị trừ tiền. Vui lòng đặt lại vé.';

  @override
  String get refundPendingTitle => 'Đang xử lý hoàn tiền';

  @override
  String get refundPendingBody =>
      'Hệ thống chưa tạo được vé. Tiền sẽ được hoàn trong 1–3 ngày làm việc.';

  @override
  String refundCode(String code) {
    return 'Mã tra soát: $code';
  }

  @override
  String get viewTransactions => 'Xem lịch sử giao dịch';

  @override
  String get backHome => 'Về trang chủ';

  @override
  String get paymentSuccess => 'Thanh toán thành công';

  @override
  String get openParkingQr => 'Mở QR gửi xe';

  @override
  String get openTicketQr => 'Mở QR vé';

  @override
  String get networkMapTitle => 'Bản đồ mạng lưới';

  @override
  String get stationDetailTitle => 'Chi tiết ga';

  @override
  String stationName(String name) {
    return 'Ga $name';
  }

  @override
  String get line => 'Tuyến';

  @override
  String get lineNotFound => 'Không tìm thấy tuyến';

  @override
  String get metroLines => 'Các tuyến Metro';

  @override
  String get routeSearchTitle => 'Tra cứu lộ trình';

  @override
  String get routeNotFound => 'Không tìm thấy lộ trình';

  @override
  String get routeNotFoundBody =>
      'Hai ga chưa được kết nối bởi tuyến đang khai thác.';

  @override
  String transferTo(String line) {
    return 'Chuyển $line';
  }

  @override
  String changeTo(String line) {
    return 'Đổi sang $line (~3 phút)';
  }

  @override
  String minutes(int minutes) {
    return '$minutes phút';
  }

  @override
  String get direct => 'Đi thẳng';

  @override
  String get map => 'Bản đồ';

  @override
  String get book => 'Đặt vé';

  @override
  String get exits => 'Lối ra';

  @override
  String get from => 'Từ';

  @override
  String get findRoute => 'Tìm lộ trình';

  @override
  String get noAmenities => 'Chưa có dữ liệu tiện ích quanh ga';

  @override
  String get inOperation => 'Đang hoạt động';

  @override
  String get underMaintenance => 'Đang bảo trì';

  @override
  String get lineSuspended => 'Tạm ngừng khai thác';

  @override
  String get notInOperation => 'Chưa khai thác';

  @override
  String get tabOverview => 'Tổng quan';

  @override
  String get tabNearby => 'Quanh ga';

  @override
  String get tabBus => 'Xe buýt';

  @override
  String get bookFromHere => 'Đặt vé từ đây';

  @override
  String get viewMap => 'Xem bản đồ';

  @override
  String get noBusStops => 'Chưa có trạm buýt kết nối';

  @override
  String walkMinutes(int minutes) {
    return '$minutes phút đi bộ';
  }

  @override
  String get arriving => 'Đang vào ga';

  @override
  String etaMinutes(int minutes) {
    return '$minutes ph';
  }

  @override
  String get nextTrains => 'Tàu sắp đến';

  @override
  String get arrivalsFailed => 'Không lấy được giờ tàu';

  @override
  String get noArrivals => 'Chưa có chuyến tàu nào đang tới';

  @override
  String get routeLookup => 'Tra lộ trình';

  @override
  String get nearbyStations => 'Ga gần bạn';

  @override
  String get linePlanned => 'Quy hoạch';

  @override
  String get inService => 'Đang khai thác';

  @override
  String get linePlannedNote =>
      'Tuyến đang quy hoạch, chưa khai thác. Thông tin chỉ để tham khảo.';

  @override
  String get tapMapToPick => 'Chạm vào bản đồ để chọn vị trí của bạn';

  @override
  String get locationServiceOff => 'Dịch vụ định vị đang tắt.';

  @override
  String get locationDeniedForever =>
      'Bạn đã chặn quyền vị trí. Hãy bật lại trong Cài đặt.';

  @override
  String get locationRationale =>
      'App cần vị trí trong phiên này để tìm ga gần bạn. Vị trí không được lưu lại.';

  @override
  String get enableLocation => 'Bật vị trí';

  @override
  String get pickOnMap => 'Chọn trên bản đồ';

  @override
  String get noLines => 'Chưa có tuyến';

  @override
  String get searchStation => 'Tìm ga';

  @override
  String get all => 'Tất cả';

  @override
  String get bus => 'Buýt';

  @override
  String get findNearby => 'Tìm ga gần bạn';

  @override
  String get findNearMe => 'Tìm ga gần vị trí của tôi';

  @override
  String get byPickedLocation => 'Theo vị trí bạn chọn';

  @override
  String get structureUnderground => 'Ngầm';

  @override
  String get structureElevated => 'Trên cao';

  @override
  String get structureAtGrade => 'Mặt đất';

  @override
  String get myTickets => 'Vé của tôi';

  @override
  String get trainTickets => 'Vé tàu';

  @override
  String get noTransactions => 'Chưa có giao dịch';

  @override
  String get parkingEnded => 'Lượt gửi xe đã kết thúc';

  @override
  String get noParkingPasses => 'Chưa có lượt gửi xe';

  @override
  String get registerParking => 'Đăng ký gửi xe';

  @override
  String get allShown => 'Đã hiển thị tất cả';

  @override
  String get noTickets => 'Bạn chưa có vé nào';

  @override
  String noTicketsFiltered(String filter) {
    return 'Không có vé $filter';
  }

  @override
  String get bookNow => 'Đặt vé ngay';

  @override
  String get filterUnused => 'Chưa dùng';

  @override
  String get filterInUse => 'Đang dùng';

  @override
  String validUntil(String date) {
    return 'Hiệu lực đến $date';
  }

  @override
  String get ticketQrHint =>
      'Đưa mã QR vào máy quét hoặc cho nhân viên soát vé.';

  @override
  String get close => 'Đóng';

  @override
  String codeLabel(String code) {
    return 'Mã: $code';
  }

  @override
  String enteredAt(String time) {
    return 'Vào lúc $time';
  }

  @override
  String get lot => 'Bãi';

  @override
  String get plate => 'Biển số';

  @override
  String get bicycleNoPlate => 'Xe đạp không cần biển số';

  @override
  String get vehicleType => 'Loại xe';

  @override
  String get package => 'Gói';

  @override
  String get packageTurn => 'Lượt';

  @override
  String get packageDay => 'Ngày';

  @override
  String get packageMonth => 'Tháng';

  @override
  String get feeEmpty => 'Phí: —';

  @override
  String fee(String amount) {
    return 'Phí $amount';
  }

  @override
  String get activePassBanner => 'Xe này đang có lượt gửi còn hiệu lực.';

  @override
  String get lotNoVehicleType => 'Bãi không nhận loại xe này';

  @override
  String get available => 'Còn trống';

  @override
  String until(String date) {
    return 'Đến $date';
  }

  @override
  String get membership => 'Thành viên';

  @override
  String tierBenefits(String tier) {
    return 'Quyền lợi hạng $tier';
  }

  @override
  String get activePromotions => 'Ưu đãi đang có';

  @override
  String get noPromotions => 'Hiện chưa có ưu đãi';

  @override
  String get pointsHistory => 'Lịch sử điểm';

  @override
  String tierTitle(String tier) {
    return 'Hạng $tier';
  }

  @override
  String points(String points) {
    return '$points điểm';
  }

  @override
  String get topTier => 'Bạn đang ở hạng cao nhất';

  @override
  String pointsToNext(String points, String tier) {
    return 'Còn $points điểm lên $tier';
  }

  @override
  String get noPointsHistory => 'Chưa có biến động điểm';

  @override
  String get markAllRead => 'Đánh dấu đã đọc';

  @override
  String get noNotifications => 'Chưa có thông báo';

  @override
  String get yesterday => 'Hôm qua';

  @override
  String get noNews => 'Chưa có tin';

  @override
  String get prefPush => 'Thông báo đẩy';

  @override
  String get prefPromotion => 'Khuyến mãi';

  @override
  String get prefSmart => 'Gợi ý thông minh';

  @override
  String get prefSmartBody => 'Gợi ý loại vé tiết kiệm theo thói quen đi lại';

  @override
  String get prefOperation => 'Vận hành';

  @override
  String get prefOperationBody =>
      'Bắt buộc: thay đổi lịch chạy, sự cố, bảo trì';

  @override
  String get prefPayment => 'Kết quả thanh toán';

  @override
  String get prefPaymentBody => 'Bắt buộc: xác nhận giao dịch của bạn';

  @override
  String get operationNotice => 'Thông báo vận hành';

  @override
  String get assistantTitle => 'Trợ lý HopOn';

  @override
  String get newSession => 'Phiên mới';

  @override
  String get assistantTyping => 'Futu đang trả lời…';

  @override
  String get sendFailed => 'Không gửi được câu hỏi';

  @override
  String get askHint => 'Nhập câu hỏi…';

  @override
  String get send => 'Gửi';

  @override
  String get viewTicket => 'Xem vé';

  @override
  String viewStation(String name) {
    return 'Xem ga $name';
  }

  @override
  String get route => 'Lộ trình';

  @override
  String get scanEntry => 'Vào ga';

  @override
  String get scanExit => 'Ra ga';

  @override
  String get scanValid => 'VÉ HỢP LỆ';

  @override
  String get scanInvalid => 'KHÔNG HỢP LỆ';

  @override
  String recordedAt(String time, String mode) {
    return 'Ghi nhận: $time · $mode';
  }

  @override
  String rejectReason(String reason) {
    return 'Lý do: $reason';
  }

  @override
  String ticketLabel(String ticket) {
    return 'Vé: $ticket';
  }

  @override
  String currentStation(String station) {
    return 'Ga hiện tại: $station';
  }

  @override
  String get scanNext => 'Quét tiếp';

  @override
  String get rejectExpired => 'Vé hết hạn';

  @override
  String get rejectUsed => 'Vé đã được sử dụng';

  @override
  String get rejectAlreadyIn => 'Vé đã được check-in';

  @override
  String get rejectNotIn => 'Vé chưa check-in vào ga';

  @override
  String get rejectWrongStation => 'Check-out sai ga';

  @override
  String get rejectNotFound => 'Vé không tồn tại';

  @override
  String get rejectForbidden => 'Bạn chỉ được soát vé tại ga được phân công';

  @override
  String get errQrUnreadable => 'Không đọc được mã QR. Quét lại';

  @override
  String get statEntries => 'vào';

  @override
  String get statExits => 'ra';

  @override
  String get statRejected => 'từ chối';

  @override
  String get enterTicketCode => 'Nhập mã vé';

  @override
  String get check => 'Kiểm tra';

  @override
  String get cameraDeniedTitle => 'Chưa có quyền camera';

  @override
  String get cameraDeniedForever =>
      'Mở Cài đặt > Quyền > Camera để bật lại. Trong lúc chờ, dùng \"Nhập mã vé thủ công\".';

  @override
  String get cameraRationale =>
      'Cần camera sau để quét QR trên màn hình hành khách.';

  @override
  String get openSettings => 'Mở cài đặt';

  @override
  String get grantCamera => 'Cấp quyền camera';

  @override
  String get manualCode => 'Nhập mã vé thủ công';

  @override
  String get scanParkingQr => 'Quét QR gửi xe';

  @override
  String get parkedAtLot => 'Đang gửi tại bãi';

  @override
  String get searchPlate => 'Tìm biển số';

  @override
  String get noVehicles => 'Không có xe phù hợp';

  @override
  String get result => 'Kết quả';

  @override
  String parkedInAt(String time) {
    return 'Vào lúc $time';
  }

  @override
  String parkedOutAt(String time) {
    return 'Ra lúc $time';
  }

  @override
  String get scanHistoryTitle => 'Lịch sử quét · Hôm nay';

  @override
  String get noScans => 'Chưa có lượt quét';

  @override
  String get filterTickets => 'Vé';

  @override
  String get filterRejected => 'Từ chối';

  @override
  String get inShort => 'Vào';

  @override
  String get outShort => 'Ra';

  @override
  String get viewQr => 'Xem QR';

  @override
  String ticketCodeExample(String code) {
    return 'VD: $code';
  }

  @override
  String get viewDesignSystem => 'Xem Design System';

  @override
  String parkedSince(String time) {
    return 'từ $time';
  }

  @override
  String get placeBus => 'Xe buýt';

  @override
  String get placeHealth => 'Y tế';

  @override
  String get placeMarket => 'Chợ & mua sắm';

  @override
  String get placeFood => 'Ăn uống';

  @override
  String get placeEducation => 'Trường học';

  @override
  String get placeLeisure => 'Vui chơi';

  @override
  String get placeServices => 'Tiện ích';

  @override
  String get kindHospital => 'Bệnh viện';

  @override
  String get kindMarket => 'Chợ';

  @override
  String get kindShop => 'Mua sắm';

  @override
  String get kindFood => 'Ăn uống';

  @override
  String get kindSchool => 'Trường học';

  @override
  String get kindPark => 'Công viên';

  @override
  String get kindLandmark => 'Địa danh';

  @override
  String get kindAtm => 'ATM';

  @override
  String get kindParking => 'Bãi gửi xe';

  @override
  String get kindToilet => 'Nhà vệ sinh';

  @override
  String get kindBusStop => 'Trạm xe buýt';

  @override
  String get nearbyPlacesTitle => 'Tiện ích quanh ga';

  @override
  String get stationShort => 'Ga';

  @override
  String get networkDiagram => 'Sơ đồ';

  @override
  String get diagramHint => 'Chạm vào ga để xem chi tiết';

  @override
  String get buyTicket => 'Mua vé';

  @override
  String get lineDiagram => 'Sơ đồ tuyến';

  @override
  String get newsTagOperation => 'Vận hành';

  @override
  String get newsTagNews => 'Tin tức';

  @override
  String get newsNotFound => 'Tin không còn tồn tại';

  @override
  String get stepChoose => 'Chọn vé';

  @override
  String get stepConfirm => 'Xác nhận';

  @override
  String get stepPay => 'Thanh toán';

  @override
  String singleTicketHint(String validity) {
    return 'Giá theo số ga · $validity';
  }

  @override
  String fromPrice(String price) {
    return 'từ $price';
  }

  @override
  String get ticketTypeTitle => 'Chọn loại vé';

  @override
  String get journeyTitle => 'Hành trình';

  @override
  String get chooseDifferentStations =>
      'Chọn ga đi và ga đến khác nhau để xem giá.';

  @override
  String get subtotal => 'Tạm tính';

  @override
  String copied(String value) {
    return 'Đã sao chép $value';
  }

  @override
  String get copy => 'Sao chép';

  @override
  String get scanVietQr => 'Quét mã VietQR';

  @override
  String get manualTransfer => 'Hoặc chuyển khoản thủ công';

  @override
  String get bank => 'Ngân hàng';

  @override
  String get accountNumber => 'Số tài khoản';

  @override
  String get accountName => 'Chủ tài khoản';

  @override
  String get transferContent => 'Nội dung';

  @override
  String get transferNote =>
      'Nhập đúng số tiền và nội dung để vé được xuất tự động.';

  @override
  String get transferNoteDemo =>
      'Bản demo: không chuyển tiền thật, đơn tự xác nhận sau vài giây.';

  @override
  String get paymentMethod => 'Phương thức thanh toán';

  @override
  String get methodVietQr => 'Chuyển khoản VietQR (SePay)';

  @override
  String get methodVietQrHint => 'Mọi ngân hàng, ví điện tử · xác nhận tự động';

  @override
  String get routeShort => 'Lộ trình';

  @override
  String get errBadCredentials => 'Email hoặc mật khẩu không đúng';

  @override
  String get errEmailNotVerified => 'Email chưa được xác thực';

  @override
  String get errRateLimited => 'Bạn thao tác quá nhanh, vui lòng thử lại sau';

  @override
  String get errLoginLocked =>
      'Bạn đã nhập sai quá nhiều lần, thử lại sau 15 phút';

  @override
  String get errCurrentPassword => 'Mật khẩu hiện tại không đúng';

  @override
  String get errEmailTaken => 'Email đã có người dùng';

  @override
  String get valNameLength => 'Họ tên tối đa 120 ký tự';

  @override
  String get valPasswordTooLong => 'Mật khẩu quá dài';

  @override
  String get valPasswordBlank => 'Mật khẩu không được toàn khoảng trắng';

  @override
  String get otpCode => 'Mã OTP';

  @override
  String otpSentIfExists(String email) {
    return 'Nếu $email đã đăng ký, mã 6 số đang tới hộp thư của bạn.';
  }

  @override
  String get emailVerifiedDone => 'Xác thực xong! Đăng nhập thôi.';

  @override
  String get registerPendingCode =>
      'Email này đang chờ xác thực. Hãy nhập mã đã gửi, mật khẩu vừa nhập chưa được lưu.';

  @override
  String get profileSaved => 'Futu lưu rồi nha!';

  @override
  String get saveProfile => 'Lưu thông tin';

  @override
  String get currentPassword => 'Mật khẩu hiện tại';

  @override
  String get changePassword => 'Đổi mật khẩu';

  @override
  String get changePasswordHint =>
      'Sau khi đổi, mọi thiết bị phải đăng nhập lại.';

  @override
  String get verifyNewEmailTitle => 'Xác nhận email mới';

  @override
  String get verifyNewEmailHint =>
      'Chưa nhận được mã? Quay lại và gửi yêu cầu đổi email lần nữa.';

  @override
  String get emailChangedRelogin =>
      'Đổi email thành công, hãy đăng nhập bằng email mới';

  @override
  String get passwordChangedRelogin => 'Đổi mật khẩu xong! Đăng nhập lại nha.';

  @override
  String get loginTwoFactorTitle => 'Xác nhận đăng nhập';

  @override
  String get twoFactorTitle => 'Xác nhận 2 lớp';

  @override
  String get twoFactorHint =>
      'Mỗi lần đăng nhập cần thêm mã gửi tới email của bạn.';

  @override
  String get twoFactorEnabledDone => 'Đã bật xác nhận 2 lớp';

  @override
  String get twoFactorDisabledDone => 'Đã tắt xác nhận 2 lớp';

  @override
  String get network3dTitle => 'Sơ đồ 3D';

  @override
  String get network3dOpen => 'Mở sơ đồ';

  @override
  String get network3dHint =>
      'Kéo để xoay, chụm hai ngón để phóng to, chạm ga để xem nha!';

  @override
  String get network3dReset => 'Về góc nhìn ban đầu';

  @override
  String get network2dMode => '2D';

  @override
  String get network3dMode => '3D';

  @override
  String get allLines => 'Tất cả';

  @override
  String get homeNextTicket => 'Vé sẵn sàng';

  @override
  String get homeParkingPass => 'Gửi xe';

  @override
  String get homeNoTicket => 'Chưa có vé';

  @override
  String get homeNoParking => 'Chưa gửi xe';

  @override
  String get vietnamMapLabel =>
      'Bản đồ Việt Nam, gồm quần đảo Hoàng Sa và quần đảo Trường Sa';

  @override
  String get hoangSaLabel => 'QĐ. Hoàng Sa';

  @override
  String get truongSaLabel => 'QĐ. Trường Sa';

  @override
  String get hcmcShort => 'TP.HCM';

  @override
  String get back => 'Quay lại';

  @override
  String get continueAction => 'Tiếp tục';

  @override
  String get exploreMapHint => 'Ga gần bạn, quanh ga, tàu đang chạy';

  @override
  String get exploreRouteHint => 'Tìm đường đi và giá vé';

  @override
  String get parkingBookTitle => 'Đặt chỗ gửi xe';

  @override
  String get parkingStepLot => 'Chọn bãi';

  @override
  String get parkingStepInfo => 'Thông tin';

  @override
  String get parkingChooseLot => 'Chọn bãi gửi';

  @override
  String get parkingAfterPay =>
      'Thanh toán xong bạn nhận QR. Đưa cho nhân viên khi vào và ra bãi.';

  @override
  String get parkingEntryTitle => 'Gửi xe tại ga';

  @override
  String get parkingEntryAction => 'Đặt chỗ';

  @override
  String get newPasswordIntro =>
      'Đặt mật khẩu mới trước nha, rồi Futu gửi mã 6 số qua email.';

  @override
  String get otpVerifyTitle => 'Xác thực OTP';

  @override
  String get mascotTipQr => 'Mở sẵn QR trước khi tới cổng nha!';

  @override
  String get mascotTipParking => 'Đặt chỗ gửi xe trước cho chắc nha!';

  @override
  String get mascotTipMap =>
      'Chạm một ga trên bản đồ để xem quanh đó có gì nè!';

  @override
  String get mascotLabel => 'Futu, chạm để xem mẹo khác';

  @override
  String get bookingHistory => 'Lịch sử đặt';

  @override
  String get noActiveTickets => 'Chưa có vé còn hiệu lực';

  @override
  String get noTicketHistory => 'Chưa có vé nào trong lịch sử';

  @override
  String get noParkingHistory => 'Chưa có lượt gửi xe nào đã kết thúc';

  @override
  String get forecastTitle => 'Độ đông hôm nay';

  @override
  String get forecastLevelLow => 'Vắng';

  @override
  String get forecastLevelMedium => 'Vừa';

  @override
  String get forecastLevelHigh => 'Đông';

  @override
  String get forecastRoadLow => 'thông thoáng';

  @override
  String get forecastRoadMedium => 'xe đông vừa';

  @override
  String get forecastRoadHigh => 'dễ kẹt xe';

  @override
  String forecastRoadLine(String status) {
    return 'Đường quanh ga: $status';
  }

  @override
  String forecastNowPeak(String time) {
    return 'Đang đông, thường đến $time';
  }

  @override
  String forecastNextPeak(String from, String to) {
    return 'Thường đông $from–$to';
  }

  @override
  String get forecastNoPeak => 'Hôm nay không còn giờ đông';

  @override
  String get forecastEstimate =>
      'Ước tính theo khung giờ và vị trí ga, chưa phải số đo thực tế.';

  @override
  String forecastTipNow(String station, String time) {
    return 'Ga $station đang đông, thường tới $time mới vãn nha.';
  }

  @override
  String forecastTipBefore(String time, String station) {
    return 'Đi trước $time để tránh giờ đông ở ga $station nha.';
  }

  @override
  String get forecastMapChip => 'Độ đông';

  @override
  String get studentTakePhoto => 'Chụp thẻ';

  @override
  String get studentChoosePhoto => 'Chọn ảnh';

  @override
  String get studentRetake => 'Chụp lại';

  @override
  String get studentConsent =>
      'Mình đồng ý gửi ảnh thẻ để AI đọc thông tin. Ảnh chỉ dùng để xác thực và được xóa sau khi có kết quả.';

  @override
  String get studentPickFailed =>
      'Chưa mở được camera hoặc thư viện ảnh. Kiểm tra quyền truy cập rồi thử lại nha.';

  @override
  String get studentFieldName => 'Họ tên';

  @override
  String get studentFieldSchool => 'Trường';

  @override
  String get studentFieldCode => 'Mã sinh viên';

  @override
  String get studentDemoLabel => 'Kết quả demo:';

  @override
  String get studentDemoPass => 'Đạt';

  @override
  String get studentVerifyTitle => 'Xác nhận sinh viên';

  @override
  String get studentTip =>
      'Chụp mặt trước thẻ sinh viên, thấy rõ họ tên, trường và hạn thẻ nha.';

  @override
  String get studentCheck => 'Gửi duyệt';

  @override
  String get studentVerified => 'Đã xác nhận sinh viên';

  @override
  String studentValidUntil(String date) {
    return 'Hiệu lực đến $date';
  }

  @override
  String get studentBenefitSingle => 'Giảm 20% vé lượt';

  @override
  String get studentBenefitMonth => 'Mua được vé tháng HSSV';

  @override
  String get studentRenewNote => 'Mỗi năm xác nhận lại một lần để giữ ưu đãi.';

  @override
  String studentRenewSoon(int days) {
    return 'Còn $days ngày, xác nhận lại sớm để không gián đoạn ưu đãi';
  }

  @override
  String get studentRenew => 'Xác nhận lại';

  @override
  String get studentWaitTitle => 'Duyệt thẻ có thể mất đến 24 giờ';

  @override
  String get studentWaitBody =>
      'Nên xác nhận trước khi cần đi. Đi gấp thì mua vé ngày giá thường để lên tàu ngay; giá sinh viên áp dụng cho vé mua sau khi được duyệt.';

  @override
  String get studentBuyDay => 'Mua vé ngày';

  @override
  String get studentPendingTitle => 'Đang duyệt thẻ của bạn';

  @override
  String get studentPendingBody =>
      'Bạn không cần chờ ở đây. HopOn sẽ báo khi có kết quả.';

  @override
  String studentSubmittedAt(String time) {
    return 'Đã gửi lúc $time';
  }

  @override
  String studentStillActive(String date) {
    return 'Ưu đãi hiện tại vẫn dùng được đến $date';
  }

  @override
  String get studentDone => 'Xong';

  @override
  String get studentCardNone => 'Giảm 20% vé lượt, mua được vé tháng HSSV';

  @override
  String get studentCardPending => 'Đang duyệt, HopOn sẽ báo khi có kết quả';

  @override
  String get studentCardRejected => 'Chưa đạt, chạm để xem lý do và gửi lại';

  @override
  String get studentCardExpired =>
      'Đã hết hiệu lực, xác nhận lại để giữ ưu đãi';

  @override
  String get studentNoticeNeeded =>
      'Vé này cần xác nhận sinh viên, việc duyệt có thể mất đến 24 giờ.';

  @override
  String get studentNoticePending =>
      'Thẻ của bạn đang được duyệt. Cần đi ngay thì mua vé ngày trước nha.';

  @override
  String get studentConfirmAction => 'Xác nhận ngay';

  @override
  String get studentUseDay => 'Chọn vé ngày';

  @override
  String get studentDemoExpiring => 'Sắp hết hạn';

  @override
  String get studentDemoExpired => 'Hết hạn';

  @override
  String get studentDemoFail => 'Từ chối';

  @override
  String get chatFutuTitle =>
      'Mình là Futu! Hỏi mình về vé, giờ tàu, lộ trình, hoặc chọn nhanh bên dưới nha.';

  @override
  String get ticketLimitTitle => 'Bạn vẫn còn vé hiệu lực';

  @override
  String ticketLimitBody(String ticket, String time) {
    return '$ticket dùng được đến $time. Khi vé này hết hạn hoặc đã dùng xong, bạn mới mua được vé mới.';
  }

  @override
  String get ticketLimitOpen => 'Mở vé đang có';

  @override
  String get ticketLimitDemo => 'Demo: tạm bỏ ràng buộc';

  @override
  String shiftLine(String shift) {
    return 'Ca $shift';
  }

  @override
  String staffOnDuty(int count) {
    return '$count nhân viên tại ga';
  }

  @override
  String staffOnDutyLimit(int count, int limit) {
    return '$count/$limit nhân viên tại ga';
  }

  @override
  String get scanHintEntry => 'VÀO GA · Đưa mã QR vào khung';

  @override
  String get scanHintExit => 'RA GA · Đưa mã QR vào khung';

  @override
  String lotFree(String count) {
    return 'Còn $count chỗ';
  }

  @override
  String get staffFieldStation => 'Ga';

  @override
  String get staffFieldShift => 'Ca làm';

  @override
  String get staffFieldLot => 'Bãi xe';

  @override
  String get staffFieldTeam => 'Nhân sự';

  @override
  String get cameraOffTitle => 'Camera đang tắt';

  @override
  String get cameraOffBody =>
      'Bật khi cần quét mã QR. Camera tự tắt khi bạn rời màn này. Không bật vẫn nhập mã thủ công được.';

  @override
  String get cameraTurnOn => 'Bật camera';

  @override
  String get cameraTurnOff => 'Tắt camera';

  @override
  String get incidentListTitle => 'Sự cố tại ga';

  @override
  String get incidentReport => 'Báo sự cố';

  @override
  String get incidentTabOpen => 'Đang mở';

  @override
  String get incidentEmpty => 'Không có sự cố nào';

  @override
  String get incidentDetailTitle => 'Chi tiết sự cố';

  @override
  String get incidentNotFound => 'Không tìm thấy sự cố';

  @override
  String get incidentHistory => 'Lịch sử xử lý';

  @override
  String incidentReported(String name) {
    return '$name báo sự cố';
  }

  @override
  String get incidentSent => 'Đã gửi báo cáo sự cố!';

  @override
  String get incidentSend => 'Gửi báo cáo';

  @override
  String get incidentFieldType => 'Loại sự cố';

  @override
  String get incidentFieldLocation => 'Vị trí';

  @override
  String get incidentFieldSeverity => 'Mức độ';

  @override
  String get incidentFieldDescription => 'Mô tả thêm (không bắt buộc)';

  @override
  String get incidentFieldDescriptionRequired => 'Mô tả sự cố (bắt buộc)';

  @override
  String incidentDuplicate(String id) {
    return 'Ga đang có $id cùng loại chưa xử lý xong. Kiểm tra để tránh báo trùng, vẫn gửi được nếu là sự cố khác.';
  }

  @override
  String get incidentEmergencyNote =>
      'App chỉ ghi nhận sự cố. Nếu có nguy hiểm, hãy gọi cứu hộ hoặc an ninh ngay.';

  @override
  String incidentPhotosTitle(int count, int max) {
    return 'Ảnh ($count/$max, không bắt buộc)';
  }

  @override
  String get incidentPhotosPrivacy =>
      'Tránh chụp rõ mặt hành khách. Hành khách không thấy các ảnh này.';

  @override
  String get incidentPhotoRemove => 'Xóa ảnh';

  @override
  String get incidentTakePhoto => 'Chụp ảnh';

  @override
  String get incidentPropose => 'Đề xuất báo hành khách';

  @override
  String get incidentProposeHint =>
      'Quản trị viên duyệt rồi mới hiện trên Trang chủ của hành khách.';

  @override
  String get incidentPublishPending => 'Đề xuất báo hành khách, đang chờ duyệt';

  @override
  String get incidentPublished => 'Đã được duyệt, đang hiện cho hành khách';

  @override
  String get incidentTypeGate => 'Cổng soát vé';

  @override
  String get incidentTypeLift => 'Thang cuốn, thang máy';

  @override
  String get incidentTypeEquipment => 'Thiết bị khác';

  @override
  String get incidentTypeHygiene => 'Vệ sinh';

  @override
  String get incidentTypeSecurity => 'An ninh';

  @override
  String get incidentTypeMedical => 'Y tế';

  @override
  String get incidentTypeParking => 'Bãi xe';

  @override
  String get incidentTypeOther => 'Khác';

  @override
  String get incidentLocEntry => 'Cổng vào';

  @override
  String get incidentLocExit => 'Cổng ra';

  @override
  String get incidentLocConcourse => 'Sảnh';

  @override
  String get incidentLocPlatform => 'Sân ga';

  @override
  String get incidentLocParking => 'Bãi xe';

  @override
  String get incidentLocOther => 'Nơi khác';

  @override
  String get incidentSevMinor => 'Nhẹ';

  @override
  String get incidentSevOperations => 'Ảnh hưởng vận hành';

  @override
  String get incidentSevEmergency => 'Khẩn cấp';

  @override
  String get incidentStatusOpen => 'Mới';

  @override
  String get incidentStatusProgress => 'Đang xử lý';

  @override
  String get incidentStatusResolved => 'Đã xử lý';

  @override
  String get greenTitle => 'Hành trình xanh';

  @override
  String get cpointScaleTitle => 'Ưu đãi theo CPoint';

  @override
  String cpointAmount(String amount) {
    return '$amount CPoint';
  }

  @override
  String cpointDiscount(String amount, int percent) {
    return '$amount · Giảm $percent% mọi vé';
  }

  @override
  String cpointRule(int perKg) {
    return 'Mỗi 1 kg CO₂ bớt được = $perKg CPoint. Giảm tự động khi thanh toán, CPoint không bị trừ.';
  }

  @override
  String get greenFutuStart => 'Đi chuyến đầu tiên để Trái Đất xanh hơn nha!';

  @override
  String greenFutuNext(String kg, String tier) {
    return 'Còn $kg kg nữa là lên cấp $tier đó!';
  }

  @override
  String get greenFutuTop => 'Cấp cao nhất rồi! Trái Đất cảm ơn bạn nha.';

  @override
  String get greenFutuTipCount =>
      'Mỗi vé lượt đi xong được cộng CO₂ đã bớt và CPoint.';

  @override
  String get greenFutuTipSpin => 'Kéo Trái Đất sang ngang để xoay thử nha!';

  @override
  String get greenEarthLabel => 'Mô hình Trái Đất, kéo ngang để xoay';

  @override
  String get greenEmpty => 'Chưa có chuyến nào';

  @override
  String greenSavedKg(Object kg) {
    return '≈ $kg kg CO₂';
  }

  @override
  String greenSummaryLine(Object trips, Object km) {
    return '$trips chuyến · $km km';
  }

  @override
  String get greenTierSeed => 'Hạt mầm';

  @override
  String get greenTierSprout => 'Chồi non';

  @override
  String get greenTierTree => 'Cây xanh';

  @override
  String get greenTierForest => 'Khu rừng';

  @override
  String get greenCalculatorTitle => 'So sánh quãng đường';

  @override
  String get greenNoRoute => 'Hai ga này chưa có lộ trình để tính.';

  @override
  String greenDistance(Object km) {
    return '≈ $km km';
  }

  @override
  String get greenModeCar => 'Ô tô';

  @override
  String get greenModeMotorbike => 'Xe máy';

  @override
  String get greenModeMetro => 'Metro';

  @override
  String greenKg(Object kg) {
    return '$kg kg CO₂';
  }

  @override
  String get greenMethodTitle => 'Cách tính';

  @override
  String get greenFormula => 'Quãng đường × (xe máy − Metro)';

  @override
  String get greenFactors =>
      'Mỗi km một người: ô tô 0,101 kg · xe máy 0,062 kg · Metro 0,034 kg';

  @override
  String get greenDisclaimer => 'Số ước tính, chỉ tính vé lượt đã đi xong.';

  @override
  String trainsLive(Object count) {
    return '$count tàu đang chạy';
  }

  @override
  String trainsSimulated(Object count) {
    return '$count tàu · mô phỏng';
  }

  @override
  String nextTrainIn(Object eta) {
    return 'Tàu tới sau $eta';
  }

  @override
  String mascotExpiring(Object name, Object hours) {
    return 'Ôi! $name còn $hours giờ là hết hạn đó.';
  }

  @override
  String mascotExpiringSoon(Object name) {
    return 'Ôi! $name sắp hết hạn trong chưa đầy 1 giờ.';
  }

  @override
  String mascotTierUp(Object tier) {
    return 'Tuyệt quá! Bạn lên $tier rồi!';
  }

  @override
  String get greenShare => 'Chia sẻ thành tích';

  @override
  String get greenShareTitle => 'Thẻ thành tích xanh';

  @override
  String get greenShareMonth => 'Tháng này mình đã bớt';

  @override
  String get greenShareTotal => 'Mình đã bớt';

  @override
  String get greenShareBy => 'nhờ đi Metro thay vì xe máy';

  @override
  String greenShareStats(Object trips, Object km, Object days) {
    return '$trips chuyến · $km km · $days ngày hấp thụ CO₂ của một cây';
  }

  @override
  String get greenShareEstimate => 'Số ước tính từ app HopOn';

  @override
  String greenShareText(Object kg) {
    return 'Mình đã bớt $kg kg CO₂ nhờ đi Metro cùng HopOn. Đi cùng mình nhé!';
  }

  @override
  String get greenShareFailed => 'Chưa chia sẻ được, vui lòng thử lại';

  @override
  String get mascotPaidTicket => 'Xong rồi nè! Mở QR là lên tàu thôi.';

  @override
  String get mascotPaidParking =>
      'Xong rồi nè! Futu giữ chỗ cho xe của bạn rồi.';

  @override
  String get mascotPaidFailed =>
      'Ui, chưa thanh toán được. Bạn chưa bị trừ tiền đâu.';

  @override
  String get mascotPaidRefund => 'Futu đang xử lý hoàn tiền, đợi chút nha.';

  @override
  String get mascotParkingLot => 'Chọn loại xe và bãi trước nha.';

  @override
  String get mascotParkingInfo => 'Nhập biển số và chọn gói nha.';

  @override
  String get mascotParkingConfirm => 'Xem lại lần cuối rồi thanh toán nha!';

  @override
  String get mascotBookingChoose => 'Chọn loại vé và hai ga nha!';

  @override
  String get mascotBookingConfirm => 'Xem lại vé và ưu đãi nha.';

  @override
  String get mascotRegister => 'Điền vài thông tin, Futu gửi mã qua email nha.';

  @override
  String greenBookedTrip(Object kg) {
    return 'Chuyến này ≈ $kg kg CO₂, cộng khi đi xong';
  }

  @override
  String greenBookedPass(Object kg) {
    return 'Mỗi 10 km ≈ $kg kg CO₂';
  }

  @override
  String greenBookedParking(Object kg) {
    return 'Gửi xe rồi đi Metro: mỗi 10 km ≈ $kg kg CO₂';
  }

  @override
  String greenNextTier(Object tier, Object kg) {
    return '$tier · còn $kg kg lên cấp';
  }

  @override
  String futuMorning(Object name) {
    return 'Sáng rồi $name ơi! Mình đi đâu đây?';
  }

  @override
  String futuAfternoon(Object name) {
    return 'Chiều vui nha $name! Đi đâu nè?';
  }

  @override
  String futuEvening(Object name) {
    return 'Tối rồi $name ơi, về nhà thôi!';
  }

  @override
  String futuLoginTitle(Object name) {
    return '$name về rồi!';
  }

  @override
  String get futuLoginBody => 'Futu vui quá, lên tàu thôi nào!';

  @override
  String get futuLogoutTitle => 'Đi thật hả?';

  @override
  String get futuLogoutBody => 'Futu sẽ nhớ bạn lắm đó...';

  @override
  String get greenCompared => 'bớt được so với đi xe máy';

  @override
  String greenTierProgress(Object kg, Object target) {
    return '$kg / $target kg';
  }

  @override
  String get greenStatTrips => 'chuyến';

  @override
  String get greenStatKm => 'km';

  @override
  String get greenStatTreeDays => 'ngày cây hấp thụ';

  @override
  String greenTripSaved(Object kg) {
    return 'Đi Metro bớt $kg kg so với xe máy';
  }

  @override
  String greenTrain(Object bikes) {
    return '1 đoàn tàu ≈ $bikes xe máy khỏi ra đường';
  }
}
