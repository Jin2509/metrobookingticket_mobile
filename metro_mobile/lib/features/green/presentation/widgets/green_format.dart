import 'package:metro_mobile/features/green/domain/green_impact.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Số ước tính nên không lấy nhiều chữ số lẻ: dưới 1 lấy 2, còn lại lấy 1.
String greenNumber(double v) =>
    v.toStringAsFixed(v.abs() < 1 ? 2 : 1).replaceAll('.', ',');

String greenTierLabel(AppLocalizations l, GreenTier t) => switch (t) {
  GreenTier.seed => l.greenTierSeed,
  GreenTier.sprout => l.greenTierSprout,
  GreenTier.tree => l.greenTierTree,
  GreenTier.forest => l.greenTierForest,
};
