// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appSlogan => 'A new era, a new motion';

  @override
  String get navHome => 'Home';

  @override
  String get navExplore => 'Explore';

  @override
  String get navTickets => 'Tickets';

  @override
  String get navAccount => 'Account';

  @override
  String get navScan => 'Check';

  @override
  String get navParking => 'Parking';

  @override
  String get navHistory => 'History';

  @override
  String get accountTitle => 'Account';

  @override
  String get rolePassenger => 'Passenger';

  @override
  String get roleStaff => 'Ticket inspector';

  @override
  String get menuProfile => 'Profile';

  @override
  String get menuTransactions => 'Transactions';

  @override
  String get menuLoyalty => 'Membership';

  @override
  String get menuNotificationSettings => 'Notification settings';

  @override
  String get menuNews => 'Metro news';

  @override
  String get menuStaffProfile => 'Staff profile';

  @override
  String get menuStation => 'Assigned station';

  @override
  String comingSoon(String item) {
    return '$item is coming soon';
  }

  @override
  String get settingsTitle => 'App settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get appearanceSystem => 'System';

  @override
  String get appearanceLight => 'Light';

  @override
  String get appearanceDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get logout => 'Log out';

  @override
  String get logoutConfirmTitle => 'Log out?';

  @override
  String get logoutConfirmBody => 'You will need to sign in again to continue.';

  @override
  String get cancel => 'Cancel';

  @override
  String get unsupportedTitle => 'Please use the web admin portal';

  @override
  String get unsupportedBody =>
      'This account cannot be used in the mobile app. Sign in to the Metro admin portal on a computer.';

  @override
  String get placeholderTitle => 'Coming soon';

  @override
  String placeholderBody(int phase) {
    return 'This screen is part of phase $phase.';
  }

  @override
  String get errNetwork => 'No network connection';

  @override
  String get errUnauthorized => 'Incorrect sign-in details';

  @override
  String get errForbidden => 'You are not allowed to do this';

  @override
  String get errNotFound => 'Data not found';

  @override
  String get errConflict => 'Data has changed';

  @override
  String get errValidation => 'Invalid data';

  @override
  String get errServer => 'The system is busy, please try again later';

  @override
  String get errAccountLocked => 'This account has been locked';

  @override
  String get valEmailRequired => 'Please enter your email';

  @override
  String get valEmailInvalid => 'Invalid email';

  @override
  String get valPasswordLength => 'Password must be at least 8 characters';

  @override
  String get valPasswordMismatch => 'Passwords do not match';

  @override
  String get valPasswordRequired => 'Please enter your password';

  @override
  String get valNameRequired => 'Please enter your full name';

  @override
  String get valTermsRequired => 'Please accept the terms of use';

  @override
  String get valOtpFormat => 'The OTP code has 6 digits';

  @override
  String get errOtpInvalid => 'Invalid OTP code';

  @override
  String get errAccountExists => 'This account already exists';

  @override
  String get valQuestionRequired => 'Please enter a question';

  @override
  String get valQuestionLength => 'Questions are limited to 300 characters';

  @override
  String get valStationsRequired =>
      'Please choose departure and arrival stations';

  @override
  String get valStationsSame => 'Departure and arrival stations are the same';

  @override
  String get errStationNotFound => 'Station not found';

  @override
  String get errRouteNotFound => 'No suitable route found';

  @override
  String get errOrderNotFound => 'Order not found';

  @override
  String get errTicketNotFound => 'Ticket not found';

  @override
  String get errParkingNotFound => 'Parking pass not found';

  @override
  String get errParkingOtherLot => 'This parking pass belongs to another lot';

  @override
  String get errLotNotFound => 'Parking lot not found';

  @override
  String get errParkingActive =>
      'This vehicle already has an active parking pass';

  @override
  String get errParkingFull => 'No spaces left for this vehicle type';

  @override
  String get valPlateRequired => 'Please enter the licence plate';

  @override
  String get valPlateInvalid => 'Invalid licence plate format';

  @override
  String get errQrWrongKind => 'Wrong type of QR code';

  @override
  String get errMandatoryNotification =>
      'Mandatory notifications cannot be turned off';

  @override
  String get errMandatoryNotificationKinds =>
      'Operations and payment result notifications are mandatory';

  @override
  String errStationInactive(String name) {
    return 'Station $name is not in operation yet';
  }

  @override
  String get notSelected => 'not selected';

  @override
  String get chooseStation => 'Choose station';

  @override
  String get liveConnected => 'Live';

  @override
  String get liveReconnecting => 'Reconnecting…';

  @override
  String get loadFailed => 'Could not load data';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get retry => 'Try again';

  @override
  String get interchangeStation => 'Interchange station';

  @override
  String get stationClosed => 'Closed';

  @override
  String sinceTime(String time) {
    return 'Since $time';
  }

  @override
  String get feedbackHelpful => 'Helpful';

  @override
  String get feedbackNotHelpful => 'Not helpful';

  @override
  String routeMinutesApprox(int minutes) {
    return '~$minutes min';
  }

  @override
  String stationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stations',
      one: '1 station',
    );
    return '$_temp0';
  }

  @override
  String transferCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transfers',
      one: '1 transfer',
    );
    return '$_temp0';
  }

  @override
  String validUntilShort(String date) {
    return 'Valid until $date';
  }

  @override
  String get openQr => 'Open QR';

  @override
  String get details => 'Details';

  @override
  String fromTo(String from, String to) {
    return '$from to $to';
  }

  @override
  String timeLeft(String time) {
    return '$time left';
  }

  @override
  String get stationSearchHint => 'Search stations, e.g. ben thanh';

  @override
  String get stationSearchEmptyHint => 'Try another name, e.g. \"suoi tien\"';

  @override
  String get recent => 'Recent';

  @override
  String get loading => 'Loading';

  @override
  String get password => 'Password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get torchOn => 'Turn on flash';

  @override
  String get torchOff => 'Turn off flash';

  @override
  String get newCode => 'New code';

  @override
  String get codeExpired => 'Code expired';

  @override
  String get paymentScanHint => 'Scan with any banking or e-wallet app';

  @override
  String get amount => 'Amount';

  @override
  String get orderCode => 'Order code';

  @override
  String get cancelTransaction => 'Cancel transaction';

  @override
  String get paymentWaiting => 'Waiting for payment confirmation…';

  @override
  String trainLabel(String id) {
    return 'Train $id';
  }

  @override
  String get checking => 'Checking…';

  @override
  String get scanHint => 'Place the QR code inside the frame';

  @override
  String get yourLocation => 'Your location';

  @override
  String busStopLabel(String name) {
    return 'Bus stop $name';
  }

  @override
  String get ticketInactive => 'Ticket is no longer valid';

  @override
  String get qrCode => 'QR code';

  @override
  String get trainApproaching => 'Train approaching';

  @override
  String refreshIn(String time) {
    return 'Refreshes in $time';
  }

  @override
  String get vehicleMotorbike => 'Motorbike';

  @override
  String get vehicleBicycle => 'Bicycle';

  @override
  String get vehicleCar => 'Car';

  @override
  String get strengthWeak => 'Weak';

  @override
  String get strengthFair => 'Fair';

  @override
  String get strengthGood => 'Good';

  @override
  String get strengthStrong => 'Strong';

  @override
  String get statusActive => 'Active';

  @override
  String get statusInactive => 'Inactive';

  @override
  String get statusPendingPayment => 'Awaiting payment';

  @override
  String get statusPaid => 'Unused';

  @override
  String get statusInUse => 'In use';

  @override
  String get statusUsed => 'Used';

  @override
  String get statusExpired => 'Expired';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusRefunded => 'Refunded';

  @override
  String get statusSuccess => 'Successful';

  @override
  String get statusFailed => 'Failed';

  @override
  String get statusNotParked => 'Not parked';

  @override
  String get statusParked => 'Parked';

  @override
  String get statusPickedUp => 'Picked up';

  @override
  String get login => 'Sign in';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get register => 'Sign up';

  @override
  String demoPassword(String password) {
    return 'Demo password: $password';
  }

  @override
  String get forgotPasswordTitle => 'Forgot password';

  @override
  String get forgotPasswordIntro =>
      'Enter your registered email and we\'ll send a 6-digit code to reset your password.';

  @override
  String get registerTitle => 'Create account';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get newPassword => 'New password';

  @override
  String get resetSessionExpired => 'Reset session expired';

  @override
  String get resetSessionExpiredBody =>
      'Please start the forgot password step again.';

  @override
  String get otpTitleRegister => 'Verify email';

  @override
  String get otpTitleReset => 'Reset password';

  @override
  String get otpSentTo => 'A 6-digit code was sent to ';

  @override
  String demoOtp(String otp) {
    return 'Demo OTP: $otp';
  }

  @override
  String lockedBanner(String message) {
    return '$message. Please contact the help desk at the station.';
  }

  @override
  String get resetPasswordDone => 'Password changed, please sign in';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get saveNewPassword => 'Save new password';

  @override
  String get registeredEmail => 'Registered email';

  @override
  String get sendCode => 'Send verification code';

  @override
  String environment(String flavor) {
    return 'Environment: $flavor';
  }

  @override
  String resendCodeIn(int seconds) {
    return 'Resend code (in ${seconds}s)';
  }

  @override
  String get resendCode => 'Resend code';

  @override
  String get otpResent => 'Futu sent a new code, check your mail!';

  @override
  String get confirm => 'Confirm';

  @override
  String get fullName => 'Full name';

  @override
  String get otpWillBeSent => 'The OTP code will be sent to this email';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get continueLabel => 'Continue';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPasswordLink => 'Forgot password?';

  @override
  String get otpExpired => 'The code has expired, please resend it.';

  @override
  String expiresIn(String time) {
    return 'Expires in $time';
  }

  @override
  String get agreeTo => 'I agree to the ';

  @override
  String get termsOfUse => 'Terms of use';

  @override
  String arrivalsAtStation(String station) {
    return 'Next trains · $station station';
  }

  @override
  String get quickBook => 'Quick booking';

  @override
  String get fares => 'Fares';

  @override
  String get pay => 'Pay';

  @override
  String get chooseFrom => 'Choose departure';

  @override
  String get chooseTo => 'Choose destination';

  @override
  String get fromShort => 'From';

  @override
  String get to => 'To';

  @override
  String get swap => 'Swap';

  @override
  String memberChip(String tier, String points) {
    return '$tier · $points CPoint';
  }

  @override
  String get notifications => 'Notifications';

  @override
  String get activePasses => 'Active passes';

  @override
  String get viewAll => 'View all';

  @override
  String get noActivePasses => 'No active passes';

  @override
  String get cancelTransactionTitle => 'Cancel transaction?';

  @override
  String get cancelTransactionBody =>
      'No ticket will be created. You can book again later.';

  @override
  String get continuePayment => 'Continue payment';

  @override
  String get fareTableTitle => 'Fare table';

  @override
  String get fareTableNote =>
      'Prices include VAT. Offers and CPoint discounts apply at checkout.';

  @override
  String get bookingConfirmTitle => 'Confirm ticket';

  @override
  String get noStationsNeeded => 'No stations needed';

  @override
  String get fare => 'Fare';

  @override
  String payByQr(String amount) {
    return 'Pay by QR · $amount';
  }

  @override
  String usePoints(int points) {
    return 'Use $points points';
  }

  @override
  String pointsAvailable(String points) {
    return '$points points available';
  }

  @override
  String fareTierFrom(int count) {
    return '$count stations or more';
  }

  @override
  String fareTierRange(int from, int to) {
    return '$from – $to stations';
  }

  @override
  String get singleFareTitle => 'Single journey (by stations travelled)';

  @override
  String get periodPassTitle => 'Period passes';

  @override
  String get paymentCodeExpired => 'Payment code expired';

  @override
  String get paymentFailed => 'Payment failed';

  @override
  String get paymentFailedBody =>
      'You have not been charged. Please book again.';

  @override
  String get refundPendingTitle => 'Processing refund';

  @override
  String get refundPendingBody =>
      'We could not issue your ticket. You will be refunded within 1–3 business days.';

  @override
  String refundCode(String code) {
    return 'Reference: $code';
  }

  @override
  String get viewTransactions => 'View transaction history';

  @override
  String get backHome => 'Back to home';

  @override
  String get paymentSuccess => 'Payment successful';

  @override
  String get openParkingQr => 'Open parking QR';

  @override
  String get openTicketQr => 'Open ticket QR';

  @override
  String get networkMapTitle => 'Network map';

  @override
  String get stationDetailTitle => 'Station details';

  @override
  String stationName(String name) {
    return '$name station';
  }

  @override
  String get line => 'Line';

  @override
  String get lineNotFound => 'Line not found';

  @override
  String get metroLines => 'Metro lines';

  @override
  String get routeSearchTitle => 'Route search';

  @override
  String get routeNotFound => 'No route found';

  @override
  String get routeNotFoundBody =>
      'These stations are not connected by an operating line.';

  @override
  String transferTo(String line) {
    return 'Transfer to $line';
  }

  @override
  String changeTo(String line) {
    return 'Change to $line (~3 min)';
  }

  @override
  String minutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get direct => 'Direct';

  @override
  String get map => 'Map';

  @override
  String get book => 'Book';

  @override
  String get exits => 'Exits';

  @override
  String get from => 'From';

  @override
  String get findRoute => 'Find route';

  @override
  String get noAmenities => 'No amenity data around this station yet';

  @override
  String get inOperation => 'In operation';

  @override
  String get notInOperation => 'Not in operation';

  @override
  String get tabOverview => 'Overview';

  @override
  String get tabNearby => 'Nearby';

  @override
  String get tabBus => 'Bus';

  @override
  String get bookFromHere => 'Book from here';

  @override
  String get viewMap => 'View map';

  @override
  String get noBusStops => 'No connecting bus stops';

  @override
  String walkMinutes(int minutes) {
    return '$minutes min walk';
  }

  @override
  String get arriving => 'Arriving';

  @override
  String etaMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get nextTrains => 'Next trains';

  @override
  String get arrivalsFailed => 'Could not load train times';

  @override
  String get noArrivals => 'No trains approaching';

  @override
  String get routeLookup => 'Routes';

  @override
  String get nearbyStations => 'Nearby stations';

  @override
  String get linePlanned => 'Planned';

  @override
  String get inService => 'In service';

  @override
  String get linePlannedNote =>
      'This line is planned and not yet in service. Information is for reference only.';

  @override
  String get tapMapToPick => 'Tap the map to choose your location';

  @override
  String get locationServiceOff => 'Location services are off.';

  @override
  String get locationDeniedForever =>
      'You blocked location access. Turn it back on in Settings.';

  @override
  String get locationRationale =>
      'The app needs your location for this session to find nearby stations. Your location is not stored.';

  @override
  String get enableLocation => 'Enable location';

  @override
  String get pickOnMap => 'Pick on map';

  @override
  String get noLines => 'No lines yet';

  @override
  String get searchStation => 'Search stations';

  @override
  String get all => 'All';

  @override
  String get bus => 'Bus';

  @override
  String get findNearby => 'Find nearby stations';

  @override
  String get findNearMe => 'Find stations near me';

  @override
  String get byPickedLocation => 'Based on the location you picked';

  @override
  String get structureUnderground => 'Underground';

  @override
  String get structureElevated => 'Elevated';

  @override
  String get structureAtGrade => 'At grade';

  @override
  String get myTickets => 'My tickets';

  @override
  String get trainTickets => 'Train tickets';

  @override
  String get noTransactions => 'No transactions yet';

  @override
  String get parkingEnded => 'This parking session has ended';

  @override
  String get noParkingPasses => 'No parking yet';

  @override
  String get registerParking => 'Book parking';

  @override
  String get allShown => 'All items shown';

  @override
  String get noTickets => 'You don\'t have any tickets yet';

  @override
  String noTicketsFiltered(String filter) {
    return 'No $filter tickets';
  }

  @override
  String get bookNow => 'Book now';

  @override
  String get filterUnused => 'Unused';

  @override
  String get filterInUse => 'In use';

  @override
  String validUntil(String date) {
    return 'Valid until $date';
  }

  @override
  String get ticketQrHint =>
      'Show the QR code to the scanner or to station staff.';

  @override
  String get close => 'Close';

  @override
  String codeLabel(String code) {
    return 'Code: $code';
  }

  @override
  String enteredAt(String time) {
    return 'Entered at $time';
  }

  @override
  String get lot => 'Lot';

  @override
  String get plate => 'Licence plate';

  @override
  String get bicycleNoPlate => 'Bicycles do not need a plate';

  @override
  String get vehicleType => 'Vehicle type';

  @override
  String get package => 'Package';

  @override
  String get packageTurn => 'Single';

  @override
  String get packageDay => 'Day';

  @override
  String get packageMonth => 'Month';

  @override
  String get feeEmpty => 'Fee: —';

  @override
  String fee(String amount) {
    return 'Fee $amount';
  }

  @override
  String get activePassBanner =>
      'This vehicle already has an active parking pass.';

  @override
  String get lotNoVehicleType => 'This lot does not accept this vehicle type';

  @override
  String get available => 'Available';

  @override
  String until(String date) {
    return 'Until $date';
  }

  @override
  String get membership => 'Membership';

  @override
  String tierBenefits(String tier) {
    return '$tier tier benefits';
  }

  @override
  String get activePromotions => 'Current promotions';

  @override
  String get noPromotions => 'No promotions right now';

  @override
  String get pointsHistory => 'Points history';

  @override
  String tierTitle(String tier) {
    return '$tier tier';
  }

  @override
  String points(String points) {
    return '$points points';
  }

  @override
  String get topTier => 'You are at the highest tier';

  @override
  String pointsToNext(String points, String tier) {
    return '$points points to $tier';
  }

  @override
  String get noPointsHistory => 'No points activity yet';

  @override
  String get markAllRead => 'Mark all as read';

  @override
  String get noNotifications => 'No notifications yet';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get noNews => 'No news yet';

  @override
  String get prefPush => 'Push notifications';

  @override
  String get prefPromotion => 'Promotions';

  @override
  String get prefSmart => 'Smart suggestions';

  @override
  String get prefSmartBody =>
      'Suggests money-saving tickets based on your travel habits';

  @override
  String get prefOperation => 'Operations';

  @override
  String get prefOperationBody =>
      'Mandatory: timetable changes, incidents, maintenance';

  @override
  String get prefPayment => 'Payment results';

  @override
  String get prefPaymentBody => 'Mandatory: confirmation of your transactions';

  @override
  String get operationNotice => 'Operations notice';

  @override
  String get assistantTitle => 'HopOn assistant';

  @override
  String get newSession => 'New chat';

  @override
  String get assistantTyping => 'Assistant is typing…';

  @override
  String get sendFailed => 'Could not send your question';

  @override
  String get askHint => 'Type a question…';

  @override
  String get send => 'Send';

  @override
  String get viewTicket => 'View ticket';

  @override
  String viewStation(String name) {
    return 'View $name station';
  }

  @override
  String get route => 'Route';

  @override
  String get scanEntry => 'Entry';

  @override
  String get scanExit => 'Exit';

  @override
  String get scanValid => 'VALID TICKET';

  @override
  String get scanInvalid => 'INVALID';

  @override
  String recordedAt(String time, String mode) {
    return 'Recorded: $time · $mode';
  }

  @override
  String rejectReason(String reason) {
    return 'Reason: $reason';
  }

  @override
  String ticketLabel(String ticket) {
    return 'Ticket: $ticket';
  }

  @override
  String currentStation(String station) {
    return 'Current station: $station';
  }

  @override
  String get scanNext => 'Scan next';

  @override
  String get rejectExpired => 'Ticket expired';

  @override
  String get rejectUsed => 'Ticket already used';

  @override
  String get rejectAlreadyIn => 'Ticket already checked in';

  @override
  String get rejectNotIn => 'Ticket has not been checked in';

  @override
  String get rejectWrongStation => 'Checked out at the wrong station';

  @override
  String get rejectNotFound => 'Ticket does not exist';

  @override
  String get rejectForbidden =>
      'You can only check tickets at your assigned station';

  @override
  String get errQrUnreadable => 'Could not read the QR code. Scan again';

  @override
  String get statEntries => 'in';

  @override
  String get statExits => 'out';

  @override
  String get statRejected => 'rejected';

  @override
  String get enterTicketCode => 'Enter ticket code';

  @override
  String get check => 'Check';

  @override
  String get cameraDeniedTitle => 'No camera access';

  @override
  String get cameraDeniedForever =>
      'Open Settings > Permissions > Camera to turn it back on. Meanwhile, use \"Enter ticket code manually\".';

  @override
  String get cameraRationale =>
      'The rear camera is needed to scan QR codes on passengers\' screens.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get grantCamera => 'Allow camera';

  @override
  String get manualCode => 'Enter ticket code manually';

  @override
  String get scanParkingQr => 'Scan parking QR';

  @override
  String get parkedAtLot => 'Parked at this lot';

  @override
  String get searchPlate => 'Search plate';

  @override
  String get noVehicles => 'No matching vehicles';

  @override
  String get result => 'Result';

  @override
  String parkedInAt(String time) {
    return 'In at $time';
  }

  @override
  String parkedOutAt(String time) {
    return 'Out at $time';
  }

  @override
  String get scanHistoryTitle => 'Scan history · Today';

  @override
  String get noScans => 'No scans yet';

  @override
  String get filterTickets => 'Tickets';

  @override
  String get filterRejected => 'Rejected';

  @override
  String get inShort => 'In';

  @override
  String get outShort => 'Out';

  @override
  String get viewQr => 'View QR';

  @override
  String ticketCodeExample(String code) {
    return 'e.g. $code';
  }

  @override
  String get viewDesignSystem => 'View Design System';

  @override
  String parkedSince(String time) {
    return 'since $time';
  }

  @override
  String get placeBus => 'Bus';

  @override
  String get placeHealth => 'Health';

  @override
  String get placeMarket => 'Markets & shops';

  @override
  String get placeFood => 'Food';

  @override
  String get placeEducation => 'Schools';

  @override
  String get placeLeisure => 'Leisure';

  @override
  String get placeServices => 'Services';

  @override
  String get kindHospital => 'Hospital';

  @override
  String get kindMarket => 'Market';

  @override
  String get kindShop => 'Shopping';

  @override
  String get kindFood => 'Food';

  @override
  String get kindSchool => 'School';

  @override
  String get kindPark => 'Park';

  @override
  String get kindLandmark => 'Landmark';

  @override
  String get kindAtm => 'ATM';

  @override
  String get kindParking => 'Parking';

  @override
  String get kindToilet => 'Restroom';

  @override
  String get kindBusStop => 'Bus stop';

  @override
  String get nearbyPlacesTitle => 'Around the station';

  @override
  String get stationShort => 'Station';

  @override
  String get networkDiagram => 'Diagram';

  @override
  String get diagramHint => 'Tap a station for details';

  @override
  String get buyTicket => 'Buy ticket';

  @override
  String get lineDiagram => 'Line map';

  @override
  String get newsTagOperation => 'Operations';

  @override
  String get newsTagNews => 'News';

  @override
  String get newsNotFound => 'This news item is no longer available';

  @override
  String get stepChoose => 'Ticket';

  @override
  String get stepConfirm => 'Confirm';

  @override
  String get stepPay => 'Pay';

  @override
  String singleTicketHint(String validity) {
    return 'Priced by stations · $validity';
  }

  @override
  String fromPrice(String price) {
    return 'from $price';
  }

  @override
  String get ticketTypeTitle => 'Choose a ticket type';

  @override
  String get journeyTitle => 'Journey';

  @override
  String get chooseDifferentStations =>
      'Choose two different stations to see the fare.';

  @override
  String get subtotal => 'Subtotal';

  @override
  String copied(String value) {
    return 'Copied $value';
  }

  @override
  String get copy => 'Copy';

  @override
  String get scanVietQr => 'Scan VietQR code';

  @override
  String get manualTransfer => 'Or transfer manually';

  @override
  String get bank => 'Bank';

  @override
  String get accountNumber => 'Account no.';

  @override
  String get accountName => 'Account name';

  @override
  String get transferContent => 'Reference';

  @override
  String get transferNote =>
      'Enter the exact amount and reference so your ticket is issued automatically.';

  @override
  String get transferNoteDemo =>
      'Demo build: do not send real money, the order confirms itself in a few seconds.';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get methodVietQr => 'VietQR bank transfer (SePay)';

  @override
  String get methodVietQrHint =>
      'Any bank or e-wallet · confirmed automatically';

  @override
  String get routeShort => 'Routes';

  @override
  String get errBadCredentials => 'Incorrect email or password';

  @override
  String get errEmailNotVerified => 'Email has not been verified';

  @override
  String get errRateLimited => 'Too many attempts, please try again later';

  @override
  String get errLoginLocked =>
      'Too many failed attempts, try again in 15 minutes';

  @override
  String get errCurrentPassword => 'Current password is incorrect';

  @override
  String get errEmailTaken => 'This email is already in use';

  @override
  String get valNameLength => 'Full name can have at most 120 characters';

  @override
  String get valPasswordTooLong => 'Password is too long';

  @override
  String get valPasswordBlank => 'Password cannot be only spaces';

  @override
  String get otpCode => 'OTP code';

  @override
  String otpSentIfExists(String email) {
    return 'If $email is registered, you will receive a 6-digit code by email.';
  }

  @override
  String get emailVerifiedDone => 'Email verified, please sign in';

  @override
  String get registerPendingCode =>
      'This email is awaiting verification. Enter the code already sent; the password you just entered was not saved.';

  @override
  String get profileSaved => 'Saved!';

  @override
  String get saveProfile => 'Save profile';

  @override
  String get currentPassword => 'Current password';

  @override
  String get changePassword => 'Change password';

  @override
  String get changePasswordHint =>
      'After changing it, all devices must sign in again.';

  @override
  String get verifyNewEmailTitle => 'Confirm new email';

  @override
  String get verifyNewEmailHint =>
      'No code yet? Go back and request the email change again.';

  @override
  String get emailChangedRelogin =>
      'Email changed, please sign in with the new email';

  @override
  String get passwordChangedRelogin => 'Password changed, please sign in again';

  @override
  String get loginTwoFactorTitle => 'Confirm sign-in';

  @override
  String get twoFactorTitle => 'Two-step verification';

  @override
  String get twoFactorHint =>
      'Each sign-in also needs a code sent to your email.';

  @override
  String get twoFactorEnabledDone => 'Two-step verification turned on';

  @override
  String get twoFactorDisabledDone => 'Two-step verification turned off';

  @override
  String get network3dTitle => '3D map';

  @override
  String get network3dOpen => 'Open map';

  @override
  String get network3dHint => 'Drag to rotate · pinch to zoom · tap a station';

  @override
  String get network3dReset => 'Reset view';

  @override
  String get network2dMode => '2D';

  @override
  String get network3dMode => '3D';

  @override
  String get allLines => 'All';

  @override
  String get homeNextTicket => 'Ticket ready';

  @override
  String get homeParkingPass => 'Parking';

  @override
  String get homeNoTicket => 'No ticket yet';

  @override
  String get homeNoParking => 'Not parked';

  @override
  String get vietnamMapLabel =>
      'Map of Vietnam, including the Hoang Sa and Truong Sa archipelagos';

  @override
  String get hoangSaLabel => 'Hoang Sa Is.';

  @override
  String get truongSaLabel => 'Truong Sa Is.';

  @override
  String get hcmcShort => 'HCMC';

  @override
  String get back => 'Back';

  @override
  String get continueAction => 'Continue';

  @override
  String get exploreMapHint => 'Nearby stations, places, live trains';

  @override
  String get exploreRouteHint => 'Find a route and its fare';

  @override
  String get parkingBookTitle => 'Book parking';

  @override
  String get parkingStepLot => 'Lot';

  @override
  String get parkingStepInfo => 'Details';

  @override
  String get parkingChooseLot => 'Choose a lot';

  @override
  String get parkingAfterPay =>
      'After paying you get a parking QR code. Show it to staff when entering and leaving.';

  @override
  String get parkingEntryTitle => 'Park at the station';

  @override
  String get parkingEntryAction => 'Book';

  @override
  String get newPasswordIntro =>
      'Set your new password first. Next, enter the 6-digit code sent to your email to confirm.';

  @override
  String get otpVerifyTitle => 'Verify OTP';

  @override
  String get mascotTipQr => 'Open your QR before the gate!';

  @override
  String get mascotTipParking => 'Book parking ahead!';

  @override
  String get mascotTipMap => 'Tap a station to see what is around it!';

  @override
  String get mascotLabel => 'Futu, tap for another tip';

  @override
  String get bookingHistory => 'Booking history';

  @override
  String get noActiveTickets => 'No active tickets';

  @override
  String get noTicketHistory => 'No past tickets yet';

  @override
  String get noParkingHistory => 'No finished parking yet';

  @override
  String get forecastTitle => 'Crowds today';

  @override
  String get forecastLevelLow => 'Quiet';

  @override
  String get forecastLevelMedium => 'Moderate';

  @override
  String get forecastLevelHigh => 'Busy';

  @override
  String get forecastRoadLow => 'clear';

  @override
  String get forecastRoadMedium => 'moderate traffic';

  @override
  String get forecastRoadHigh => 'prone to jams';

  @override
  String forecastRoadLine(String status) {
    return 'Roads nearby: $status';
  }

  @override
  String forecastNowPeak(String time) {
    return 'Busy now, usually until $time';
  }

  @override
  String forecastNextPeak(String from, String to) {
    return 'Usually busy $from–$to';
  }

  @override
  String get forecastNoPeak => 'No more busy hours today';

  @override
  String get forecastEstimate =>
      'Estimated from time of day and station location, not live measurements.';

  @override
  String forecastTipNow(String station, String time) {
    return '$station is busy now, usually easing by $time.';
  }

  @override
  String forecastTipBefore(String time, String station) {
    return 'Leave before $time to avoid the rush at $station.';
  }

  @override
  String get forecastMapChip => 'Crowds';

  @override
  String get studentTakePhoto => 'Take photo';

  @override
  String get studentChoosePhoto => 'Choose photo';

  @override
  String get studentRetake => 'Retake';

  @override
  String get studentConsent =>
      'I agree to send my card photo for AI to read. It is used only for verification and deleted once there is a result.';

  @override
  String get studentPickFailed =>
      'Couldn\'t open the camera or photo library. Check permissions and try again.';

  @override
  String get studentFieldName => 'Name';

  @override
  String get studentFieldSchool => 'School';

  @override
  String get studentFieldCode => 'Student ID';

  @override
  String get studentDemoLabel => 'Demo result:';

  @override
  String get studentDemoPass => 'Pass';

  @override
  String get studentVerifyTitle => 'Student verification';

  @override
  String get studentTip =>
      'Take a photo of the front of your student card, with your name, school and expiry date clearly visible.';

  @override
  String get studentCheck => 'Submit for review';

  @override
  String get studentVerified => 'Student status verified';

  @override
  String studentValidUntil(String date) {
    return 'Valid until $date';
  }

  @override
  String get studentBenefitSingle => '20% off single tickets';

  @override
  String get studentBenefitMonth => 'Access to the student monthly pass';

  @override
  String get studentRenewNote =>
      'Verify again once a year to keep your offers.';

  @override
  String studentRenewSoon(int days) {
    return '$days days left, verify again soon to keep your offers';
  }

  @override
  String get studentRenew => 'Verify again';

  @override
  String get studentWaitTitle => 'Review can take up to 24 hours';

  @override
  String get studentWaitBody =>
      'Verify before you need to travel. In a hurry? Buy a regular day ticket and ride now; student prices apply to tickets bought after approval.';

  @override
  String get studentBuyDay => 'Buy a day ticket';

  @override
  String get studentPendingTitle => 'We\'re reviewing your card';

  @override
  String get studentPendingBody =>
      'No need to wait here. HopOn will notify you with the result.';

  @override
  String studentSubmittedAt(String time) {
    return 'Submitted $time';
  }

  @override
  String studentStillActive(String date) {
    return 'Your current offers stay valid until $date';
  }

  @override
  String get studentDone => 'Done';

  @override
  String get studentCardNone =>
      '20% off single tickets and the student monthly pass';

  @override
  String get studentCardPending => 'In review, HopOn will notify you';

  @override
  String get studentCardRejected => 'Not approved, tap to see why and resubmit';

  @override
  String get studentCardExpired => 'Expired, verify again to keep your offers';

  @override
  String get studentNoticeNeeded =>
      'This ticket requires student verification, which can take up to 24 hours.';

  @override
  String get studentNoticePending =>
      'Your card is in review. If you need to ride now, buy a day ticket first.';

  @override
  String get studentConfirmAction => 'Verify now';

  @override
  String get studentUseDay => 'Choose day ticket';

  @override
  String get studentDemoExpiring => 'Expiring';

  @override
  String get studentDemoExpired => 'Expired';

  @override
  String get studentDemoFail => 'Reject';

  @override
  String get greenTitle => 'Green journey';

  @override
  String get cpointScaleTitle => 'CPoint rewards';

  @override
  String cpointAmount(String amount) {
    return '$amount CPoint';
  }

  @override
  String cpointDiscount(String amount, int percent) {
    return '$amount · $percent% off all tickets';
  }

  @override
  String cpointRule(int perKg) {
    return 'Each 1 kg of CO₂ avoided = $perKg CPoint. Discounts apply at checkout and CPoint is never spent.';
  }

  @override
  String get greenFutuStart => 'Take your first trip to make Earth greener!';

  @override
  String greenFutuNext(String kg, String tier) {
    return '$kg kg more to reach $tier!';
  }

  @override
  String get greenFutuTop => 'Top level! Earth says thank you.';

  @override
  String get greenFutuTipCount =>
      'Each completed single ticket adds CO₂ savings and CPoint.';

  @override
  String get greenFutuTipSpin => 'Drag Earth sideways to spin it!';

  @override
  String get greenEarthLabel => 'Earth model, drag sideways to spin';

  @override
  String get greenEmpty => 'No trips yet';

  @override
  String greenSavedKg(Object kg) {
    return '≈ $kg kg CO₂';
  }

  @override
  String greenSummaryLine(Object trips, Object km) {
    return '$trips trips · $km km';
  }

  @override
  String get greenTierSeed => 'Seed';

  @override
  String get greenTierSprout => 'Sprout';

  @override
  String get greenTierTree => 'Tree';

  @override
  String get greenTierForest => 'Forest';

  @override
  String get greenCalculatorTitle => 'Compare a trip';

  @override
  String get greenNoRoute => 'No route available between these stations.';

  @override
  String greenDistance(Object km) {
    return '≈ $km km';
  }

  @override
  String get greenModeCar => 'Car';

  @override
  String get greenModeMotorbike => 'Motorbike';

  @override
  String get greenModeMetro => 'Metro';

  @override
  String greenKg(Object kg) {
    return '$kg kg CO₂';
  }

  @override
  String get greenMethodTitle => 'How it works';

  @override
  String get greenFormula => 'Distance × (motorbike − metro)';

  @override
  String get greenFactors =>
      'Per person per km: car 0.101 kg · motorbike 0.062 kg · metro 0.034 kg';

  @override
  String get greenDisclaimer =>
      'Estimates. Only completed single tickets count.';

  @override
  String trainsLive(Object count) {
    return '$count trains running';
  }

  @override
  String trainsSimulated(Object count) {
    return '$count trains · simulated';
  }

  @override
  String nextTrainIn(Object eta) {
    return 'Next train in $eta';
  }

  @override
  String mascotExpiring(Object name, Object hours) {
    return 'Oh! $name expires in $hours hours, remember to use it.';
  }

  @override
  String mascotExpiringSoon(Object name) {
    return 'Oh! $name expires in under an hour, remember to use it.';
  }

  @override
  String mascotTierUp(Object tier) {
    return 'Awesome! You just reached $tier. So proud of you!';
  }

  @override
  String get greenShare => 'Share achievement';

  @override
  String get greenShareTitle => 'Green achievement card';

  @override
  String get greenShareMonth => 'This month I avoided';

  @override
  String get greenShareTotal => 'I have avoided';

  @override
  String get greenShareBy => 'by riding the Metro instead of a motorbike';

  @override
  String greenShareStats(Object trips, Object km, Object days) {
    return '$trips trips · $km km · $days days of CO₂ absorbed by one tree';
  }

  @override
  String get greenShareEstimate => 'Estimate from the HopOn app';

  @override
  String greenShareText(Object kg) {
    return 'I avoided $kg kg of CO₂ by riding the Metro with HopOn. Join me!';
  }

  @override
  String get greenShareFailed => 'Could not share, please try again';

  @override
  String get mascotPaidTicket => 'Done! Open the QR and hop on.';

  @override
  String get mascotPaidParking => 'Done! Futu saved your parking spot.';

  @override
  String get mascotPaidFailed =>
      'Oh no, payment did not go through. You were not charged, try again.';

  @override
  String get mascotPaidRefund => 'Your refund is being processed, hang on.';

  @override
  String get mascotParkingLot => 'Pick a vehicle and a lot.';

  @override
  String get mascotParkingInfo => 'Enter your plate and a package.';

  @override
  String get mascotParkingConfirm => 'One last look, then pay!';

  @override
  String get mascotBookingChoose => 'Pick a ticket and two stations!';

  @override
  String get mascotBookingConfirm => 'Check your ticket and offers.';

  @override
  String get mascotRegister => 'Fill this in and Futu will email a code.';

  @override
  String greenBookedTrip(Object kg) {
    return 'This trip ≈ $kg kg CO₂, counted once finished';
  }

  @override
  String greenBookedPass(Object kg) {
    return 'Every 10 km ≈ $kg kg CO₂';
  }

  @override
  String greenBookedParking(Object kg) {
    return 'Park and ride: every 10 km ≈ $kg kg CO₂';
  }

  @override
  String greenNextTier(Object tier, Object kg) {
    return '$tier · $kg kg to next level';
  }

  @override
  String futuMorning(Object name) {
    return 'Morning $name! Where to?';
  }

  @override
  String futuAfternoon(Object name) {
    return 'Hi $name! Where to?';
  }

  @override
  String futuEvening(Object name) {
    return 'Evening $name, heading home?';
  }

  @override
  String futuLoginTitle(Object name) {
    return '$name is back!';
  }

  @override
  String get futuLoginBody => 'Futu is so happy, let\'s ride!';

  @override
  String get futuLogoutTitle => 'Leaving already?';

  @override
  String get futuLogoutBody => 'Futu will miss you...';

  @override
  String get greenCompared => 'avoided compared with a motorbike';

  @override
  String greenTierProgress(Object kg, Object target) {
    return '$kg / $target kg';
  }

  @override
  String get greenStatTrips => 'trips';

  @override
  String get greenStatKm => 'km';

  @override
  String get greenStatTreeDays => 'tree days';

  @override
  String greenTripSaved(Object kg) {
    return 'Metro avoids $kg kg compared with a motorbike';
  }

  @override
  String greenTrain(Object bikes) {
    return '1 train ≈ $bikes motorbikes off the road';
  }
}
