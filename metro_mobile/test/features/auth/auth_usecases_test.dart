import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/auth/domain/entities/role.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';
import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:metro_mobile/features/auth/domain/usecases/change_password.dart';
import 'package:metro_mobile/features/auth/domain/usecases/forgot_password.dart';
import 'package:metro_mobile/features/auth/domain/usecases/login.dart';
import 'package:metro_mobile/features/auth/domain/usecases/register.dart';
import 'package:metro_mobile/features/auth/domain/usecases/reset_password.dart';
import 'package:metro_mobile/features/auth/domain/usecases/update_profile.dart';
import 'package:metro_mobile/features/auth/domain/usecases/verify_email.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements AuthRepository;

Matcher _failsWith(String message) => throwsA(
  isA<ValidationFailure>().having((f) => f.message, 'message', message),
);

void main() {
  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  test('Login chỉ nhận email và cần mật khẩu trước khi gọi API', () {
    final login = Login(repo);
    expect(
      () => login(email: '0901234567', password: 'x'),
      _failsWith('Email không hợp lệ'),
    );
    expect(
      () => login(email: 'an@metro.vn', password: ''),
      _failsWith('Vui lòng nhập mật khẩu'),
    );
    verifyZeroInteractions(repo);
  });

  test('Register: mật khẩu sai quy tắc backend, nhập lại sai, chưa đồng ý', () {
    final register = Register(repo);
    Future<void> run({
      String name = 'An',
      String pw = 'matkhauchu',
      String? c,
      bool terms = true,
    }) => register(
      name: name,
      email: 'an@metro.vn',
      password: pw,
      confirm: c ?? pw,
      acceptedTerms: terms,
    );
    expect(() => run(pw: 'abc'), _failsWith('Mật khẩu tối thiểu 8 ký tự'));
    expect(
      () => run(pw: ' ' * 8),
      _failsWith('Mật khẩu không được toàn khoảng trắng'),
    );
    // 30 ký tự 'ệ' = 90 byte UTF-8.
    expect(() => run(pw: 'ệ' * 30), _failsWith('Mật khẩu quá dài'));
    expect(() => run(c: 'khac'), _failsWith('Mật khẩu nhập lại không khớp'));
    expect(
      () => run(terms: false),
      _failsWith('Vui lòng đồng ý điều khoản sử dụng'),
    );
    expect(() => run(name: 'A' * 121), _failsWith('Họ tên tối đa 120 ký tự'));
  });

  test('VerifyEmail chỉ nhận đúng 6 chữ số', () {
    expect(
      () => VerifyEmail(repo)(email: 'a@b.vn', code: '12a456'),
      _failsWith('Mã OTP gồm 6 chữ số'),
    );
  });

  test('ForgotPassword và ResetPassword kiểm tra đầu vào', () {
    expect(() => ForgotPassword(repo)('sai'), _failsWith('Email không hợp lệ'));
    expect(
      () => ResetPassword(repo)(
        email: 'a@b.vn',
        code: '123',
        password: 'Metro2026',
        confirm: 'Metro2026',
      ),
      _failsWith('Mã OTP gồm 6 chữ số'),
    );
    expect(
      () => ResetPassword(repo)(
        email: 'a@b.vn',
        code: '012345',
        password: 'Metro2026',
        confirm: 'x',
      ),
      _failsWith('Mật khẩu nhập lại không khớp'),
    );
  });

  group('UpdateProfile', () {
    const user = SessionUser(
      id: '1',
      name: 'An',
      email: 'an@metro.vn',
      role: Role.passenger,
    );

    test('đổi email thì bắt buộc mật khẩu hiện tại', () {
      expect(
        () => UpdateProfile(repo)(
          user: user,
          name: 'An',
          email: 'moi@metro.vn',
          currentPassword: '',
        ),
        _failsWith('Vui lòng nhập mật khẩu'),
      );
    });

    test(
      'chỉ đổi họ tên (email khác hoa thường) thì không gửi email',
      () async {
        when(() => repo.updateProfile(name: any(named: 'name')))
            .thenAnswer((_) async => user);
        await UpdateProfile(repo)(
          user: user,
          name: ' Tên Mới ',
          email: 'AN@metro.vn',
          currentPassword: '',
        );
        verify(() => repo.updateProfile(name: 'Tên Mới')).called(1);
      },
    );
  });

  test('ChangePassword cần mật khẩu hiện tại và mật khẩu mới hợp lệ', () {
    expect(
      () => ChangePassword(repo)(
        currentPassword: '',
        newPassword: 'Metro2026',
        confirm: 'Metro2026',
      ),
      _failsWith('Vui lòng nhập mật khẩu'),
    );
    expect(
      () => ChangePassword(repo)(
        currentPassword: 'x',
        newPassword: 'abc',
        confirm: 'abc',
      ),
      _failsWith('Mật khẩu tối thiểu 8 ký tự'),
    );
  });

  test('Role suy từ permissions, không dựa vào tên vai trò', () {
    expect(
      Role.fromPermissions({'TICKET_BUY', 'TICKET_VIEW_OWN'}),
      Role.passenger,
    );
    expect(
      Role.fromPermissions({'TICKET_VALIDATE', 'TICKET_VIEW_OWN'}),
      Role.staffStation,
    );
    expect(
      Role.fromPermissions({'TICKET_BUY', 'TICKET_VALIDATE', 'USER_MANAGE'}),
      Role.other,
    );
    expect(Role.fromPermissions({'USER_VIEW'}), Role.other);
    expect(Role.fromPermissions({}), Role.other);
  });
}
