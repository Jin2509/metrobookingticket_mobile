import 'package:intl/intl.dart';

/// Việt Nam không có giờ mùa hè nên Asia/Ho_Chi_Minh luôn là UTC+7.
const _vnOffset = Duration(hours: 7);

final _dateTime = DateFormat('dd/MM/yyyy HH:mm');
final _date = DateFormat('dd/MM/yyyy');
final _time = DateFormat('HH:mm');

DateTime toVnTime(DateTime t) => t.toUtc().add(_vnOffset);

/// `dd/MM/yyyy HH:mm` theo giờ Việt Nam (mục 3.6).
String dateTime(DateTime t) => _dateTime.format(toVnTime(t));

String dateOnly(DateTime t) => _date.format(toVnTime(t));

String timeOnly(DateTime t) => _time.format(toVnTime(t));
