import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_brand_header.dart';

/// Khung màn Auth: nền navy, card trắng bo 20 trồi lên (wireframe A1).
/// Có [title] thì hiện AppBar có nút quay lại thay cho phần thương hiệu.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({required this.child, this.title, super.key});

  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return Scaffold(
      backgroundColor: m.sidebar,
      appBar: title == null
          ? null
          : AppBar(
              backgroundColor: m.sidebar,
              foregroundColor: MetroColors.primaryForeground,
              titleTextStyle: MetroTypography.titleSmall.copyWith(
                color: MetroColors.primaryForeground,
              ),
              title: Text(title!),
            ),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            if (title == null)
              const SliverToBoxAdapter(child: AuthBrandHeader())
            else
              const SliverToBoxAdapter(child: MetroSpacing.gapXs),
            // Card co theo nội dung; khối cùng màu bên dưới lấp tới đáy.
            // Không dùng intrinsic height (ListTile không hỗ trợ chính xác).
            SliverToBoxAdapter(
              child: Material(
                color: m.card,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(MetroRadius.xxl),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    MetroSpacing.lg,
                    MetroSpacing.lg,
                    MetroSpacing.lg,
                    MetroSpacing.xl,
                  ),
                  child: child,
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: ColoredBox(color: m.card),
            ),
          ],
        ),
      ),
    );
  }
}
