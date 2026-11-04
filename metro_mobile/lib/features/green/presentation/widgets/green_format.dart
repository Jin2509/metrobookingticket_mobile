import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/green/domain/green_impact.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Màu nhấn của chữ và tiến độ trên nền cảnh Trái Đất.
const greenMint = Color(0xFF7CF0B5);

/// Nền cảnh Trái Đất: từ màu thương hiệu sang xanh lá đậm.
LinearGradient greenSceneGradient(
  BuildContext context, {
  required Alignment begin,
}) => LinearGradient(
  begin: begin,
  end: -begin,
  colors: [context.metro.sidebar, const Color(0xFF0A5A4A)],
);

/// Số ước tính nên không lấy nhiều chữ số lẻ: dưới 1 lấy 2, còn lại lấy 1.
String greenNumber(double v) =>
    v.toStringAsFixed(v.abs() < 1 ? 2 : 1).replaceAll('.', ',');

String greenTierLabel(AppLocalizations l, GreenTier t) => switch (t) {
  GreenTier.seed => l.greenTierSeed,
  GreenTier.sprout => l.greenTierSprout,
  GreenTier.tree => l.greenTierTree,
  GreenTier.forest => l.greenTierForest,
};

IconData greenTierIcon(GreenTier t) => switch (t) {
  GreenTier.seed => LucideIcons.sprout,
  GreenTier.sprout => LucideIcons.leaf,
  GreenTier.tree => LucideIcons.treePine,
  GreenTier.forest => LucideIcons.trees,
};

/// `635 CPoint · Giảm 5% mọi vé`.
String greenCpointLine(AppLocalizations l, GreenSummary s) {
  final amount = l.cpointAmount(count(s.cpoint));
  final percent = s.tier.discountPercent;
  return percent == 0 ? amount : l.cpointDiscount(amount, percent);
}

/// Câu Futu nói theo tiến độ hiện tại.
String greenFutuLine(AppLocalizations l, GreenSummary s) {
  if (s.trips == 0) return l.greenFutuStart;
  final to = s.tier.toKg;
  final next = s.tier.next;
  if (to == null || next == null) return l.greenFutuTop;
  return l.greenFutuNext(greenNumber(to - s.savedKg), greenTierLabel(l, next));
}
