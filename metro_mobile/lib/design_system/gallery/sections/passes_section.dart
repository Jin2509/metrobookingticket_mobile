import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/gallery/gallery_sample_data.dart';
import 'package:metro_mobile/design_system/gallery/sections/gallery_section.dart';
import 'package:metro_mobile/design_system/models/vehicle_kind.dart';
import 'package:metro_mobile/design_system/molecules/parking_pass_card.dart';
import 'package:metro_mobile/design_system/molecules/ticket_card.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

class PassesSection extends StatelessWidget {
  const PassesSection({super.key});

  @override
  Widget build(BuildContext context) {
    void noop() {}
    return GallerySection(
      title: 'TicketCard · ParkingPassCard',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TicketCard(
            title: 'Vé lượt',
            from: 'Bến Thành',
            to: 'Thủ Đức',
            status: 'PAID',
            validUntil: GallerySample.validUntil,
            onOpenQr: noop,
          ),
          MetroSpacing.gapSm,
          TicketCard(
            title: 'Vé tháng HSSV',
            status: 'EXPIRED',
            validUntil: GallerySample.validUntil,
            onOpenQr: noop,
          ),
          MetroSpacing.gapSm,
          ParkingPassCard(
            lotName: 'Bãi PK1 · Suối Tiên',
            plate: '59X1-234.56',
            vehicle: VehicleKind.motorbike,
            status: 'DANG_GUI',
            since: GallerySample.parkedSince,
            onOpenQr: noop,
          ),
        ],
      ),
    );
  }
}
