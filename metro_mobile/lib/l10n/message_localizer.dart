import 'package:metro_mobile/l10n/gen/app_localizations.dart';

/// Dịch thông điệp lỗi do domain / validator / Fake source tạo (tiếng Việt,
/// đóng vai thông điệp backend). Thông điệp lạ, VD backend thật đã dịch sẵn,
/// được giữ nguyên.
String localizeMessage(AppLocalizations l, String message) {
  final exact = switch (message) {
    'Không có kết nối mạng' => l.errNetwork,
    'Sai thông tin đăng nhập' => l.errUnauthorized,
    'Bạn không có quyền thực hiện' => l.errForbidden,
    'Không tìm thấy dữ liệu' => l.errNotFound,
    'Dữ liệu đã thay đổi' => l.errConflict,
    'Dữ liệu không hợp lệ' => l.errValidation,
    'Hệ thống đang bận, thử lại sau' => l.errServer,
    'Tài khoản đã bị khóa' => l.errAccountLocked,
    'Vui lòng nhập email hoặc số điện thoại' => l.valIdentifierRequired,
    'Email hoặc số điện thoại không hợp lệ' => l.valIdentifierInvalid,
    'Vui lòng nhập email' => l.valEmailRequired,
    'Email không hợp lệ' => l.valEmailInvalid,
    'Mật khẩu tối thiểu 8 ký tự' => l.valPasswordLength,
    'Mật khẩu cần có cả chữ và số' => l.valPasswordMix,
    'Mật khẩu nhập lại không khớp' => l.valPasswordMismatch,
    'Vui lòng nhập mật khẩu' => l.valPasswordRequired,
    'Vui lòng nhập họ tên' => l.valNameRequired,
    'Vui lòng đồng ý điều khoản sử dụng' => l.valTermsRequired,
    'Mã OTP gồm 6 chữ số' => l.valOtpFormat,
    'Mã OTP không hợp lệ' => l.errOtpInvalid,
    'Email chưa được đăng ký' => l.errEmailNotRegistered,
    'Tài khoản đã tồn tại' => l.errAccountExists,
    'Phiên đặt lại mật khẩu đã hết hạn' => l.errResetExpired,
    'Vui lòng nhập câu hỏi' => l.valQuestionRequired,
    'Câu hỏi tối đa 300 ký tự' => l.valQuestionLength,
    'Vui lòng chọn ga đi và ga đến' => l.valStationsRequired,
    'Ga đi và ga đến trùng nhau' => l.valStationsSame,
    'Không tìm thấy ga' => l.errStationNotFound,
    'Không tìm thấy lộ trình phù hợp' => l.errRouteNotFound,
    'Không tìm thấy đơn' => l.errOrderNotFound,
    'Không tìm thấy vé' => l.errTicketNotFound,
    'Không tìm thấy lượt gửi xe' => l.errParkingNotFound,
    'Lượt gửi xe thuộc bãi khác' => l.errParkingOtherLot,
    'Không tìm thấy bãi xe' => l.errLotNotFound,
    'Xe đang có lượt gửi còn hiệu lực' => l.errParkingActive,
    'Loại giữ xe đã hết chỗ' => l.errParkingFull,
    'Vui lòng nhập biển số' => l.valPlateRequired,
    'Biển số không đúng định dạng' => l.valPlateInvalid,
    'Mã QR không đúng loại' => l.errQrWrongKind,
    'Không thể tắt thông báo bắt buộc' => l.errMandatoryNotification,
    'Thông báo vận hành và kết quả thanh toán là bắt buộc' =>
      l.errMandatoryNotificationKinds,
    'Không đọc được mã QR. Quét lại' => l.errQrUnreadable,
    'Vé hết hạn' => l.rejectExpired,
    'Vé đã được sử dụng' => l.rejectUsed,
    'Vé đã được check-in' => l.rejectAlreadyIn,
    'Vé chưa check-in vào ga' => l.rejectNotIn,
    'Check-out sai ga' => l.rejectWrongStation,
    'Vé không tồn tại' => l.rejectNotFound,
    'Bạn chỉ được soát vé tại ga được phân công' => l.rejectForbidden,
    _ => null,
  };
  if (exact != null) return exact;
  final inactive = RegExp(r'^Ga (.+) chưa hoạt động$').firstMatch(message);
  if (inactive != null) return l.errStationInactive(inactive.group(1)!);
  return message;
}
