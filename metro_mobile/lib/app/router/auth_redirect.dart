import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/app/router/route_access.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/features/auth/domain/entities/role.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';

/// Redirect của go_router (hàm thuần để test):
/// - đang khôi phục phiên → Splash (giữ `from` cho deep link);
/// - chưa đăng nhập → `/auth/login?from=<path>`;
/// - sai vai trò → shell đúng vai trò; vai trò khác → `/unsupported`.
String? resolveRedirect(AsyncValue<SessionUser?> auth, Uri uri) {
  final path = uri.path;
  if (path.startsWith('/dev')) return null;

  final isSplash = path == Routes.splash;
  final isAuth = path.startsWith('/auth/');
  final from = uri.queryParameters['from'];
  final pending = isProtected(path) ? uri.toString() : from;

  if (auth.isLoading && !auth.hasValue) {
    return isSplash ? null : _withFrom(Routes.splash, pending);
  }

  final user = auth.value;
  if (user == null) {
    return isAuth ? null : _withFrom(Routes.login, pending);
  }

  if (user.role == Role.other) {
    return path == Routes.unsupported ? null : Routes.unsupported;
  }
  if (isAuth || isSplash || path == Routes.unsupported) {
    final target = from != null && isProtected(Uri.parse(from).path)
        ? from
        : null;
    return target != null && canAccess(user.role, Uri.parse(target).path)
        ? target
        : homeFor(user.role);
  }
  return canAccess(user.role, path) ? null : homeFor(user.role);
}

String _withFrom(String path, String? from) => from == null
    ? path
    : Uri(path: path, queryParameters: {'from': from}).toString();
