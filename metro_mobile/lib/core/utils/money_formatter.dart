import 'package:intl/intl.dart';

final _vnd = NumberFormat.decimalPattern('vi_VN');

/// `12000` → `12.000 ₫`, giống hàm `money()` của web (mục 3.6).
String money(num amount) => '${_vnd.format(amount)} ₫';

/// `12345` → `12.345` (số lượt, số điểm).
String count(num value) => _vnd.format(value);
