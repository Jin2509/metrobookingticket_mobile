import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appSlogan.
  ///
  /// In vi, this message translates to:
  /// **'Kỷ nguyên mới, chuyển động mới'**
  String get appSlogan;

  /// No description provided for @navHome.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get navHome;

  /// No description provided for @navExplore.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá'**
  String get navExplore;

  /// No description provided for @navTickets.
  ///
  /// In vi, this message translates to:
  /// **'Vé'**
  String get navTickets;

  /// No description provided for @navAccount.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get navAccount;

  /// No description provided for @navScan.
  ///
  /// In vi, this message translates to:
  /// **'Soát vé'**
  String get navScan;

  /// No description provided for @navParking.
  ///
  /// In vi, this message translates to:
  /// **'Gửi xe'**
  String get navParking;

  /// No description provided for @navHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử'**
  String get navHistory;

  /// No description provided for @accountTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get accountTitle;

  /// No description provided for @rolePassenger.
  ///
  /// In vi, this message translates to:
  /// **'Hành khách'**
  String get rolePassenger;

  /// No description provided for @roleStaff.
  ///
  /// In vi, this message translates to:
  /// **'Nhân viên soát vé'**
  String get roleStaff;

  /// No description provided for @menuProfile.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ cá nhân'**
  String get menuProfile;

  /// No description provided for @menuTransactions.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử giao dịch'**
  String get menuTransactions;

  /// No description provided for @menuLoyalty.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên'**
  String get menuLoyalty;

  /// No description provided for @menuNotificationSettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt thông báo'**
  String get menuNotificationSettings;

  /// No description provided for @menuNews.
  ///
  /// In vi, this message translates to:
  /// **'Tin tức Metro'**
  String get menuNews;

  /// No description provided for @menuStaffProfile.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ nhân viên'**
  String get menuStaffProfile;

  /// No description provided for @menuStation.
  ///
  /// In vi, this message translates to:
  /// **'Ga được phân công'**
  String get menuStation;

  /// No description provided for @comingSoon.
  ///
  /// In vi, this message translates to:
  /// **'{item} đang phát triển'**
  String comingSoon(String item);

  /// No description provided for @settingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt ứng dụng'**
  String get settingsTitle;

  /// No description provided for @appearance.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện'**
  String get appearance;

  /// No description provided for @appearanceSystem.
  ///
  /// In vi, this message translates to:
  /// **'Theo hệ thống'**
  String get appearanceSystem;

  /// No description provided for @appearanceLight.
  ///
  /// In vi, this message translates to:
  /// **'Sáng'**
  String get appearanceLight;

  /// No description provided for @appearanceDark.
  ///
  /// In vi, this message translates to:
  /// **'Tối'**
  String get appearanceDark;

  /// No description provided for @language.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get language;

  /// No description provided for @logout.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất?'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmBody.
  ///
  /// In vi, this message translates to:
  /// **'Bạn sẽ cần đăng nhập lại để tiếp tục sử dụng.'**
  String get logoutConfirmBody;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get cancel;

  /// No description provided for @unsupportedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng dùng trang quản trị web'**
  String get unsupportedTitle;

  /// No description provided for @unsupportedBody.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản này không thao tác trên ứng dụng di động. Hãy đăng nhập trang quản trị Metro trên máy tính.'**
  String get unsupportedBody;

  /// No description provided for @placeholderTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đang phát triển'**
  String get placeholderTitle;

  /// No description provided for @placeholderBody.
  ///
  /// In vi, this message translates to:
  /// **'Màn hình này thuộc giai đoạn {phase}.'**
  String placeholderBody(int phase);

  /// No description provided for @errNetwork.
  ///
  /// In vi, this message translates to:
  /// **'Không có kết nối mạng'**
  String get errNetwork;

  /// No description provided for @errUnauthorized.
  ///
  /// In vi, this message translates to:
  /// **'Sai thông tin đăng nhập'**
  String get errUnauthorized;

  /// No description provided for @errForbidden.
  ///
  /// In vi, this message translates to:
  /// **'Bạn không có quyền thực hiện'**
  String get errForbidden;

  /// No description provided for @errNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy dữ liệu'**
  String get errNotFound;

  /// No description provided for @errConflict.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu đã thay đổi'**
  String get errConflict;

  /// No description provided for @errValidation.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu không hợp lệ'**
  String get errValidation;

  /// No description provided for @errServer.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống đang bận, thử lại sau'**
  String get errServer;

  /// No description provided for @errAccountLocked.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản đã bị khóa'**
  String get errAccountLocked;

  /// No description provided for @valEmailRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập email'**
  String get valEmailRequired;

  /// No description provided for @valEmailInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Email không hợp lệ'**
  String get valEmailInvalid;

  /// No description provided for @valPasswordLength.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu tối thiểu 8 ký tự'**
  String get valPasswordLength;

  /// No description provided for @valPasswordMismatch.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu nhập lại không khớp'**
  String get valPasswordMismatch;

  /// No description provided for @valPasswordRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mật khẩu'**
  String get valPasswordRequired;

  /// No description provided for @valNameRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập họ tên'**
  String get valNameRequired;

  /// No description provided for @valTermsRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng đồng ý điều khoản sử dụng'**
  String get valTermsRequired;

  /// No description provided for @valOtpFormat.
  ///
  /// In vi, this message translates to:
  /// **'Mã OTP gồm 6 chữ số'**
  String get valOtpFormat;

  /// No description provided for @errOtpInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Mã OTP không hợp lệ'**
  String get errOtpInvalid;

  /// No description provided for @errAccountExists.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản đã tồn tại'**
  String get errAccountExists;

  /// No description provided for @valQuestionRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập câu hỏi'**
  String get valQuestionRequired;

  /// No description provided for @valQuestionLength.
  ///
  /// In vi, this message translates to:
  /// **'Câu hỏi tối đa 300 ký tự'**
  String get valQuestionLength;

  /// No description provided for @valStationsRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn ga đi và ga đến'**
  String get valStationsRequired;

  /// No description provided for @valStationsSame.
  ///
  /// In vi, this message translates to:
  /// **'Ga đi và ga đến trùng nhau'**
  String get valStationsSame;

  /// No description provided for @errStationNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy ga'**
  String get errStationNotFound;

  /// No description provided for @errRouteNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy lộ trình phù hợp'**
  String get errRouteNotFound;

  /// No description provided for @errOrderNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy đơn'**
  String get errOrderNotFound;

  /// No description provided for @errTicketNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy vé'**
  String get errTicketNotFound;

  /// No description provided for @errParkingNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy lượt gửi xe'**
  String get errParkingNotFound;

  /// No description provided for @errParkingOtherLot.
  ///
  /// In vi, this message translates to:
  /// **'Lượt gửi xe thuộc bãi khác'**
  String get errParkingOtherLot;

  /// No description provided for @errLotNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy bãi xe'**
  String get errLotNotFound;

  /// No description provided for @errParkingActive.
  ///
  /// In vi, this message translates to:
  /// **'Xe đang có lượt gửi còn hiệu lực'**
  String get errParkingActive;

  /// No description provided for @errParkingFull.
  ///
  /// In vi, this message translates to:
  /// **'Loại giữ xe đã hết chỗ'**
  String get errParkingFull;

  /// No description provided for @valPlateRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập biển số'**
  String get valPlateRequired;

  /// No description provided for @valPlateInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Biển số không đúng định dạng'**
  String get valPlateInvalid;

  /// No description provided for @errQrWrongKind.
  ///
  /// In vi, this message translates to:
  /// **'Mã QR không đúng loại'**
  String get errQrWrongKind;

  /// No description provided for @errMandatoryNotification.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tắt thông báo bắt buộc'**
  String get errMandatoryNotification;

  /// No description provided for @errMandatoryNotificationKinds.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo vận hành và kết quả thanh toán là bắt buộc'**
  String get errMandatoryNotificationKinds;

  /// No description provided for @errStationInactive.
  ///
  /// In vi, this message translates to:
  /// **'Ga {name} chưa hoạt động'**
  String errStationInactive(String name);

  /// No description provided for @notSelected.
  ///
  /// In vi, this message translates to:
  /// **'chưa chọn'**
  String get notSelected;

  /// No description provided for @chooseStation.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ga'**
  String get chooseStation;

  /// No description provided for @liveConnected.
  ///
  /// In vi, this message translates to:
  /// **'Trực tiếp'**
  String get liveConnected;

  /// No description provided for @liveReconnecting.
  ///
  /// In vi, this message translates to:
  /// **'Đang kết nối lại…'**
  String get liveReconnecting;

  /// No description provided for @loadFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được dữ liệu'**
  String get loadFailed;

  /// No description provided for @errorTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã có lỗi xảy ra'**
  String get errorTitle;

  /// No description provided for @retry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get retry;

  /// No description provided for @interchangeStation.
  ///
  /// In vi, this message translates to:
  /// **'Ga chuyển tuyến'**
  String get interchangeStation;

  /// No description provided for @stationClosed.
  ///
  /// In vi, this message translates to:
  /// **'Ngừng hoạt động'**
  String get stationClosed;

  /// No description provided for @sinceTime.
  ///
  /// In vi, this message translates to:
  /// **'Từ {time}'**
  String sinceTime(String time);

  /// No description provided for @feedbackHelpful.
  ///
  /// In vi, this message translates to:
  /// **'Hữu ích'**
  String get feedbackHelpful;

  /// No description provided for @feedbackNotHelpful.
  ///
  /// In vi, this message translates to:
  /// **'Chưa hữu ích'**
  String get feedbackNotHelpful;

  /// No description provided for @routeMinutesApprox.
  ///
  /// In vi, this message translates to:
  /// **'~{minutes} phút'**
  String routeMinutesApprox(int minutes);

  /// No description provided for @stationCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} ga'**
  String stationCount(int count);

  /// No description provided for @transferCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} lần chuyển'**
  String transferCount(int count);

  /// No description provided for @validUntilShort.
  ///
  /// In vi, this message translates to:
  /// **'Hạn {date}'**
  String validUntilShort(String date);

  /// No description provided for @openQr.
  ///
  /// In vi, this message translates to:
  /// **'Mở QR'**
  String get openQr;

  /// No description provided for @details.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết'**
  String get details;

  /// No description provided for @fromTo.
  ///
  /// In vi, this message translates to:
  /// **'{from} đến {to}'**
  String fromTo(String from, String to);

  /// No description provided for @timeLeft.
  ///
  /// In vi, this message translates to:
  /// **'Còn {time}'**
  String timeLeft(String time);

  /// No description provided for @stationSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm ga, VD: ben thanh'**
  String get stationSearchHint;

  /// No description provided for @stationSearchEmptyHint.
  ///
  /// In vi, this message translates to:
  /// **'Thử gõ tên khác, VD \"suoi tien\"'**
  String get stationSearchEmptyHint;

  /// No description provided for @recent.
  ///
  /// In vi, this message translates to:
  /// **'Gần đây'**
  String get recent;

  /// No description provided for @loading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải'**
  String get loading;

  /// No description provided for @password.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get password;

  /// No description provided for @showPassword.
  ///
  /// In vi, this message translates to:
  /// **'Hiện mật khẩu'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn mật khẩu'**
  String get hidePassword;

  /// No description provided for @torchOn.
  ///
  /// In vi, this message translates to:
  /// **'Bật đèn'**
  String get torchOn;

  /// No description provided for @torchOff.
  ///
  /// In vi, this message translates to:
  /// **'Tắt đèn'**
  String get torchOff;

  /// No description provided for @newCode.
  ///
  /// In vi, this message translates to:
  /// **'Tạo mã mới'**
  String get newCode;

  /// No description provided for @codeExpired.
  ///
  /// In vi, this message translates to:
  /// **'Mã đã hết hạn'**
  String get codeExpired;

  /// No description provided for @paymentScanHint.
  ///
  /// In vi, this message translates to:
  /// **'Quét bằng ứng dụng ngân hàng hoặc ví bất kỳ'**
  String get paymentScanHint;

  /// No description provided for @amount.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền'**
  String get amount;

  /// No description provided for @orderCode.
  ///
  /// In vi, this message translates to:
  /// **'Mã đơn'**
  String get orderCode;

  /// No description provided for @cancelTransaction.
  ///
  /// In vi, this message translates to:
  /// **'Hủy giao dịch'**
  String get cancelTransaction;

  /// No description provided for @paymentWaiting.
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ xác nhận thanh toán…'**
  String get paymentWaiting;

  /// No description provided for @trainLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tàu {id}'**
  String trainLabel(String id);

  /// No description provided for @checking.
  ///
  /// In vi, this message translates to:
  /// **'Đang kiểm tra…'**
  String get checking;

  /// No description provided for @scanHint.
  ///
  /// In vi, this message translates to:
  /// **'Đưa mã QR vào khung'**
  String get scanHint;

  /// No description provided for @yourLocation.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí của bạn'**
  String get yourLocation;

  /// No description provided for @busStopLabel.
  ///
  /// In vi, this message translates to:
  /// **'Trạm buýt {name}'**
  String busStopLabel(String name);

  /// No description provided for @ticketInactive.
  ///
  /// In vi, this message translates to:
  /// **'Vé không còn hiệu lực'**
  String get ticketInactive;

  /// No description provided for @qrCode.
  ///
  /// In vi, this message translates to:
  /// **'Mã QR'**
  String get qrCode;

  /// No description provided for @trainApproaching.
  ///
  /// In vi, this message translates to:
  /// **'Tàu đang tới'**
  String get trainApproaching;

  /// No description provided for @refreshIn.
  ///
  /// In vi, this message translates to:
  /// **'Làm mới sau {time}'**
  String refreshIn(String time);

  /// No description provided for @vehicleMotorbike.
  ///
  /// In vi, this message translates to:
  /// **'Xe máy'**
  String get vehicleMotorbike;

  /// No description provided for @vehicleBicycle.
  ///
  /// In vi, this message translates to:
  /// **'Xe đạp'**
  String get vehicleBicycle;

  /// No description provided for @vehicleCar.
  ///
  /// In vi, this message translates to:
  /// **'Ô tô'**
  String get vehicleCar;

  /// No description provided for @strengthWeak.
  ///
  /// In vi, this message translates to:
  /// **'Yếu'**
  String get strengthWeak;

  /// No description provided for @strengthFair.
  ///
  /// In vi, this message translates to:
  /// **'Trung bình'**
  String get strengthFair;

  /// No description provided for @strengthGood.
  ///
  /// In vi, this message translates to:
  /// **'Mạnh vừa'**
  String get strengthGood;

  /// No description provided for @strengthStrong.
  ///
  /// In vi, this message translates to:
  /// **'Mạnh'**
  String get strengthStrong;

  /// No description provided for @statusActive.
  ///
  /// In vi, this message translates to:
  /// **'Hoạt động'**
  String get statusActive;

  /// No description provided for @statusInactive.
  ///
  /// In vi, this message translates to:
  /// **'Ngừng'**
  String get statusInactive;

  /// No description provided for @statusPendingPayment.
  ///
  /// In vi, this message translates to:
  /// **'Chờ thanh toán'**
  String get statusPendingPayment;

  /// No description provided for @statusPaid.
  ///
  /// In vi, this message translates to:
  /// **'Chưa sử dụng'**
  String get statusPaid;

  /// No description provided for @statusInUse.
  ///
  /// In vi, this message translates to:
  /// **'Đang sử dụng'**
  String get statusInUse;

  /// No description provided for @statusUsed.
  ///
  /// In vi, this message translates to:
  /// **'Đã sử dụng'**
  String get statusUsed;

  /// No description provided for @statusExpired.
  ///
  /// In vi, this message translates to:
  /// **'Hết hạn'**
  String get statusExpired;

  /// No description provided for @statusCancelled.
  ///
  /// In vi, this message translates to:
  /// **'Đã hủy'**
  String get statusCancelled;

  /// No description provided for @statusRefunded.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tiền'**
  String get statusRefunded;

  /// No description provided for @statusSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Thành công'**
  String get statusSuccess;

  /// No description provided for @statusFailed.
  ///
  /// In vi, this message translates to:
  /// **'Thất bại'**
  String get statusFailed;

  /// No description provided for @statusNotParked.
  ///
  /// In vi, this message translates to:
  /// **'Chưa gửi'**
  String get statusNotParked;

  /// No description provided for @statusParked.
  ///
  /// In vi, this message translates to:
  /// **'Đang gửi'**
  String get statusParked;

  /// No description provided for @statusPickedUp.
  ///
  /// In vi, this message translates to:
  /// **'Đã lấy xe'**
  String get statusPickedUp;

  /// No description provided for @login.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get login;

  /// No description provided for @noAccount.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tài khoản?'**
  String get noAccount;

  /// No description provided for @register.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get register;

  /// No description provided for @demoPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu demo: {password}'**
  String demoPassword(String password);

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordIntro.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu hả? Cho Futu biết email đã đăng ký nha.'**
  String get forgotPasswordIntro;

  /// No description provided for @registerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản'**
  String get registerTitle;

  /// No description provided for @haveAccount.
  ///
  /// In vi, this message translates to:
  /// **'Đã có tài khoản?'**
  String get haveAccount;

  /// No description provided for @newPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu mới'**
  String get newPassword;

  /// No description provided for @resetSessionExpired.
  ///
  /// In vi, this message translates to:
  /// **'Phiên đặt lại đã hết hạn'**
  String get resetSessionExpired;

  /// No description provided for @resetSessionExpiredBody.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng thực hiện lại bước quên mật khẩu.'**
  String get resetSessionExpiredBody;

  /// No description provided for @otpTitleRegister.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực email'**
  String get otpTitleRegister;

  /// No description provided for @otpTitleReset.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại mật khẩu'**
  String get otpTitleReset;

  /// No description provided for @otpSentTo.
  ///
  /// In vi, this message translates to:
  /// **'Mã 6 số đã gửi tới '**
  String get otpSentTo;

  /// No description provided for @demoOtp.
  ///
  /// In vi, this message translates to:
  /// **'Mã OTP demo: {otp}'**
  String demoOtp(String otp);

  /// No description provided for @lockedBanner.
  ///
  /// In vi, this message translates to:
  /// **'{message}. Vui lòng liên hệ quầy hỗ trợ tại ga.'**
  String lockedBanner(String message);

  /// No description provided for @resetPasswordDone.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu xong! Đăng nhập lại nha.'**
  String get resetPasswordDone;

  /// No description provided for @confirmNewPassword.
  ///
  /// In vi, this message translates to:
  /// **'Nhập lại mật khẩu mới'**
  String get confirmNewPassword;

  /// No description provided for @saveNewPassword.
  ///
  /// In vi, this message translates to:
  /// **'Lưu mật khẩu mới'**
  String get saveNewPassword;

  /// No description provided for @registeredEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email đã đăng ký'**
  String get registeredEmail;

  /// No description provided for @sendCode.
  ///
  /// In vi, this message translates to:
  /// **'Gửi mã xác thực'**
  String get sendCode;

  /// No description provided for @environment.
  ///
  /// In vi, this message translates to:
  /// **'Môi trường: {flavor}'**
  String environment(String flavor);

  /// No description provided for @resendCodeIn.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại mã (sau {seconds}s)'**
  String resendCodeIn(int seconds);

  /// No description provided for @resendCode.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại mã'**
  String get resendCode;

  /// No description provided for @otpResent.
  ///
  /// In vi, this message translates to:
  /// **'Futu gửi lại mã rồi, xem mail nha!'**
  String get otpResent;

  /// No description provided for @confirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirm;

  /// No description provided for @fullName.
  ///
  /// In vi, this message translates to:
  /// **'Họ tên'**
  String get fullName;

  /// No description provided for @otpWillBeSent.
  ///
  /// In vi, this message translates to:
  /// **'Mã OTP sẽ gửi tới email này'**
  String get otpWillBeSent;

  /// No description provided for @confirmPassword.
  ///
  /// In vi, this message translates to:
  /// **'Nhập lại mật khẩu'**
  String get confirmPassword;

  /// No description provided for @continueLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get continueLabel;

  /// No description provided for @rememberMe.
  ///
  /// In vi, this message translates to:
  /// **'Ghi nhớ đăng nhập'**
  String get rememberMe;

  /// No description provided for @forgotPasswordLink.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get forgotPasswordLink;

  /// No description provided for @otpExpired.
  ///
  /// In vi, this message translates to:
  /// **'Mã đã hết hạn, vui lòng gửi lại mã.'**
  String get otpExpired;

  /// No description provided for @expiresIn.
  ///
  /// In vi, this message translates to:
  /// **'Hết hạn sau {time}'**
  String expiresIn(String time);

  /// No description provided for @agreeTo.
  ///
  /// In vi, this message translates to:
  /// **'Tôi đồng ý với '**
  String get agreeTo;

  /// No description provided for @termsOfUse.
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản sử dụng'**
  String get termsOfUse;

  /// No description provided for @arrivalsAtStation.
  ///
  /// In vi, this message translates to:
  /// **'Tàu sắp đến · Ga {station}'**
  String arrivalsAtStation(String station);

  /// No description provided for @quickBook.
  ///
  /// In vi, this message translates to:
  /// **'Đặt vé nhanh'**
  String get quickBook;

  /// No description provided for @fares.
  ///
  /// In vi, this message translates to:
  /// **'Bảng giá'**
  String get fares;

  /// No description provided for @pay.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán'**
  String get pay;

  /// No description provided for @chooseFrom.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ga đi'**
  String get chooseFrom;

  /// No description provided for @chooseTo.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ga đến'**
  String get chooseTo;

  /// No description provided for @fromShort.
  ///
  /// In vi, this message translates to:
  /// **'Đi'**
  String get fromShort;

  /// No description provided for @to.
  ///
  /// In vi, this message translates to:
  /// **'Đến'**
  String get to;

  /// No description provided for @swap.
  ///
  /// In vi, this message translates to:
  /// **'Đổi chiều'**
  String get swap;

  /// No description provided for @memberChip.
  ///
  /// In vi, this message translates to:
  /// **'{tier} · {points} CPoint'**
  String memberChip(String tier, String points);

  /// No description provided for @notifications.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notifications;

  /// No description provided for @activePasses.
  ///
  /// In vi, this message translates to:
  /// **'Vé đang hiệu lực'**
  String get activePasses;

  /// No description provided for @viewAll.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả'**
  String get viewAll;

  /// No description provided for @noActivePasses.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có vé đang hiệu lực'**
  String get noActivePasses;

  /// No description provided for @cancelTransactionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hủy giao dịch?'**
  String get cancelTransactionTitle;

  /// No description provided for @cancelTransactionBody.
  ///
  /// In vi, this message translates to:
  /// **'Vé sẽ không được tạo. Bạn có thể đặt lại sau.'**
  String get cancelTransactionBody;

  /// No description provided for @continuePayment.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục thanh toán'**
  String get continuePayment;

  /// No description provided for @fareTableTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bảng giá vé'**
  String get fareTableTitle;

  /// No description provided for @fareTableNote.
  ///
  /// In vi, this message translates to:
  /// **'Giá đã gồm VAT. Ưu đãi và giảm theo CPoint được trừ khi thanh toán.'**
  String get fareTableNote;

  /// No description provided for @bookingConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận vé'**
  String get bookingConfirmTitle;

  /// No description provided for @noStationsNeeded.
  ///
  /// In vi, this message translates to:
  /// **'Không cần chọn ga'**
  String get noStationsNeeded;

  /// No description provided for @fare.
  ///
  /// In vi, this message translates to:
  /// **'Giá vé'**
  String get fare;

  /// No description provided for @payByQr.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán bằng QR · {amount}'**
  String payByQr(String amount);

  /// No description provided for @usePoints.
  ///
  /// In vi, this message translates to:
  /// **'Dùng {points} điểm'**
  String usePoints(int points);

  /// No description provided for @pointsAvailable.
  ///
  /// In vi, this message translates to:
  /// **'Đang có {points} điểm'**
  String pointsAvailable(String points);

  /// No description provided for @fareTierFrom.
  ///
  /// In vi, this message translates to:
  /// **'Từ {count} ga trở lên'**
  String fareTierFrom(int count);

  /// No description provided for @fareTierRange.
  ///
  /// In vi, this message translates to:
  /// **'{from} – {to} ga'**
  String fareTierRange(int from, int to);

  /// No description provided for @singleFareTitle.
  ///
  /// In vi, this message translates to:
  /// **'Vé lượt (theo số ga đi qua)'**
  String get singleFareTitle;

  /// No description provided for @periodPassTitle.
  ///
  /// In vi, this message translates to:
  /// **'Vé theo thời hạn'**
  String get periodPassTitle;

  /// No description provided for @paymentCodeExpired.
  ///
  /// In vi, this message translates to:
  /// **'Mã thanh toán đã hết hạn'**
  String get paymentCodeExpired;

  /// No description provided for @paymentFailed.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán thất bại'**
  String get paymentFailed;

  /// No description provided for @paymentFailedBody.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa bị trừ tiền. Vui lòng đặt lại vé.'**
  String get paymentFailedBody;

  /// No description provided for @refundPendingTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đang xử lý hoàn tiền'**
  String get refundPendingTitle;

  /// No description provided for @refundPendingBody.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống chưa tạo được vé. Tiền sẽ được hoàn trong 1–3 ngày làm việc.'**
  String get refundPendingBody;

  /// No description provided for @refundCode.
  ///
  /// In vi, this message translates to:
  /// **'Mã tra soát: {code}'**
  String refundCode(String code);

  /// No description provided for @viewTransactions.
  ///
  /// In vi, this message translates to:
  /// **'Xem lịch sử giao dịch'**
  String get viewTransactions;

  /// No description provided for @backHome.
  ///
  /// In vi, this message translates to:
  /// **'Về trang chủ'**
  String get backHome;

  /// No description provided for @paymentSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán thành công'**
  String get paymentSuccess;

  /// No description provided for @openParkingQr.
  ///
  /// In vi, this message translates to:
  /// **'Mở QR gửi xe'**
  String get openParkingQr;

  /// No description provided for @openTicketQr.
  ///
  /// In vi, this message translates to:
  /// **'Mở QR vé'**
  String get openTicketQr;

  /// No description provided for @networkMapTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bản đồ mạng lưới'**
  String get networkMapTitle;

  /// No description provided for @stationDetailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết ga'**
  String get stationDetailTitle;

  /// No description provided for @stationName.
  ///
  /// In vi, this message translates to:
  /// **'Ga {name}'**
  String stationName(String name);

  /// No description provided for @line.
  ///
  /// In vi, this message translates to:
  /// **'Tuyến'**
  String get line;

  /// No description provided for @lineNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy tuyến'**
  String get lineNotFound;

  /// No description provided for @metroLines.
  ///
  /// In vi, this message translates to:
  /// **'Các tuyến metro'**
  String get metroLines;

  /// No description provided for @routeSearchTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tra cứu lộ trình'**
  String get routeSearchTitle;

  /// No description provided for @routeNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy lộ trình'**
  String get routeNotFound;

  /// No description provided for @routeNotFoundBody.
  ///
  /// In vi, this message translates to:
  /// **'Hai ga chưa được kết nối bởi tuyến đang khai thác.'**
  String get routeNotFoundBody;

  /// No description provided for @transferTo.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển {line}'**
  String transferTo(String line);

  /// No description provided for @changeTo.
  ///
  /// In vi, this message translates to:
  /// **'Đổi sang {line} (~3 phút)'**
  String changeTo(String line);

  /// No description provided for @minutes.
  ///
  /// In vi, this message translates to:
  /// **'{minutes} phút'**
  String minutes(int minutes);

  /// No description provided for @direct.
  ///
  /// In vi, this message translates to:
  /// **'Đi thẳng'**
  String get direct;

  /// No description provided for @map.
  ///
  /// In vi, this message translates to:
  /// **'Bản đồ'**
  String get map;

  /// No description provided for @book.
  ///
  /// In vi, this message translates to:
  /// **'Đặt vé'**
  String get book;

  /// No description provided for @exits.
  ///
  /// In vi, this message translates to:
  /// **'Lối ra'**
  String get exits;

  /// No description provided for @from.
  ///
  /// In vi, this message translates to:
  /// **'Từ'**
  String get from;

  /// No description provided for @findRoute.
  ///
  /// In vi, this message translates to:
  /// **'Tìm lộ trình'**
  String get findRoute;

  /// No description provided for @noAmenities.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu tiện ích quanh ga'**
  String get noAmenities;

  /// No description provided for @inOperation.
  ///
  /// In vi, this message translates to:
  /// **'Đang hoạt động'**
  String get inOperation;

  /// No description provided for @notInOperation.
  ///
  /// In vi, this message translates to:
  /// **'Chưa khai thác'**
  String get notInOperation;

  /// No description provided for @tabOverview.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan'**
  String get tabOverview;

  /// No description provided for @tabNearby.
  ///
  /// In vi, this message translates to:
  /// **'Quanh ga'**
  String get tabNearby;

  /// No description provided for @tabBus.
  ///
  /// In vi, this message translates to:
  /// **'Xe buýt'**
  String get tabBus;

  /// No description provided for @bookFromHere.
  ///
  /// In vi, this message translates to:
  /// **'Đặt vé từ đây'**
  String get bookFromHere;

  /// No description provided for @viewMap.
  ///
  /// In vi, this message translates to:
  /// **'Xem bản đồ'**
  String get viewMap;

  /// No description provided for @noBusStops.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có trạm buýt kết nối'**
  String get noBusStops;

  /// No description provided for @walkMinutes.
  ///
  /// In vi, this message translates to:
  /// **'{minutes} phút đi bộ'**
  String walkMinutes(int minutes);

  /// No description provided for @arriving.
  ///
  /// In vi, this message translates to:
  /// **'Đang vào ga'**
  String get arriving;

  /// No description provided for @etaMinutes.
  ///
  /// In vi, this message translates to:
  /// **'{minutes} ph'**
  String etaMinutes(int minutes);

  /// No description provided for @nextTrains.
  ///
  /// In vi, this message translates to:
  /// **'Tàu sắp đến'**
  String get nextTrains;

  /// No description provided for @arrivalsFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không lấy được giờ tàu'**
  String get arrivalsFailed;

  /// No description provided for @noArrivals.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có chuyến tàu nào đang tới'**
  String get noArrivals;

  /// No description provided for @routeLookup.
  ///
  /// In vi, this message translates to:
  /// **'Tra lộ trình'**
  String get routeLookup;

  /// No description provided for @nearbyStations.
  ///
  /// In vi, this message translates to:
  /// **'Ga gần bạn'**
  String get nearbyStations;

  /// No description provided for @linePlanned.
  ///
  /// In vi, this message translates to:
  /// **'Quy hoạch'**
  String get linePlanned;

  /// No description provided for @inService.
  ///
  /// In vi, this message translates to:
  /// **'Đang khai thác'**
  String get inService;

  /// No description provided for @linePlannedNote.
  ///
  /// In vi, this message translates to:
  /// **'Tuyến đang quy hoạch, chưa khai thác. Thông tin chỉ để tham khảo.'**
  String get linePlannedNote;

  /// No description provided for @tapMapToPick.
  ///
  /// In vi, this message translates to:
  /// **'Chạm vào bản đồ để chọn vị trí của bạn'**
  String get tapMapToPick;

  /// No description provided for @locationServiceOff.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ định vị đang tắt.'**
  String get locationServiceOff;

  /// No description provided for @locationDeniedForever.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã chặn quyền vị trí. Hãy bật lại trong Cài đặt.'**
  String get locationDeniedForever;

  /// No description provided for @locationRationale.
  ///
  /// In vi, this message translates to:
  /// **'App cần vị trí trong phiên này để tìm ga gần bạn. Vị trí không được lưu lại.'**
  String get locationRationale;

  /// No description provided for @enableLocation.
  ///
  /// In vi, this message translates to:
  /// **'Bật vị trí'**
  String get enableLocation;

  /// No description provided for @pickOnMap.
  ///
  /// In vi, this message translates to:
  /// **'Chọn trên bản đồ'**
  String get pickOnMap;

  /// No description provided for @noLines.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tuyến'**
  String get noLines;

  /// No description provided for @searchStation.
  ///
  /// In vi, this message translates to:
  /// **'Tìm ga'**
  String get searchStation;

  /// No description provided for @all.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get all;

  /// No description provided for @bus.
  ///
  /// In vi, this message translates to:
  /// **'Buýt'**
  String get bus;

  /// No description provided for @findNearby.
  ///
  /// In vi, this message translates to:
  /// **'Tìm ga gần bạn'**
  String get findNearby;

  /// No description provided for @findNearMe.
  ///
  /// In vi, this message translates to:
  /// **'Tìm ga gần vị trí của tôi'**
  String get findNearMe;

  /// No description provided for @byPickedLocation.
  ///
  /// In vi, this message translates to:
  /// **'Theo vị trí bạn chọn'**
  String get byPickedLocation;

  /// No description provided for @structureUnderground.
  ///
  /// In vi, this message translates to:
  /// **'Ngầm'**
  String get structureUnderground;

  /// No description provided for @structureElevated.
  ///
  /// In vi, this message translates to:
  /// **'Trên cao'**
  String get structureElevated;

  /// No description provided for @structureAtGrade.
  ///
  /// In vi, this message translates to:
  /// **'Mặt đất'**
  String get structureAtGrade;

  /// No description provided for @myTickets.
  ///
  /// In vi, this message translates to:
  /// **'Vé của tôi'**
  String get myTickets;

  /// No description provided for @trainTickets.
  ///
  /// In vi, this message translates to:
  /// **'Vé tàu'**
  String get trainTickets;

  /// No description provided for @noTransactions.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có giao dịch'**
  String get noTransactions;

  /// No description provided for @parkingEnded.
  ///
  /// In vi, this message translates to:
  /// **'Lượt gửi xe đã kết thúc'**
  String get parkingEnded;

  /// No description provided for @noParkingPasses.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lượt gửi xe'**
  String get noParkingPasses;

  /// No description provided for @registerParking.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký gửi xe'**
  String get registerParking;

  /// No description provided for @allShown.
  ///
  /// In vi, this message translates to:
  /// **'Đã hiển thị tất cả'**
  String get allShown;

  /// No description provided for @noTickets.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa có vé nào'**
  String get noTickets;

  /// No description provided for @noTicketsFiltered.
  ///
  /// In vi, this message translates to:
  /// **'Không có vé {filter}'**
  String noTicketsFiltered(String filter);

  /// No description provided for @bookNow.
  ///
  /// In vi, this message translates to:
  /// **'Đặt vé ngay'**
  String get bookNow;

  /// No description provided for @filterUnused.
  ///
  /// In vi, this message translates to:
  /// **'Chưa dùng'**
  String get filterUnused;

  /// No description provided for @filterInUse.
  ///
  /// In vi, this message translates to:
  /// **'Đang dùng'**
  String get filterInUse;

  /// No description provided for @validUntil.
  ///
  /// In vi, this message translates to:
  /// **'Hiệu lực đến {date}'**
  String validUntil(String date);

  /// No description provided for @ticketQrHint.
  ///
  /// In vi, this message translates to:
  /// **'Đưa mã QR vào máy quét hoặc cho nhân viên soát vé.'**
  String get ticketQrHint;

  /// No description provided for @close.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get close;

  /// No description provided for @codeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mã: {code}'**
  String codeLabel(String code);

  /// No description provided for @enteredAt.
  ///
  /// In vi, this message translates to:
  /// **'Vào lúc {time}'**
  String enteredAt(String time);

  /// No description provided for @lot.
  ///
  /// In vi, this message translates to:
  /// **'Bãi'**
  String get lot;

  /// No description provided for @plate.
  ///
  /// In vi, this message translates to:
  /// **'Biển số'**
  String get plate;

  /// No description provided for @bicycleNoPlate.
  ///
  /// In vi, this message translates to:
  /// **'Xe đạp không cần biển số'**
  String get bicycleNoPlate;

  /// No description provided for @vehicleType.
  ///
  /// In vi, this message translates to:
  /// **'Loại xe'**
  String get vehicleType;

  /// No description provided for @package.
  ///
  /// In vi, this message translates to:
  /// **'Gói'**
  String get package;

  /// No description provided for @packageTurn.
  ///
  /// In vi, this message translates to:
  /// **'Lượt'**
  String get packageTurn;

  /// No description provided for @packageDay.
  ///
  /// In vi, this message translates to:
  /// **'Ngày'**
  String get packageDay;

  /// No description provided for @packageMonth.
  ///
  /// In vi, this message translates to:
  /// **'Tháng'**
  String get packageMonth;

  /// No description provided for @feeEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Phí: —'**
  String get feeEmpty;

  /// No description provided for @fee.
  ///
  /// In vi, this message translates to:
  /// **'Phí {amount}'**
  String fee(String amount);

  /// No description provided for @activePassBanner.
  ///
  /// In vi, this message translates to:
  /// **'Xe này đang có lượt gửi còn hiệu lực.'**
  String get activePassBanner;

  /// No description provided for @lotNoVehicleType.
  ///
  /// In vi, this message translates to:
  /// **'Bãi không nhận loại xe này'**
  String get lotNoVehicleType;

  /// No description provided for @available.
  ///
  /// In vi, this message translates to:
  /// **'Còn trống'**
  String get available;

  /// No description provided for @until.
  ///
  /// In vi, this message translates to:
  /// **'Đến {date}'**
  String until(String date);

  /// No description provided for @membership.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên'**
  String get membership;

  /// No description provided for @tierBenefits.
  ///
  /// In vi, this message translates to:
  /// **'Quyền lợi hạng {tier}'**
  String tierBenefits(String tier);

  /// No description provided for @activePromotions.
  ///
  /// In vi, this message translates to:
  /// **'Ưu đãi đang có'**
  String get activePromotions;

  /// No description provided for @noPromotions.
  ///
  /// In vi, this message translates to:
  /// **'Hiện chưa có ưu đãi'**
  String get noPromotions;

  /// No description provided for @pointsHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử điểm'**
  String get pointsHistory;

  /// No description provided for @tierTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hạng {tier}'**
  String tierTitle(String tier);

  /// No description provided for @points.
  ///
  /// In vi, this message translates to:
  /// **'{points} điểm'**
  String points(String points);

  /// No description provided for @topTier.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang ở hạng cao nhất'**
  String get topTier;

  /// No description provided for @pointsToNext.
  ///
  /// In vi, this message translates to:
  /// **'Còn {points} điểm lên {tier}'**
  String pointsToNext(String points, String tier);

  /// No description provided for @noPointsHistory.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có biến động điểm'**
  String get noPointsHistory;

  /// No description provided for @markAllRead.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu đã đọc'**
  String get markAllRead;

  /// No description provided for @noNotifications.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thông báo'**
  String get noNotifications;

  /// No description provided for @yesterday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm qua'**
  String get yesterday;

  /// No description provided for @noNews.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tin'**
  String get noNews;

  /// No description provided for @prefPush.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo đẩy'**
  String get prefPush;

  /// No description provided for @prefPromotion.
  ///
  /// In vi, this message translates to:
  /// **'Khuyến mãi'**
  String get prefPromotion;

  /// No description provided for @prefSmart.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý thông minh'**
  String get prefSmart;

  /// No description provided for @prefSmartBody.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý loại vé tiết kiệm theo thói quen đi lại'**
  String get prefSmartBody;

  /// No description provided for @prefOperation.
  ///
  /// In vi, this message translates to:
  /// **'Vận hành'**
  String get prefOperation;

  /// No description provided for @prefOperationBody.
  ///
  /// In vi, this message translates to:
  /// **'Bắt buộc: thay đổi lịch chạy, sự cố, bảo trì'**
  String get prefOperationBody;

  /// No description provided for @prefPayment.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả thanh toán'**
  String get prefPayment;

  /// No description provided for @prefPaymentBody.
  ///
  /// In vi, this message translates to:
  /// **'Bắt buộc: xác nhận giao dịch của bạn'**
  String get prefPaymentBody;

  /// No description provided for @operationNotice.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo vận hành'**
  String get operationNotice;

  /// No description provided for @assistantTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trợ lý HopOn'**
  String get assistantTitle;

  /// No description provided for @newSession.
  ///
  /// In vi, this message translates to:
  /// **'Phiên mới'**
  String get newSession;

  /// No description provided for @assistantTyping.
  ///
  /// In vi, this message translates to:
  /// **'Trợ lý đang trả lời…'**
  String get assistantTyping;

  /// No description provided for @sendFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không gửi được câu hỏi'**
  String get sendFailed;

  /// No description provided for @askHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập câu hỏi…'**
  String get askHint;

  /// No description provided for @send.
  ///
  /// In vi, this message translates to:
  /// **'Gửi'**
  String get send;

  /// No description provided for @viewTicket.
  ///
  /// In vi, this message translates to:
  /// **'Xem vé'**
  String get viewTicket;

  /// No description provided for @viewStation.
  ///
  /// In vi, this message translates to:
  /// **'Xem ga {name}'**
  String viewStation(String name);

  /// No description provided for @route.
  ///
  /// In vi, this message translates to:
  /// **'Lộ trình'**
  String get route;

  /// No description provided for @scanEntry.
  ///
  /// In vi, this message translates to:
  /// **'Vào ga'**
  String get scanEntry;

  /// No description provided for @scanExit.
  ///
  /// In vi, this message translates to:
  /// **'Ra ga'**
  String get scanExit;

  /// No description provided for @scanValid.
  ///
  /// In vi, this message translates to:
  /// **'VÉ HỢP LỆ'**
  String get scanValid;

  /// No description provided for @scanInvalid.
  ///
  /// In vi, this message translates to:
  /// **'KHÔNG HỢP LỆ'**
  String get scanInvalid;

  /// No description provided for @recordedAt.
  ///
  /// In vi, this message translates to:
  /// **'Ghi nhận: {time} · {mode}'**
  String recordedAt(String time, String mode);

  /// No description provided for @rejectReason.
  ///
  /// In vi, this message translates to:
  /// **'Lý do: {reason}'**
  String rejectReason(String reason);

  /// No description provided for @ticketLabel.
  ///
  /// In vi, this message translates to:
  /// **'Vé: {ticket}'**
  String ticketLabel(String ticket);

  /// No description provided for @currentStation.
  ///
  /// In vi, this message translates to:
  /// **'Ga hiện tại: {station}'**
  String currentStation(String station);

  /// No description provided for @scanNext.
  ///
  /// In vi, this message translates to:
  /// **'Quét tiếp'**
  String get scanNext;

  /// No description provided for @rejectExpired.
  ///
  /// In vi, this message translates to:
  /// **'Vé hết hạn'**
  String get rejectExpired;

  /// No description provided for @rejectUsed.
  ///
  /// In vi, this message translates to:
  /// **'Vé đã được sử dụng'**
  String get rejectUsed;

  /// No description provided for @rejectAlreadyIn.
  ///
  /// In vi, this message translates to:
  /// **'Vé đã được check-in'**
  String get rejectAlreadyIn;

  /// No description provided for @rejectNotIn.
  ///
  /// In vi, this message translates to:
  /// **'Vé chưa check-in vào ga'**
  String get rejectNotIn;

  /// No description provided for @rejectWrongStation.
  ///
  /// In vi, this message translates to:
  /// **'Check-out sai ga'**
  String get rejectWrongStation;

  /// No description provided for @rejectNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Vé không tồn tại'**
  String get rejectNotFound;

  /// No description provided for @rejectForbidden.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chỉ được soát vé tại ga được phân công'**
  String get rejectForbidden;

  /// No description provided for @errQrUnreadable.
  ///
  /// In vi, this message translates to:
  /// **'Không đọc được mã QR. Quét lại'**
  String get errQrUnreadable;

  /// No description provided for @statEntries.
  ///
  /// In vi, this message translates to:
  /// **'vào'**
  String get statEntries;

  /// No description provided for @statExits.
  ///
  /// In vi, this message translates to:
  /// **'ra'**
  String get statExits;

  /// No description provided for @statRejected.
  ///
  /// In vi, this message translates to:
  /// **'từ chối'**
  String get statRejected;

  /// No description provided for @enterTicketCode.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã vé'**
  String get enterTicketCode;

  /// No description provided for @check.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra'**
  String get check;

  /// No description provided for @cameraDeniedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có quyền camera'**
  String get cameraDeniedTitle;

  /// No description provided for @cameraDeniedForever.
  ///
  /// In vi, this message translates to:
  /// **'Mở Cài đặt > Quyền > Camera để bật lại. Trong lúc chờ, dùng \"Nhập mã vé thủ công\".'**
  String get cameraDeniedForever;

  /// No description provided for @cameraRationale.
  ///
  /// In vi, this message translates to:
  /// **'Cần camera sau để quét QR trên màn hình hành khách.'**
  String get cameraRationale;

  /// No description provided for @openSettings.
  ///
  /// In vi, this message translates to:
  /// **'Mở cài đặt'**
  String get openSettings;

  /// No description provided for @grantCamera.
  ///
  /// In vi, this message translates to:
  /// **'Cấp quyền camera'**
  String get grantCamera;

  /// No description provided for @manualCode.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã vé thủ công'**
  String get manualCode;

  /// No description provided for @scanParkingQr.
  ///
  /// In vi, this message translates to:
  /// **'Quét QR gửi xe'**
  String get scanParkingQr;

  /// No description provided for @parkedAtLot.
  ///
  /// In vi, this message translates to:
  /// **'Đang gửi tại bãi'**
  String get parkedAtLot;

  /// No description provided for @searchPlate.
  ///
  /// In vi, this message translates to:
  /// **'Tìm biển số'**
  String get searchPlate;

  /// No description provided for @noVehicles.
  ///
  /// In vi, this message translates to:
  /// **'Không có xe phù hợp'**
  String get noVehicles;

  /// No description provided for @result.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả'**
  String get result;

  /// No description provided for @parkedInAt.
  ///
  /// In vi, this message translates to:
  /// **'Vào lúc {time}'**
  String parkedInAt(String time);

  /// No description provided for @parkedOutAt.
  ///
  /// In vi, this message translates to:
  /// **'Ra lúc {time}'**
  String parkedOutAt(String time);

  /// No description provided for @scanHistoryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử quét · Hôm nay'**
  String get scanHistoryTitle;

  /// No description provided for @noScans.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lượt quét'**
  String get noScans;

  /// No description provided for @filterTickets.
  ///
  /// In vi, this message translates to:
  /// **'Vé'**
  String get filterTickets;

  /// No description provided for @filterRejected.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get filterRejected;

  /// No description provided for @inShort.
  ///
  /// In vi, this message translates to:
  /// **'Vào'**
  String get inShort;

  /// No description provided for @outShort.
  ///
  /// In vi, this message translates to:
  /// **'Ra'**
  String get outShort;

  /// No description provided for @viewQr.
  ///
  /// In vi, this message translates to:
  /// **'Xem QR'**
  String get viewQr;

  /// No description provided for @ticketCodeExample.
  ///
  /// In vi, this message translates to:
  /// **'VD: {code}'**
  String ticketCodeExample(String code);

  /// No description provided for @viewDesignSystem.
  ///
  /// In vi, this message translates to:
  /// **'Xem Design System'**
  String get viewDesignSystem;

  /// No description provided for @parkedSince.
  ///
  /// In vi, this message translates to:
  /// **'từ {time}'**
  String parkedSince(String time);

  /// No description provided for @placeBus.
  ///
  /// In vi, this message translates to:
  /// **'Xe buýt'**
  String get placeBus;

  /// No description provided for @placeHealth.
  ///
  /// In vi, this message translates to:
  /// **'Y tế'**
  String get placeHealth;

  /// No description provided for @placeMarket.
  ///
  /// In vi, this message translates to:
  /// **'Chợ & mua sắm'**
  String get placeMarket;

  /// No description provided for @placeFood.
  ///
  /// In vi, this message translates to:
  /// **'Ăn uống'**
  String get placeFood;

  /// No description provided for @placeEducation.
  ///
  /// In vi, this message translates to:
  /// **'Trường học'**
  String get placeEducation;

  /// No description provided for @placeLeisure.
  ///
  /// In vi, this message translates to:
  /// **'Vui chơi'**
  String get placeLeisure;

  /// No description provided for @placeServices.
  ///
  /// In vi, this message translates to:
  /// **'Tiện ích'**
  String get placeServices;

  /// No description provided for @kindHospital.
  ///
  /// In vi, this message translates to:
  /// **'Bệnh viện'**
  String get kindHospital;

  /// No description provided for @kindMarket.
  ///
  /// In vi, this message translates to:
  /// **'Chợ'**
  String get kindMarket;

  /// No description provided for @kindShop.
  ///
  /// In vi, this message translates to:
  /// **'Mua sắm'**
  String get kindShop;

  /// No description provided for @kindFood.
  ///
  /// In vi, this message translates to:
  /// **'Ăn uống'**
  String get kindFood;

  /// No description provided for @kindSchool.
  ///
  /// In vi, this message translates to:
  /// **'Trường học'**
  String get kindSchool;

  /// No description provided for @kindPark.
  ///
  /// In vi, this message translates to:
  /// **'Công viên'**
  String get kindPark;

  /// No description provided for @kindLandmark.
  ///
  /// In vi, this message translates to:
  /// **'Địa danh'**
  String get kindLandmark;

  /// No description provided for @kindAtm.
  ///
  /// In vi, this message translates to:
  /// **'ATM'**
  String get kindAtm;

  /// No description provided for @kindParking.
  ///
  /// In vi, this message translates to:
  /// **'Bãi gửi xe'**
  String get kindParking;

  /// No description provided for @kindToilet.
  ///
  /// In vi, this message translates to:
  /// **'Nhà vệ sinh'**
  String get kindToilet;

  /// No description provided for @kindBusStop.
  ///
  /// In vi, this message translates to:
  /// **'Trạm xe buýt'**
  String get kindBusStop;

  /// No description provided for @nearbyPlacesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tiện ích quanh ga'**
  String get nearbyPlacesTitle;

  /// No description provided for @stationShort.
  ///
  /// In vi, this message translates to:
  /// **'Ga'**
  String get stationShort;

  /// No description provided for @networkDiagram.
  ///
  /// In vi, this message translates to:
  /// **'Sơ đồ'**
  String get networkDiagram;

  /// No description provided for @diagramHint.
  ///
  /// In vi, this message translates to:
  /// **'Chạm vào ga để xem chi tiết'**
  String get diagramHint;

  /// No description provided for @buyTicket.
  ///
  /// In vi, this message translates to:
  /// **'Mua vé'**
  String get buyTicket;

  /// No description provided for @lineDiagram.
  ///
  /// In vi, this message translates to:
  /// **'Sơ đồ tuyến'**
  String get lineDiagram;

  /// No description provided for @newsTagOperation.
  ///
  /// In vi, this message translates to:
  /// **'Vận hành'**
  String get newsTagOperation;

  /// No description provided for @newsTagNews.
  ///
  /// In vi, this message translates to:
  /// **'Tin tức'**
  String get newsTagNews;

  /// No description provided for @newsNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Tin không còn tồn tại'**
  String get newsNotFound;

  /// No description provided for @stepChoose.
  ///
  /// In vi, this message translates to:
  /// **'Chọn vé'**
  String get stepChoose;

  /// No description provided for @stepConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get stepConfirm;

  /// No description provided for @stepPay.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán'**
  String get stepPay;

  /// No description provided for @singleTicketHint.
  ///
  /// In vi, this message translates to:
  /// **'Giá theo số ga · {validity}'**
  String singleTicketHint(String validity);

  /// No description provided for @fromPrice.
  ///
  /// In vi, this message translates to:
  /// **'từ {price}'**
  String fromPrice(String price);

  /// No description provided for @ticketTypeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn loại vé'**
  String get ticketTypeTitle;

  /// No description provided for @journeyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hành trình'**
  String get journeyTitle;

  /// No description provided for @chooseDifferentStations.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ga đi và ga đến khác nhau để xem giá.'**
  String get chooseDifferentStations;

  /// No description provided for @subtotal.
  ///
  /// In vi, this message translates to:
  /// **'Tạm tính'**
  String get subtotal;

  /// No description provided for @copied.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép {value}'**
  String copied(String value);

  /// No description provided for @copy.
  ///
  /// In vi, this message translates to:
  /// **'Sao chép'**
  String get copy;

  /// No description provided for @scanVietQr.
  ///
  /// In vi, this message translates to:
  /// **'Quét mã VietQR'**
  String get scanVietQr;

  /// No description provided for @manualTransfer.
  ///
  /// In vi, this message translates to:
  /// **'Hoặc chuyển khoản thủ công'**
  String get manualTransfer;

  /// No description provided for @bank.
  ///
  /// In vi, this message translates to:
  /// **'Ngân hàng'**
  String get bank;

  /// No description provided for @accountNumber.
  ///
  /// In vi, this message translates to:
  /// **'Số tài khoản'**
  String get accountNumber;

  /// No description provided for @accountName.
  ///
  /// In vi, this message translates to:
  /// **'Chủ tài khoản'**
  String get accountName;

  /// No description provided for @transferContent.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung'**
  String get transferContent;

  /// No description provided for @transferNote.
  ///
  /// In vi, this message translates to:
  /// **'Nhập đúng số tiền và nội dung để vé được xuất tự động.'**
  String get transferNote;

  /// No description provided for @transferNoteDemo.
  ///
  /// In vi, this message translates to:
  /// **'Bản demo: không chuyển tiền thật, đơn tự xác nhận sau vài giây.'**
  String get transferNoteDemo;

  /// No description provided for @paymentMethod.
  ///
  /// In vi, this message translates to:
  /// **'Phương thức thanh toán'**
  String get paymentMethod;

  /// No description provided for @methodVietQr.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển khoản VietQR (SePay)'**
  String get methodVietQr;

  /// No description provided for @methodVietQrHint.
  ///
  /// In vi, this message translates to:
  /// **'Mọi ngân hàng, ví điện tử · xác nhận tự động'**
  String get methodVietQrHint;

  /// No description provided for @routeShort.
  ///
  /// In vi, this message translates to:
  /// **'Lộ trình'**
  String get routeShort;

  /// No description provided for @errBadCredentials.
  ///
  /// In vi, this message translates to:
  /// **'Email hoặc mật khẩu không đúng'**
  String get errBadCredentials;

  /// No description provided for @errEmailNotVerified.
  ///
  /// In vi, this message translates to:
  /// **'Email chưa được xác thực'**
  String get errEmailNotVerified;

  /// No description provided for @errRateLimited.
  ///
  /// In vi, this message translates to:
  /// **'Bạn thao tác quá nhanh, vui lòng thử lại sau'**
  String get errRateLimited;

  /// No description provided for @errLoginLocked.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã nhập sai quá nhiều lần, thử lại sau 15 phút'**
  String get errLoginLocked;

  /// No description provided for @errCurrentPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu hiện tại không đúng'**
  String get errCurrentPassword;

  /// No description provided for @errEmailTaken.
  ///
  /// In vi, this message translates to:
  /// **'Email đã có người dùng'**
  String get errEmailTaken;

  /// No description provided for @valNameLength.
  ///
  /// In vi, this message translates to:
  /// **'Họ tên tối đa 120 ký tự'**
  String get valNameLength;

  /// No description provided for @valPasswordTooLong.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu quá dài'**
  String get valPasswordTooLong;

  /// No description provided for @valPasswordBlank.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu không được toàn khoảng trắng'**
  String get valPasswordBlank;

  /// No description provided for @otpCode.
  ///
  /// In vi, this message translates to:
  /// **'Mã OTP'**
  String get otpCode;

  /// No description provided for @otpSentIfExists.
  ///
  /// In vi, this message translates to:
  /// **'Nếu {email} đã đăng ký, mã 6 số đang tới hộp thư của bạn.'**
  String otpSentIfExists(String email);

  /// No description provided for @emailVerifiedDone.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực xong! Đăng nhập thôi.'**
  String get emailVerifiedDone;

  /// No description provided for @registerPendingCode.
  ///
  /// In vi, this message translates to:
  /// **'Email này đang chờ xác thực. Hãy nhập mã đã gửi, mật khẩu vừa nhập chưa được lưu.'**
  String get registerPendingCode;

  /// No description provided for @profileSaved.
  ///
  /// In vi, this message translates to:
  /// **'Futu lưu rồi nha!'**
  String get profileSaved;

  /// No description provided for @saveProfile.
  ///
  /// In vi, this message translates to:
  /// **'Lưu thông tin'**
  String get saveProfile;

  /// No description provided for @currentPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu hiện tại'**
  String get currentPassword;

  /// No description provided for @changePassword.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu'**
  String get changePassword;

  /// No description provided for @changePasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Sau khi đổi, mọi thiết bị phải đăng nhập lại.'**
  String get changePasswordHint;

  /// No description provided for @verifyNewEmailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận email mới'**
  String get verifyNewEmailTitle;

  /// No description provided for @verifyNewEmailHint.
  ///
  /// In vi, this message translates to:
  /// **'Chưa nhận được mã? Quay lại và gửi yêu cầu đổi email lần nữa.'**
  String get verifyNewEmailHint;

  /// No description provided for @emailChangedRelogin.
  ///
  /// In vi, this message translates to:
  /// **'Đổi email thành công, hãy đăng nhập bằng email mới'**
  String get emailChangedRelogin;

  /// No description provided for @passwordChangedRelogin.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu xong! Đăng nhập lại nha.'**
  String get passwordChangedRelogin;

  /// No description provided for @loginTwoFactorTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận đăng nhập'**
  String get loginTwoFactorTitle;

  /// No description provided for @twoFactorTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận 2 lớp'**
  String get twoFactorTitle;

  /// No description provided for @twoFactorHint.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi lần đăng nhập cần thêm mã gửi tới email của bạn.'**
  String get twoFactorHint;

  /// No description provided for @twoFactorEnabledDone.
  ///
  /// In vi, this message translates to:
  /// **'Đã bật xác nhận 2 lớp'**
  String get twoFactorEnabledDone;

  /// No description provided for @twoFactorDisabledDone.
  ///
  /// In vi, this message translates to:
  /// **'Đã tắt xác nhận 2 lớp'**
  String get twoFactorDisabledDone;

  /// No description provided for @network3dTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sơ đồ 3D'**
  String get network3dTitle;

  /// No description provided for @network3dOpen.
  ///
  /// In vi, this message translates to:
  /// **'Mở sơ đồ'**
  String get network3dOpen;

  /// No description provided for @network3dHint.
  ///
  /// In vi, this message translates to:
  /// **'Kéo để xoay, chụm hai ngón để phóng to, chạm ga để xem nha!'**
  String get network3dHint;

  /// No description provided for @network3dReset.
  ///
  /// In vi, this message translates to:
  /// **'Về góc nhìn ban đầu'**
  String get network3dReset;

  /// No description provided for @network2dMode.
  ///
  /// In vi, this message translates to:
  /// **'2D'**
  String get network2dMode;

  /// No description provided for @network3dMode.
  ///
  /// In vi, this message translates to:
  /// **'3D'**
  String get network3dMode;

  /// No description provided for @allLines.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get allLines;

  /// No description provided for @homeNextTicket.
  ///
  /// In vi, this message translates to:
  /// **'Vé sẵn sàng'**
  String get homeNextTicket;

  /// No description provided for @homeParkingPass.
  ///
  /// In vi, this message translates to:
  /// **'Gửi xe'**
  String get homeParkingPass;

  /// No description provided for @homeNoTicket.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có vé'**
  String get homeNoTicket;

  /// No description provided for @homeNoParking.
  ///
  /// In vi, this message translates to:
  /// **'Chưa gửi xe'**
  String get homeNoParking;

  /// No description provided for @vietnamMapLabel.
  ///
  /// In vi, this message translates to:
  /// **'Bản đồ Việt Nam, gồm quần đảo Hoàng Sa và quần đảo Trường Sa'**
  String get vietnamMapLabel;

  /// No description provided for @hoangSaLabel.
  ///
  /// In vi, this message translates to:
  /// **'QĐ. Hoàng Sa'**
  String get hoangSaLabel;

  /// No description provided for @truongSaLabel.
  ///
  /// In vi, this message translates to:
  /// **'QĐ. Trường Sa'**
  String get truongSaLabel;

  /// No description provided for @hcmcShort.
  ///
  /// In vi, this message translates to:
  /// **'TP.HCM'**
  String get hcmcShort;

  /// No description provided for @back.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get back;

  /// No description provided for @continueAction.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get continueAction;

  /// No description provided for @exploreMapHint.
  ///
  /// In vi, this message translates to:
  /// **'Ga gần bạn, quanh ga, tàu đang chạy'**
  String get exploreMapHint;

  /// No description provided for @exploreRouteHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm đường đi và giá vé'**
  String get exploreRouteHint;

  /// No description provided for @parkingBookTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đặt chỗ gửi xe'**
  String get parkingBookTitle;

  /// No description provided for @parkingStepLot.
  ///
  /// In vi, this message translates to:
  /// **'Chọn bãi'**
  String get parkingStepLot;

  /// No description provided for @parkingStepInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin'**
  String get parkingStepInfo;

  /// No description provided for @parkingChooseLot.
  ///
  /// In vi, this message translates to:
  /// **'Chọn bãi gửi'**
  String get parkingChooseLot;

  /// No description provided for @parkingAfterPay.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán xong bạn nhận QR. Đưa cho nhân viên khi vào và ra bãi.'**
  String get parkingAfterPay;

  /// No description provided for @parkingEntryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gửi xe tại ga'**
  String get parkingEntryTitle;

  /// No description provided for @parkingEntryAction.
  ///
  /// In vi, this message translates to:
  /// **'Đặt chỗ'**
  String get parkingEntryAction;

  /// No description provided for @newPasswordIntro.
  ///
  /// In vi, this message translates to:
  /// **'Đặt mật khẩu mới trước nha, rồi Futu gửi mã 6 số qua email.'**
  String get newPasswordIntro;

  /// No description provided for @otpVerifyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực OTP'**
  String get otpVerifyTitle;

  /// No description provided for @mascotTipQr.
  ///
  /// In vi, this message translates to:
  /// **'Mở sẵn QR trước khi tới cổng nha!'**
  String get mascotTipQr;

  /// No description provided for @mascotTipParking.
  ///
  /// In vi, this message translates to:
  /// **'Đặt chỗ gửi xe trước cho chắc nha!'**
  String get mascotTipParking;

  /// No description provided for @mascotTipMap.
  ///
  /// In vi, this message translates to:
  /// **'Chạm một ga trên bản đồ để xem quanh đó có gì nè!'**
  String get mascotTipMap;

  /// No description provided for @mascotLabel.
  ///
  /// In vi, this message translates to:
  /// **'Futu, chạm để xem mẹo khác'**
  String get mascotLabel;

  /// No description provided for @bookingHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử đặt'**
  String get bookingHistory;

  /// No description provided for @noActiveTickets.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có vé còn hiệu lực'**
  String get noActiveTickets;

  /// No description provided for @noTicketHistory.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có vé nào trong lịch sử'**
  String get noTicketHistory;

  /// No description provided for @noParkingHistory.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lượt gửi xe nào đã kết thúc'**
  String get noParkingHistory;

  /// No description provided for @forecastTitle.
  ///
  /// In vi, this message translates to:
  /// **'Độ đông hôm nay'**
  String get forecastTitle;

  /// No description provided for @forecastLevelLow.
  ///
  /// In vi, this message translates to:
  /// **'Vắng'**
  String get forecastLevelLow;

  /// No description provided for @forecastLevelMedium.
  ///
  /// In vi, this message translates to:
  /// **'Vừa'**
  String get forecastLevelMedium;

  /// No description provided for @forecastLevelHigh.
  ///
  /// In vi, this message translates to:
  /// **'Đông'**
  String get forecastLevelHigh;

  /// No description provided for @forecastRoadLow.
  ///
  /// In vi, this message translates to:
  /// **'thông thoáng'**
  String get forecastRoadLow;

  /// No description provided for @forecastRoadMedium.
  ///
  /// In vi, this message translates to:
  /// **'xe đông vừa'**
  String get forecastRoadMedium;

  /// No description provided for @forecastRoadHigh.
  ///
  /// In vi, this message translates to:
  /// **'dễ kẹt xe'**
  String get forecastRoadHigh;

  /// No description provided for @forecastRoadLine.
  ///
  /// In vi, this message translates to:
  /// **'Đường quanh ga: {status}'**
  String forecastRoadLine(String status);

  /// No description provided for @forecastNowPeak.
  ///
  /// In vi, this message translates to:
  /// **'Đang đông, thường đến {time}'**
  String forecastNowPeak(String time);

  /// No description provided for @forecastNextPeak.
  ///
  /// In vi, this message translates to:
  /// **'Thường đông {from}–{to}'**
  String forecastNextPeak(String from, String to);

  /// No description provided for @forecastNoPeak.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay không còn giờ đông'**
  String get forecastNoPeak;

  /// No description provided for @forecastEstimate.
  ///
  /// In vi, this message translates to:
  /// **'Ước tính theo khung giờ và vị trí ga, chưa phải số đo thực tế.'**
  String get forecastEstimate;

  /// No description provided for @forecastTipNow.
  ///
  /// In vi, this message translates to:
  /// **'Ga {station} đang đông, thường tới {time} mới vãn nha.'**
  String forecastTipNow(String station, String time);

  /// No description provided for @forecastTipBefore.
  ///
  /// In vi, this message translates to:
  /// **'Đi trước {time} để tránh giờ đông ở ga {station} nha.'**
  String forecastTipBefore(String time, String station);

  /// No description provided for @forecastMapChip.
  ///
  /// In vi, this message translates to:
  /// **'Độ đông'**
  String get forecastMapChip;

  /// No description provided for @studentTakePhoto.
  ///
  /// In vi, this message translates to:
  /// **'Chụp thẻ'**
  String get studentTakePhoto;

  /// No description provided for @studentChoosePhoto.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ảnh'**
  String get studentChoosePhoto;

  /// No description provided for @studentRetake.
  ///
  /// In vi, this message translates to:
  /// **'Chụp lại'**
  String get studentRetake;

  /// No description provided for @studentConsent.
  ///
  /// In vi, this message translates to:
  /// **'Mình đồng ý gửi ảnh thẻ để AI đọc thông tin. Ảnh chỉ dùng để xác thực và được xóa sau khi có kết quả.'**
  String get studentConsent;

  /// No description provided for @studentPickFailed.
  ///
  /// In vi, this message translates to:
  /// **'Chưa mở được camera hoặc thư viện ảnh. Kiểm tra quyền truy cập rồi thử lại nha.'**
  String get studentPickFailed;

  /// No description provided for @studentFieldName.
  ///
  /// In vi, this message translates to:
  /// **'Họ tên'**
  String get studentFieldName;

  /// No description provided for @studentFieldSchool.
  ///
  /// In vi, this message translates to:
  /// **'Trường'**
  String get studentFieldSchool;

  /// No description provided for @studentFieldCode.
  ///
  /// In vi, this message translates to:
  /// **'Mã sinh viên'**
  String get studentFieldCode;

  /// No description provided for @studentDemoLabel.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả demo:'**
  String get studentDemoLabel;

  /// No description provided for @studentDemoPass.
  ///
  /// In vi, this message translates to:
  /// **'Đạt'**
  String get studentDemoPass;

  /// No description provided for @studentVerifyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận sinh viên'**
  String get studentVerifyTitle;

  /// No description provided for @studentTip.
  ///
  /// In vi, this message translates to:
  /// **'Chụp mặt trước thẻ sinh viên, thấy rõ họ tên, trường và hạn thẻ nha.'**
  String get studentTip;

  /// No description provided for @studentCheck.
  ///
  /// In vi, this message translates to:
  /// **'Gửi duyệt'**
  String get studentCheck;

  /// No description provided for @studentVerified.
  ///
  /// In vi, this message translates to:
  /// **'Đã xác nhận sinh viên'**
  String get studentVerified;

  /// No description provided for @studentValidUntil.
  ///
  /// In vi, this message translates to:
  /// **'Hiệu lực đến {date}'**
  String studentValidUntil(String date);

  /// No description provided for @studentBenefitSingle.
  ///
  /// In vi, this message translates to:
  /// **'Giảm 20% vé lượt'**
  String get studentBenefitSingle;

  /// No description provided for @studentBenefitMonth.
  ///
  /// In vi, this message translates to:
  /// **'Mua được vé tháng HSSV'**
  String get studentBenefitMonth;

  /// No description provided for @studentRenewNote.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi năm xác nhận lại một lần để giữ ưu đãi.'**
  String get studentRenewNote;

  /// No description provided for @studentRenewSoon.
  ///
  /// In vi, this message translates to:
  /// **'Còn {days} ngày, xác nhận lại sớm để không gián đoạn ưu đãi'**
  String studentRenewSoon(int days);

  /// No description provided for @studentRenew.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận lại'**
  String get studentRenew;

  /// No description provided for @studentWaitTitle.
  ///
  /// In vi, this message translates to:
  /// **'Duyệt thẻ có thể mất đến 24 giờ'**
  String get studentWaitTitle;

  /// No description provided for @studentWaitBody.
  ///
  /// In vi, this message translates to:
  /// **'Nên xác nhận trước khi cần đi. Đi gấp thì mua vé ngày giá thường để lên tàu ngay; giá sinh viên áp dụng cho vé mua sau khi được duyệt.'**
  String get studentWaitBody;

  /// No description provided for @studentBuyDay.
  ///
  /// In vi, this message translates to:
  /// **'Mua vé ngày'**
  String get studentBuyDay;

  /// No description provided for @studentPendingTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đang duyệt thẻ của bạn'**
  String get studentPendingTitle;

  /// No description provided for @studentPendingBody.
  ///
  /// In vi, this message translates to:
  /// **'Bạn không cần chờ ở đây. HopOn sẽ báo khi có kết quả.'**
  String get studentPendingBody;

  /// No description provided for @studentSubmittedAt.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi lúc {time}'**
  String studentSubmittedAt(String time);

  /// No description provided for @studentStillActive.
  ///
  /// In vi, this message translates to:
  /// **'Ưu đãi hiện tại vẫn dùng được đến {date}'**
  String studentStillActive(String date);

  /// No description provided for @studentDone.
  ///
  /// In vi, this message translates to:
  /// **'Xong'**
  String get studentDone;

  /// No description provided for @studentCardNone.
  ///
  /// In vi, this message translates to:
  /// **'Giảm 20% vé lượt, mua được vé tháng HSSV'**
  String get studentCardNone;

  /// No description provided for @studentCardPending.
  ///
  /// In vi, this message translates to:
  /// **'Đang duyệt, HopOn sẽ báo khi có kết quả'**
  String get studentCardPending;

  /// No description provided for @studentCardRejected.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đạt, chạm để xem lý do và gửi lại'**
  String get studentCardRejected;

  /// No description provided for @studentCardExpired.
  ///
  /// In vi, this message translates to:
  /// **'Đã hết hiệu lực, xác nhận lại để giữ ưu đãi'**
  String get studentCardExpired;

  /// No description provided for @studentNoticeNeeded.
  ///
  /// In vi, this message translates to:
  /// **'Vé này cần xác nhận sinh viên, việc duyệt có thể mất đến 24 giờ.'**
  String get studentNoticeNeeded;

  /// No description provided for @studentNoticePending.
  ///
  /// In vi, this message translates to:
  /// **'Thẻ của bạn đang được duyệt. Cần đi ngay thì mua vé ngày trước nha.'**
  String get studentNoticePending;

  /// No description provided for @studentConfirmAction.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận ngay'**
  String get studentConfirmAction;

  /// No description provided for @studentUseDay.
  ///
  /// In vi, this message translates to:
  /// **'Chọn vé ngày'**
  String get studentUseDay;

  /// No description provided for @studentDemoExpiring.
  ///
  /// In vi, this message translates to:
  /// **'Sắp hết hạn'**
  String get studentDemoExpiring;

  /// No description provided for @studentDemoExpired.
  ///
  /// In vi, this message translates to:
  /// **'Hết hạn'**
  String get studentDemoExpired;

  /// No description provided for @studentDemoFail.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get studentDemoFail;

  /// No description provided for @greenTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hành trình xanh'**
  String get greenTitle;

  /// No description provided for @cpointScaleTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ưu đãi theo CPoint'**
  String get cpointScaleTitle;

  /// No description provided for @cpointAmount.
  ///
  /// In vi, this message translates to:
  /// **'{amount} CPoint'**
  String cpointAmount(String amount);

  /// No description provided for @cpointDiscount.
  ///
  /// In vi, this message translates to:
  /// **'{amount} · Giảm {percent}% mọi vé'**
  String cpointDiscount(String amount, int percent);

  /// No description provided for @cpointRule.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi 1 kg CO₂ bớt được = {perKg} CPoint. Giảm tự động khi thanh toán, CPoint không bị trừ.'**
  String cpointRule(int perKg);

  /// No description provided for @greenFutuStart.
  ///
  /// In vi, this message translates to:
  /// **'Đi chuyến đầu tiên để Trái Đất xanh hơn nha!'**
  String get greenFutuStart;

  /// No description provided for @greenFutuNext.
  ///
  /// In vi, this message translates to:
  /// **'Còn {kg} kg nữa là lên cấp {tier} đó!'**
  String greenFutuNext(String kg, String tier);

  /// No description provided for @greenFutuTop.
  ///
  /// In vi, this message translates to:
  /// **'Cấp cao nhất rồi! Trái Đất cảm ơn bạn nha.'**
  String get greenFutuTop;

  /// No description provided for @greenFutuTipCount.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi vé lượt đi xong được cộng CO₂ đã bớt và CPoint.'**
  String get greenFutuTipCount;

  /// No description provided for @greenFutuTipSpin.
  ///
  /// In vi, this message translates to:
  /// **'Kéo Trái Đất sang ngang để xoay thử nha!'**
  String get greenFutuTipSpin;

  /// No description provided for @greenEarthLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mô hình Trái Đất, kéo ngang để xoay'**
  String get greenEarthLabel;

  /// No description provided for @greenEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có chuyến nào'**
  String get greenEmpty;

  /// No description provided for @greenSavedKg.
  ///
  /// In vi, this message translates to:
  /// **'≈ {kg} kg CO₂'**
  String greenSavedKg(Object kg);

  /// No description provided for @greenSummaryLine.
  ///
  /// In vi, this message translates to:
  /// **'{trips} chuyến · {km} km'**
  String greenSummaryLine(Object trips, Object km);

  /// No description provided for @greenTierSeed.
  ///
  /// In vi, this message translates to:
  /// **'Hạt mầm'**
  String get greenTierSeed;

  /// No description provided for @greenTierSprout.
  ///
  /// In vi, this message translates to:
  /// **'Chồi non'**
  String get greenTierSprout;

  /// No description provided for @greenTierTree.
  ///
  /// In vi, this message translates to:
  /// **'Cây xanh'**
  String get greenTierTree;

  /// No description provided for @greenTierForest.
  ///
  /// In vi, this message translates to:
  /// **'Khu rừng'**
  String get greenTierForest;

  /// No description provided for @greenCalculatorTitle.
  ///
  /// In vi, this message translates to:
  /// **'So sánh quãng đường'**
  String get greenCalculatorTitle;

  /// No description provided for @greenNoRoute.
  ///
  /// In vi, this message translates to:
  /// **'Hai ga này chưa có lộ trình để tính.'**
  String get greenNoRoute;

  /// No description provided for @greenDistance.
  ///
  /// In vi, this message translates to:
  /// **'≈ {km} km'**
  String greenDistance(Object km);

  /// No description provided for @greenModeCar.
  ///
  /// In vi, this message translates to:
  /// **'Ô tô'**
  String get greenModeCar;

  /// No description provided for @greenModeMotorbike.
  ///
  /// In vi, this message translates to:
  /// **'Xe máy'**
  String get greenModeMotorbike;

  /// No description provided for @greenModeMetro.
  ///
  /// In vi, this message translates to:
  /// **'Metro'**
  String get greenModeMetro;

  /// No description provided for @greenKg.
  ///
  /// In vi, this message translates to:
  /// **'{kg} kg CO₂'**
  String greenKg(Object kg);

  /// No description provided for @greenMethodTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cách tính'**
  String get greenMethodTitle;

  /// No description provided for @greenFormula.
  ///
  /// In vi, this message translates to:
  /// **'Quãng đường × (xe máy − metro)'**
  String get greenFormula;

  /// No description provided for @greenFactors.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi km một người: ô tô 0,101 kg · xe máy 0,062 kg · metro 0,034 kg'**
  String get greenFactors;

  /// No description provided for @greenDisclaimer.
  ///
  /// In vi, this message translates to:
  /// **'Số ước tính, chỉ tính vé lượt đã đi xong.'**
  String get greenDisclaimer;

  /// No description provided for @trainsLive.
  ///
  /// In vi, this message translates to:
  /// **'{count} tàu đang chạy'**
  String trainsLive(Object count);

  /// No description provided for @trainsSimulated.
  ///
  /// In vi, this message translates to:
  /// **'{count} tàu · mô phỏng'**
  String trainsSimulated(Object count);

  /// No description provided for @nextTrainIn.
  ///
  /// In vi, this message translates to:
  /// **'Tàu tới sau {eta}'**
  String nextTrainIn(Object eta);

  /// No description provided for @mascotExpiring.
  ///
  /// In vi, this message translates to:
  /// **'Ôi! {name} còn {hours} giờ là hết hạn đó.'**
  String mascotExpiring(Object name, Object hours);

  /// No description provided for @mascotExpiringSoon.
  ///
  /// In vi, this message translates to:
  /// **'Ôi! {name} sắp hết hạn trong chưa đầy 1 giờ.'**
  String mascotExpiringSoon(Object name);

  /// No description provided for @mascotTierUp.
  ///
  /// In vi, this message translates to:
  /// **'Tuyệt quá! Bạn lên {tier} rồi!'**
  String mascotTierUp(Object tier);

  /// No description provided for @greenShare.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ thành tích'**
  String get greenShare;

  /// No description provided for @greenShareTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thẻ thành tích xanh'**
  String get greenShareTitle;

  /// No description provided for @greenShareMonth.
  ///
  /// In vi, this message translates to:
  /// **'Tháng này mình đã bớt'**
  String get greenShareMonth;

  /// No description provided for @greenShareTotal.
  ///
  /// In vi, this message translates to:
  /// **'Mình đã bớt'**
  String get greenShareTotal;

  /// No description provided for @greenShareBy.
  ///
  /// In vi, this message translates to:
  /// **'nhờ đi Metro thay vì xe máy'**
  String get greenShareBy;

  /// No description provided for @greenShareStats.
  ///
  /// In vi, this message translates to:
  /// **'{trips} chuyến · {km} km · {days} ngày hấp thụ CO₂ của một cây'**
  String greenShareStats(Object trips, Object km, Object days);

  /// No description provided for @greenShareEstimate.
  ///
  /// In vi, this message translates to:
  /// **'Số ước tính từ app HopOn'**
  String get greenShareEstimate;

  /// No description provided for @greenShareText.
  ///
  /// In vi, this message translates to:
  /// **'Mình đã bớt {kg} kg CO₂ nhờ đi Metro cùng HopOn. Đi cùng mình nhé!'**
  String greenShareText(Object kg);

  /// No description provided for @greenShareFailed.
  ///
  /// In vi, this message translates to:
  /// **'Chưa chia sẻ được, vui lòng thử lại'**
  String get greenShareFailed;

  /// No description provided for @mascotPaidTicket.
  ///
  /// In vi, this message translates to:
  /// **'Xong rồi nè! Mở QR là lên tàu thôi.'**
  String get mascotPaidTicket;

  /// No description provided for @mascotPaidParking.
  ///
  /// In vi, this message translates to:
  /// **'Xong rồi nè! Futu giữ chỗ cho xe của bạn rồi.'**
  String get mascotPaidParking;

  /// No description provided for @mascotPaidFailed.
  ///
  /// In vi, this message translates to:
  /// **'Ui, chưa thanh toán được. Bạn chưa bị trừ tiền đâu.'**
  String get mascotPaidFailed;

  /// No description provided for @mascotPaidRefund.
  ///
  /// In vi, this message translates to:
  /// **'Futu đang xử lý hoàn tiền, đợi chút nha.'**
  String get mascotPaidRefund;

  /// No description provided for @mascotParkingLot.
  ///
  /// In vi, this message translates to:
  /// **'Chọn loại xe và bãi trước nha.'**
  String get mascotParkingLot;

  /// No description provided for @mascotParkingInfo.
  ///
  /// In vi, this message translates to:
  /// **'Nhập biển số và chọn gói nha.'**
  String get mascotParkingInfo;

  /// No description provided for @mascotParkingConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xem lại lần cuối rồi thanh toán nha!'**
  String get mascotParkingConfirm;

  /// No description provided for @mascotBookingChoose.
  ///
  /// In vi, this message translates to:
  /// **'Chọn loại vé và hai ga nha!'**
  String get mascotBookingChoose;

  /// No description provided for @mascotBookingConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xem lại vé và ưu đãi nha.'**
  String get mascotBookingConfirm;

  /// No description provided for @mascotRegister.
  ///
  /// In vi, this message translates to:
  /// **'Điền vài thông tin, Futu gửi mã qua email nha.'**
  String get mascotRegister;

  /// No description provided for @greenBookedTrip.
  ///
  /// In vi, this message translates to:
  /// **'Chuyến này ≈ {kg} kg CO₂, cộng khi đi xong'**
  String greenBookedTrip(Object kg);

  /// No description provided for @greenBookedPass.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi 10 km ≈ {kg} kg CO₂'**
  String greenBookedPass(Object kg);

  /// No description provided for @greenBookedParking.
  ///
  /// In vi, this message translates to:
  /// **'Gửi xe rồi đi metro: mỗi 10 km ≈ {kg} kg CO₂'**
  String greenBookedParking(Object kg);

  /// No description provided for @greenNextTier.
  ///
  /// In vi, this message translates to:
  /// **'{tier} · còn {kg} kg lên cấp'**
  String greenNextTier(Object tier, Object kg);

  /// No description provided for @futuMorning.
  ///
  /// In vi, this message translates to:
  /// **'Sáng rồi {name} ơi! Mình đi đâu đây?'**
  String futuMorning(Object name);

  /// No description provided for @futuAfternoon.
  ///
  /// In vi, this message translates to:
  /// **'Chiều vui nha {name}! Đi đâu nè?'**
  String futuAfternoon(Object name);

  /// No description provided for @futuEvening.
  ///
  /// In vi, this message translates to:
  /// **'Tối rồi {name} ơi, về nhà thôi!'**
  String futuEvening(Object name);

  /// No description provided for @futuLoginTitle.
  ///
  /// In vi, this message translates to:
  /// **'{name} về rồi!'**
  String futuLoginTitle(Object name);

  /// No description provided for @futuLoginBody.
  ///
  /// In vi, this message translates to:
  /// **'Futu vui quá, lên tàu thôi nào!'**
  String get futuLoginBody;

  /// No description provided for @futuLogoutTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đi thật hả?'**
  String get futuLogoutTitle;

  /// No description provided for @futuLogoutBody.
  ///
  /// In vi, this message translates to:
  /// **'Futu sẽ nhớ bạn lắm đó...'**
  String get futuLogoutBody;

  /// No description provided for @greenCompared.
  ///
  /// In vi, this message translates to:
  /// **'bớt được so với đi xe máy'**
  String get greenCompared;

  /// No description provided for @greenTierProgress.
  ///
  /// In vi, this message translates to:
  /// **'{kg} / {target} kg'**
  String greenTierProgress(Object kg, Object target);

  /// No description provided for @greenStatTrips.
  ///
  /// In vi, this message translates to:
  /// **'chuyến'**
  String get greenStatTrips;

  /// No description provided for @greenStatKm.
  ///
  /// In vi, this message translates to:
  /// **'km'**
  String get greenStatKm;

  /// No description provided for @greenStatTreeDays.
  ///
  /// In vi, this message translates to:
  /// **'ngày cây hấp thụ'**
  String get greenStatTreeDays;

  /// No description provided for @greenTripSaved.
  ///
  /// In vi, this message translates to:
  /// **'Đi metro bớt {kg} kg so với xe máy'**
  String greenTripSaved(Object kg);

  /// No description provided for @greenTrain.
  ///
  /// In vi, this message translates to:
  /// **'1 đoàn tàu ≈ {bikes} xe máy khỏi ra đường'**
  String greenTrain(Object bikes);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
