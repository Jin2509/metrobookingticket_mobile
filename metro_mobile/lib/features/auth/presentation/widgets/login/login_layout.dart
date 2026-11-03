import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/brand_mark.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Màn đăng nhập trên nền navy: bản đồ Việt Nam chìm phía sau, thương hiệu ở
/// trên và form neo ở đáy. Ô nhập trong mờ nên bản đồ vẫn nhìn thấy qua form.
class LoginLayout extends StatelessWidget {
  const LoginLayout({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final l = context.l10n;
    final inset = MediaQuery.paddingOf(context);
    final theme = MetroTheme.staff;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Theme(
        data: theme.copyWith(
          inputDecorationTheme: theme.inputDecorationTheme.copyWith(
            fillColor: MetroColors.primaryForeground.withValues(alpha: .09),
          ),
        ),
        child: Scaffold(
          backgroundColor: m.sidebar,
          body: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [m.sidebar, const Color(0xFF0A3A47)],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: inset.top + MetroSpacing.sm,
                left: 0,
                right: 0,
                child: VietnamMap(
                  color: m.sidebarForeground,
                  highlight: m.sidebarPrimary,
                  semanticLabel: l.vietnamMapLabel,
                  hoangSaLabel: l.hoangSaLabel,
                  truongSaLabel: l.truongSaLabel,
                  markerLabel: l.hcmcShort,
                ),
              ),
              LayoutBuilder(
                builder: (context, c) => SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    MetroSpacing.lg,
                    inset.top + MetroSpacing.lg,
                    MetroSpacing.lg,
                    inset.bottom + MetroSpacing.md,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          c.maxHeight -
                          inset.vertical -
                          MetroSpacing.lg -
                          MetroSpacing.md,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: MetroSpacing.xl),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: BrandMark(),
                          ),
                        ),
                        child,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
