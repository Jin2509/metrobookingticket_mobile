import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/features/auth/domain/entities/role.dart';

/// NGUỒN DUY NHẤT cho guard (giống `permissions.ts` trên web, mục 6.2).
const routeAccess = <String, Set<Role>>{
  '/p': {Role.passenger},
  '/s': {Role.staffStation},
};

String? _prefixOf(String path) {
  for (final prefix in routeAccess.keys) {
    if (path == prefix || path.startsWith('$prefix/')) return prefix;
  }
  return null;
}

/// Path thuộc một shell (cần đăng nhập đúng vai trò).
bool isProtected(String path) => _prefixOf(path) != null;

bool canAccess(Role role, String path) {
  final prefix = _prefixOf(path);
  return prefix == null || routeAccess[prefix]!.contains(role);
}

/// Màn đầu tiên sau đăng nhập theo vai trò.
String homeFor(Role role) => switch (role) {
  Role.passenger => Routes.pHome,
  Role.staffStation => Routes.sScan,
  Role.other => Routes.unsupported,
};
