import 'package:metro_mobile/core/utils/geo.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/domain/entities/route_plan.dart';

/// Hệ số ước tính phát thải theo kg CO2 cho mỗi km của một người.
///
/// Chọn thận trọng để không phóng đại lợi ích. Metro và xe máy là giả định của
/// app, cần thay bằng số vận hành thật khi có.
abstract final class GreenFactors {
  /// Lưới điện Việt Nam năm 2024, kg CO2/kWh (nghiên cứu của ĐH Bách khoa Hà Nội).
  static const gridKgPerKwh = .681;

  /// Giả định điện năng cho mỗi km của một hành khách.
  static const metroKwhPerKm = .05;
  static const metroKgPerKm = gridKgPerKwh * metroKwhPerKm;

  /// Giả định xe máy tiêu thụ 2,7 lít/100 km; xăng phát thải 2,31 kg CO2/lít.
  static const motorbikeKgPerKm = 2.7 / 100 * 2.31;

  /// Ô tô xăng 0,162 kg CO2/km (DEFRA), chia cho 1,6 người trên xe.
  static const carKgPerKm = .162 / 1.6;

  /// Một cây xanh hấp thụ khoảng 21 kg CO2 mỗi năm.
  static const treeKgPerDay = 21 / 365;

  /// Giả định mặt đường một xe chiếm khi lưu thông, m².
  static const motorbikeRoadM2 = 4.0;
  static const carRoadM2 = 18.0;

  /// Sức chở một đoàn tàu Tuyến 1 và số người trung bình trên một xe máy.
  static const trainCapacity = 930;
  static const peoplePerMotorbike = 1.1;
}

enum TravelMode {
  motorbike(GreenFactors.motorbikeKgPerKm, GreenFactors.motorbikeRoadM2),
  car(GreenFactors.carKgPerKm, GreenFactors.carRoadM2);

  const TravelMode(this.kgPerKm, this.roadM2);

  final double kgPerKm;
  final double roadM2;

  /// Lượng CO2 bớt được khi đi metro thay vì phương tiện này.
  double savedKg(double km) => km * (kgPerKm - GreenFactors.metroKgPerKm);
}

/// Một đoàn tàu đầy khách tương đương bao nhiêu xe máy trên đường.
int get motorbikesPerTrain =>
    (GreenFactors.trainCapacity / GreenFactors.peoplePerMotorbike).round();

/// Số ngày một cây xanh cần để hấp thụ lượng CO2 này.
double treeDays(double kg) => kg / GreenFactors.treeKgPerDay;

/// Chiều dài lộ trình theo đường thẳng nối các ga liên tiếp, km.
double routeKm(RoutePlan plan, NetworkCatalog catalog) {
  var meters = 0.0;
  for (final leg in plan.legs) {
    for (var i = 0; i + 1 < leg.stationIds.length; i++) {
      final a = catalog.station(leg.stationIds[i]);
      final b = catalog.station(leg.stationIds[i + 1]);
      if (a != null && b != null) {
        meters += distanceMeters(a.lat, a.lng, b.lat, b.lng);
      }
    }
  }
  return meters / 1000;
}

/// Tổng kết các chuyến đã đi. So với xe máy vì đây là phương tiện phổ biến nhất
/// và cho kết quả thận trọng hơn so với ô tô.
class GreenSummary {
  const GreenSummary({
    required this.trips,
    required this.km,
    this.monthTrips = 0,
    this.monthKm = 0,
  });

  final int trips;
  final double km;

  /// Riêng tháng hiện tại, dùng cho thẻ chia sẻ.
  final int monthTrips;
  final double monthKm;

  double get monthSavedKg => TravelMode.motorbike.savedKg(monthKm);

  double get savedKg => TravelMode.motorbike.savedKg(km);
  double get roadM2 => trips * TravelMode.motorbike.roadM2;
  GreenTier get tier => GreenTier.of(savedKg);
  int get cpoint => (savedKg * cpointPerKg).floor();
}

/// CPoint (Carbon Point): thang ưu đãi quy từ CO2 đã bớt, không bị trừ khi dùng.
const cpointPerKg = 100;

/// Bốn cấp độ theo lượng CO2 đã bớt.
enum GreenTier {
  seed(0, 1, 0),
  sprout(1, 5, 3),
  tree(5, 20, 5),
  forest(20, null, 8);

  const GreenTier(this.fromKg, this.toKg, this.discountPercent);

  final double fromKg;
  final double? toKg;

  /// Mức giảm trên mọi loại vé. Backend phải là nơi áp giá thật.
  final int discountPercent;

  /// Mốc CPoint để vào cấp này.
  int get fromCpoint => (fromKg * cpointPerKg).round();

  static GreenTier of(double kg) =>
      values.lastWhere((t) => kg >= t.fromKg, orElse: () => seed);

  /// Cấp kế tiếp, `null` khi đã ở cấp cao nhất.
  GreenTier? get next => index + 1 < values.length ? values[index + 1] : null;

  /// Tiến độ trong cấp hiện tại, từ 0 đến 1.
  double progress(double kg) {
    final to = toKg;
    return to == null ? 1 : ((kg - fromKg) / (to - fromKg)).clamp(0, 1);
  }
}

/// Độ xanh của mô hình Trái Đất, từ 0 tới 1: mỗi cấp chiếm một phần bằng nhau.
/// Giao diện chỉ đọc số này, nên muốn đổi cách tiến hóa (kể cả dùng mô hình ML)
/// chỉ cần thay hàm này.
double greenHealth(double kg) {
  final tier = GreenTier.of(kg);
  return (tier.index + tier.progress(kg)) / GreenTier.values.length;
}
