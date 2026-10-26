import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/auth/domain/entities/otp_purpose.dart';
import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:metro_mobile/features/auth/domain/usecases/forgot_password.dart';
import 'package:metro_mobile/features/auth/domain/usecases/login.dart';
import 'package:metro_mobile/features/auth/domain/usecases/register.dart';
import 'package:metro_mobile/features/auth/domain/usecases/reset_password.dart';
import 'package:metro_mobile/features/auth/domain/usecases/verify_otp.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements AuthRepository;

Matcher _failsWith(String message) => throwsA(
  isA<ValidationFailure>().having((f) => f.message, 'message', message),
);

void main() {
  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  test('Login kiểm tra email/SĐT và mật khẩu trước khi gọi API', () {
    final login = Login(repo);
    expect(
      () => login(identifier: 'abc', password: 'x'),
      _failsWith('Email hoặc số điện thoại không hợp lệ'),
    );
    expect(
      () => login(identifier: '0901234567', password: ''),
      _failsWith('Vui lòng nhập mật khẩu'),
    );
    verifyZeroInteractions(repo);
  });

  test('Register: mật khẩu yếu, nhập lại sai, chưa đồng ý điều khoản', () {
    final register = Register(repo);
    Future<void> run({
      String pw = 'Metro2026',
      String c = 'Metro2026',
      bool terms = true,
    }) => register(
      name: 'An',
      email: 'an@metro.vn',
      password: pw,
      confirm: c,
      acceptedTerms: terms,
    );
    expect(
      () => run(pw: 'abc', c: 'abc'),
      _failsWith('Mật khẩu tối thiểu 8 ký tự'),
    );
    expect(
      () => run(c: 'Metro2027'),
      _failsWith('Mật khẩu nhập lại không khớp'),
    );
    expect(
      () => run(terms: false),
      _failsWith('Vui lòng đồng ý điều khoản sử dụng'),
    );
  });

  test('VerifyOtp chỉ nhận đúng 6 chữ số', () {
    expect(
      () => VerifyOtp(repo)(
        purpose: OtpPurpose.register,
        email: 'a@b.vn',
        code: '12a456',
      ),
      _failsWith('Mã OTP gồm 6 chữ số'),
    );
  });

  test('ForgotPassword và ResetPassword kiểm tra đầu vào', () {
    expect(() => ForgotPassword(repo)('sai'), _failsWith('Email không hợp lệ'));
    expect(
      () => ResetPassword(repo)(
        resetToken: 't',
        password: 'Metro2026',
        confirm: 'x',
      ),
      _failsWith('Mật khẩu nhập lại không khớp'),
    );
  });
}
