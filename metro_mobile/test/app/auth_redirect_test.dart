import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/app/router/auth_redirect.dart';
import 'package:metro_mobile/features/auth/domain/entities/role.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';

AsyncValue<SessionUser?> _as(Role role) =>
    AsyncData(SessionUser(id: '1', name: 'A', email: 'a@metro.vn', role: role));

String? _go(AsyncValue<SessionUser?> auth, String path) =>
    resolveRedirect(auth, Uri.parse(path));

void main() {
  const loading = AsyncLoading<SessionUser?>();
  const guest = AsyncData<SessionUser?>(null);

  test('đang khôi phục phiên: giữ ở Splash, nhớ deep link', () {
    expect(_go(loading, '/splash'), isNull);
    expect(_go(loading, '/p/tickets/T1'), '/splash?from=%2Fp%2Ftickets%2FT1');
  });

  test('chưa đăng nhập: về login kèm from', () {
    expect(_go(guest, '/splash'), '/auth/login');
    expect(_go(guest, '/p/home'), '/auth/login?from=%2Fp%2Fhome');
    expect(
      _go(guest, '/splash?from=/p/tickets/T1'),
      '/auth/login?from=%2Fp%2Ftickets%2FT1',
    );
    expect(_go(guest, '/auth/register'), isNull);
  });

  test('Passenger: vào /p, bị chặn khỏi /s', () {
    final p = _as(Role.passenger);
    expect(_go(p, '/auth/login'), '/p/home');
    expect(_go(p, '/auth/login?from=/p/tickets/T1'), '/p/tickets/T1');
    expect(_go(p, '/s/scan'), '/p/home');
    expect(_go(p, '/p/explore'), isNull);
  });

  test('Staff: vào /s/scan, bị chặn khỏi /p, from sai vai trò bị bỏ', () {
    final s = _as(Role.staffStation);
    expect(_go(s, '/splash'), '/s/scan');
    expect(_go(s, '/p/home'), '/s/scan');
    expect(_go(s, '/auth/login?from=/p/tickets/T1'), '/s/scan');
    expect(_go(s, '/s/history'), isNull);
  });

  test('Admin/Manager/Accountant: màn dùng web quản trị', () {
    final o = _as(Role.other);
    expect(_go(o, '/auth/login'), '/unsupported');
    expect(_go(o, '/p/home'), '/unsupported');
    expect(_go(o, '/unsupported'), isNull);
  });
}
