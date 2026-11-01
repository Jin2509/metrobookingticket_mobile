// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

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
  String get menuLoyalty => 'Thành viên & ưu đãi';

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
      'Nhập email đã đăng ký, chúng tôi sẽ gửi mã 6 số để đặt lại mật khẩu.';

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
  String get resetPasswordDone => 'Đổi mật khẩu thành công, hãy đăng nhập';

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
  String get tagline => 'Đi metro, nhẹ nhàng hơn';

  @override
  String resendCodeIn(int seconds) {
    return 'Gửi lại mã (sau ${seconds}s)';
  }

  @override
  String get resendCode => 'Gửi lại mã';

  @override
  String get otpResent => 'Đã gửi lại mã OTP';

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
    return 'Hạng $tier · $points điểm';
  }

  @override
  String get greeting => 'Xin chào,';

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
      'Giá đã gồm VAT. Ưu đãi và giảm theo hạng được trừ khi thanh toán.';

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
  String get paymentSuccessTicket => 'Vé đã sẵn sàng. Mở QR để vào ga.';

  @override
  String get paymentSuccessParking =>
      'Đưa QR gửi xe cho nhân viên bãi khi gửi và lấy xe.';

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
  String get metroLines => 'Các tuyến metro';

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
  String get assistantTitle => 'Trợ lý Metro';

  @override
  String get newSession => 'Phiên mới';

  @override
  String get assistantTyping => 'Trợ lý đang trả lời…';

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
    return 'Nếu $email đã đăng ký, bạn sẽ nhận được mã 6 số qua email.';
  }

  @override
  String get emailVerifiedDone => 'Xác thực email thành công, hãy đăng nhập';

  @override
  String get registerPendingCode =>
      'Email này đang chờ xác thực. Hãy nhập mã đã gửi, mật khẩu vừa nhập chưa được lưu.';

  @override
  String get profileSaved => 'Đã lưu thông tin';

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
  String get passwordChangedRelogin =>
      'Đổi mật khẩu thành công, hãy đăng nhập lại';

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
}
