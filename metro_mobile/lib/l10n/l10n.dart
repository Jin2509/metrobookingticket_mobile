import 'package:flutter/widgets.dart';
import 'package:metro_mobile/l10n/gen/app_localizations.dart';

export 'package:metro_mobile/l10n/gen/app_localizations.dart';
export 'package:metro_mobile/l10n/message_localizer.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
