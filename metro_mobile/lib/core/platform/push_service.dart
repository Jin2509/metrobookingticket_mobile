/// Nguồn device token cho push (UC13-01).
///
/// Bản hiện tại chưa có cấu hình Firebase (`google-services.json`,
/// `GoogleService-Info.plist`) nên dùng [NoopPushService]. Khi có, thêm
/// `FirebasePushService` dùng `firebase_messaging` sau interface này.
abstract interface class PushService {
  Future<String?> deviceToken();
}

class NoopPushService implements PushService {
  const NoopPushService();

  @override
  Future<String?> deviceToken() async => null;
}
