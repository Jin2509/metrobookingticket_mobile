import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/wallet/presentation/controllers/wallet_controllers.dart';
import 'package:metro_mobile/features/wallet/presentation/widgets/pass_qr/parking_qr_info.dart';
import 'package:metro_mobile/features/wallet/presentation/widgets/pass_qr/pass_qr_layout.dart';
import 'package:metro_mobile/features/wallet/wallet_providers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P42. QR gửi xe toàn màn hình.
class ParkingQrScreen extends ConsumerWidget {
  const ParkingQrScreen({required this.bookingId, super.key});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pass = ref.watch(parkingPassProvider(bookingId));
    return AsyncValueView(
      value: pass,
      onRetry: () => ref.invalidate(parkingPassProvider(bookingId)),
      loading: const Scaffold(
        body: Center(child: MetroSkeleton(width: 260, height: 260)),
      ),
      data: (p) => PassQrLayout(
        code: p.id,
        qr: QrPassView(
          data: ref.watch(buildPassQrProvider).parking(p),
          active: p.isUsable,
          inactiveLabel: context.l10n.parkingEnded,
        ),
        info: ParkingQrInfo(pass: p),
      ),
    );
  }
}
