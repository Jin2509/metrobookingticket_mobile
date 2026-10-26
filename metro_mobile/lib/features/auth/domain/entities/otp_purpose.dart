/// Mục đích OTP, khớp query `?purpose=` (mục 6.1).
enum OtpPurpose {
  register('REGISTER'),
  login2fa('LOGIN_2FA'),
  reset('RESET');

  OtpPurpose(this.value);
  final String value;

  static OtpPurpose parse(String? value) => OtpPurpose.values.firstWhere(
    (p) => p.value == value,
    orElse: () => OtpPurpose.login2fa,
  );
}
