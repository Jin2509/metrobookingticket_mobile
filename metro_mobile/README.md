# metro_mobile

**HopOn** là app Flutter cho **Hành khách** và **Nhân viên soát vé** Metro TP.HCM. Slogan: *Kỷ nguyên mới, chuyển động mới*.
Một codebase, một bản build, shell suy từ `permissions` của `GET /api/me`.
Thiết kế chi tiết: [`../design-prototype.md`](../design-prototype.md).

## Chạy

```bash
make run                 # flavor local: backend chạy trên máy
make run-device          # máy Android thật cắm USB, auth thật ở backend local
make run FLAVOR=staging  # hoặc prod
make test                # unit + widget test
make golden              # cập nhật ảnh golden
make analyze             # very_good_analysis
make check-size          # cảnh báo file widget > 150 dòng, screen > 100 dòng
```

Flavor chỉ đổi môi trường qua `config/<flavor>.json` (`--dart-define-from-file`),
không tách vai trò.

App luôn gọi API thật, không còn dữ liệu giả trong `lib/` (Fake source chỉ còn
ở `test/fakes/` cho test). `BASE_URL` trong `config/local.json` mặc định là `http://10.0.2.2:8080` cho máy ảo Android; simulator iOS dùng
`http://localhost:8080`. Máy Android thật dùng `make run-device`: `config/device.json`
đặt `http://localhost:8080` và `adb reverse` chuyển cổng này qua cáp USB về máy chạy
backend, nên không phụ thuộc Wi-Fi. Rút cáp hoặc khởi động lại adb thì phải chạy lại.

Luôn chạy kèm `--dart-define-from-file` (VS Code đã có sẵn cấu hình trong
`.vscode/launch.json`); thiếu `BASE_URL` thì mọi lời gọi API đều lỗi.

## Khác biệt so với tài liệu thiết kế

| Tài liệu | Thực tế | Lý do |
|---|---|---|
| `seqr` | `qr_flutter` (vẽ) + `mobile_scanner` (quét), bọc trong `core/qr/` | Gói `seqr` không có trên pub.dev. Feature chỉ dùng `QrCodec`, `QrImage`, `CameraScanner` |
| `core/qr/seqr_codec.dart` | `core/qr/metro_qr_codec.dart` | Như trên |
| `lucide_icons` | `lucide_icons_flutter` | Gói cũ thiếu icon như `trainFront`. Bản mới đồng bộ với Lucide trên web |
| `google_fonts` | Font Be Vietnam Pro bundle trong `assets/fonts/` | Chạy offline khi demo, golden ổn định |
| `golden_toolkit` | `matchesGoldenFile` của `flutter_test` | `golden_toolkit` đã ngừng phát triển |
| Payload `/topic/trains/{lineId}` | Thêm `headsignStationId` (ga cuối theo hướng chạy) | Cần để ước tính giờ tàu đến từng ga. Cần thống nhất với backend |
| — | `GET /api/bus-stops` cho lớp Buýt trên bản đồ | Bảng API mục 9 chưa có endpoint này |
| Ngưỡng 150 dòng cho mọi file | Chỉ áp dụng cho `presentation/`, `design_system/`, `app/` | Đúng phạm vi CI ở mục 4.3; file dữ liệu demo được phép dài |
| `FLAG_SECURE` | Kênh native `metro/screen_guard` trong `MainActivity.kt`; iOS không có cờ tương đương | Không thêm plugin chỉ cho một cờ |
| Q2 cổng thanh toán chưa chốt | Chuyển khoản **VietQR qua SePay**: `core/payment/vietqr.dart` dựng chuỗi EMVCo/NAPAS 247 (CRC16), vẽ bằng `core/qr` | Backend trả `bank {bin, name, accountNumber, accountName}`, `transferContent`, có thể kèm `qrContent`; SePay gọi webhook backend khi nhận tiền khớp nội dung → đơn `SUCCESS` qua WS/poll |
| Trợ lý là tab thứ 4 | Nút nổi trên màn gốc của 4 tab, mở `ChatSheet` (~86% màn hình); `/p/assistant` giữ làm trang cho deep link | Chat không chiếm một tab, mở được từ mọi tab |
| — | Sơ đồ mạng lưới `NetworkDiagram` (tự bố cục theo ga chung nhiều tuyến nhất, hướng nhánh theo tọa độ) ở tab Khám phá | Không cần backend cấp tọa độ sơ đồ |
| — | Bản đồ nền màn đăng nhập `VietnamMap`: đường bờ rút gọn từ Natural Earth 1:10m (phạm vi công cộng), không lấy phân loại quốc gia của nguồn; Hoàng Sa và Trường Sa thêm theo tọa độ từng đảo | Natural Earth gán Hoàng Sa cho nước khác nên không dùng nguyên bộ dữ liệu |
| — | Hành trình xanh (`/p/green`): hệ số ở `features/green/domain/green_impact.dart`, chỉ tính vé lượt đã dùng | Metro và xe máy là giả định, cần thay bằng số vận hành thật |
| Icon app | Vẽ từ `MascotPainter`: `flutter test tool/generate_app_icon_test.dart` rồi `python3 tool/resize_app_icon.py` | Icon luôn khớp linh vật |
| — | Sơ đồ 3D `Network3dView` tại `/p/explore/network`: phép chiếu phối cảnh tự viết trên `CustomPainter`, vị trí ga theo tọa độ thật, ga ngầm dưới mặt đất, mỗi tuyến một tầng độ cao; chuyển được sang `NetworkDiagram` 2D | Không thêm engine 3D: chỉ vẽ đường và điểm nên không cần, vẫn chạm chọn ga và đọc được bằng trình đọc màn hình |
| `amenity.kind` 7 loại | 10 loại: `HOSPITAL, MARKET, SHOP, FOOD, SCHOOL, PARK, LANDMARK, ATM, PARKING, TOILET` (+ `address` tùy chọn); trạm buýt gộp vào mục Quanh ga | Lọc theo nhóm Y tế, Chợ & mua sắm, Xe buýt... |
| `/api/news` | Tin tức = thông báo vận hành đã duyệt `GET /api/v1/announcements?status=APPROVED`; WARNING/CRITICAL là tin vận hành | Backend không có API tin tức riêng, chưa có ảnh tiêu đề |
| QR xoay vòng (Q3) | QR tĩnh cho demo; đã có `QrRefreshTimer` để bật sau | Theo đề xuất Q3 |
| i18n vi/en | Nhãn UI trong `lib/l10n/app_*.arb` (`context.l10n`). Thông điệp lỗi từ domain/backend vẫn là tiếng Việt (đóng vai thông điệp backend), UI dịch qua `localizeMessage`; thông điệp lạ giữ nguyên | Domain không phụ thuộc Flutter. Tên ga, tin tức, câu trả lời chatbot là dữ liệu nên không dịch |
| `firebase_messaging` + `device_token` | Interface `PushService` + `NoopPushService`; luồng đăng ký token đã có (`POST /api/me/devices`) | Chưa có `google-services.json` / `GoogleService-Info.plist`; thêm Firebase sẽ làm hỏng build |
| Quyền camera | `permission_handler` bọc trong `core/permissions/camera_permission.dart` | `mobile_scanner` không cho biết bị từ chối vĩnh viễn để hướng dẫn mở Cài đặt |

Tàu realtime: WebSocket `/ws/lines/{lineCode}/train-positions` (không cần
token). `WS_URL` rỗng thì suy ra từ `BASE_URL` (`http` → `ws`). Thông báo mới
đẩy qua SSE `GET /api/me/notifications/stream`.

### Nối API với backend (`/api/v1`)

| Tính năng | Endpoint | Ghi chú |
|---|---|---|
| Bảng giá, mua vé | `GET /public/ticket-products`, `/public/fares`, `/public/fares/quote`, `POST /tickets` | Không có API xem trước đơn: giá gốc lấy từ báo giá / giá loại vé, ưu đãi sinh viên & CPoint trừ khi tạo đơn |
| Thanh toán | `GET /me/payment-orders/{orderCode}` (poll 3s), `POST .../cancel` | Không gia hạn được đơn: "Tạo mã mới" đặt lại đơn mới cùng yêu cầu. QR VietQR dựng từ tên ngân hàng SePay → BIN |
| Vé, giao dịch | `GET /me/tickets`, `/tickets/{id}`, `/me/transactions` | Trạng thái `ACTIVE` hiển thị như `PAID`; lọc nhiều trạng thái thì lọc trên máy |
| Gửi xe | `GET /public/parking-lots`, `POST /parking/bookings` (Lượt: tới hết ngày, Ngày: 24h), `POST /parking/monthly-passes`, `GET /me/parking-bookings` | Phí xem trước tính theo bảng giá bãi, cùng công thức backend |
| CPoint | `GET /me/loyalty`, `/me/loyalty/transactions` | Chưa có chương trình ưu đãi (danh sách rỗng) |
| Sinh viên | `GET /me/student-status`, `POST /me/student-verifications` | Gửi kèm họ tên, mã SV, trường |
| Chatbot | `POST /chatbot/messages`, `.../{id}/feedback` | Phiên tạo ở câu hỏi đầu; chưa có rich card / gợi ý |
| Nhân viên | `GET /me/stations`, `POST /gates/check-in|check-out`, `POST /parking/bookings/scan`, `GET /parking-lots/{id}/sessions`, `POST /incidents`, `GET /me/incidents` | Chưa có API ca làm, thống kê, lịch sử quét: đếm từ các lượt quét trên máy trong phiên |
| Dự báo đông | — | Backend chưa có, phần dự báo bị ẩn |
Tuyến 2 là tuyến quy hoạch nên không tìm đường qua được và không có tàu.

Không dùng icon hệ thống: `uses-material-design: false`, icon mặc định của
Material (back, close) được thay bằng Lucide trong `MetroTheme`.

## Tài khoản demo (flavor dev, BASE_URL rỗng)

Mật khẩu chung `Metro@123`, mã OTP `123456`.

| Email | Kết quả |
|---|---|
| `passenger@metro.vn` | Passenger Shell |
| `staff@metro.vn` | Staff Shell (ga Thủ Đức) |
| `pending@metro.vn` | Email chưa xác thực: chuyển sang màn OTP (403) |
| `admin@metro.vn` | Màn "Vui lòng dùng trang quản trị web" |
| `locked@metro.vn` | Banner "Tài khoản đã bị khóa" (403) |

## Demo soát vé (Staff)

Đăng nhập `staff@metro.vn` (ga Thủ Đức, bãi PK2). Không có camera thì dùng
"Nhập mã vé thủ công". Bộ mã mẫu (kịch bản 12.1, phương án dự phòng):

| Mã vé | Token QR | Kết quả khi Vào ga |
|---|---|---|
| `VE-MAU-01` | `tk_mau01` | Hợp lệ (Ra ga sau đó cũng hợp lệ) |
| `VE-MAU-02` | `tk_mau02` | Vé đã được sử dụng |
| `VE-MAU-03` | `tk_mau03` | Vé hết hạn |
| `VE-MAU-04` | `tk_mau04` | Ra ga: Check-out sai ga |

Gửi xe mẫu tại bãi PK2: `pk_mau1` (Chưa gửi → Đang gửi → Đã lấy xe).

Trên **một máy**: đăng nhập hành khách mua vé → đăng xuất → đăng nhập nhân
viên → nhập mã `VE-80021` (dữ liệu demo giữ trong bộ nhớ của app). Demo
**hai máy** cần backend chung (thật hoặc mock server trên LAN) như mục 12.1.

Build:
- Android: `compileSdk = 37` (yêu cầu của `permission_handler` 13).
- iOS: sau `flutter build ios` lần đầu, thêm vào `post_install` của
  `ios/Podfile`:
  `config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'PERMISSION_CAMERA=1']`.

## Lộ trình

| Giai đoạn | Nội dung | Prompt | Trạng thái |
|---|---|---|---|
| 1 | Khung dự án, `core/qr`, tokens & theme, Splash, gallery | 0–1 | ✅ |
| 2 | Component atoms/molecules + gallery | 2 | ✅ |
| 3 | Lõi mạng, auth (A1–A4), router & 2 shell | 3–4 | ✅ |
| 4 | Khám phá mạng lưới, tàu realtime | 5–6 | ✅ |
| 5 | Đặt vé & thanh toán, vé của tôi & QR | 7–8 | ✅ |
| 6 | Gửi xe, thành viên, thông báo, chatbot | 9–11 | ✅ |
| 7 | Staff: soát vé & gửi xe | 12 | ✅ |
| 8 | Hoàn thiện & kiểm thử: i18n vi/en, rà cỡ chữ 1.3 / dark mode / trợ năng / tiếng Anh, integration test 4 flow | 13 | ✅ (còn đo khởi động & jank bản đồ trên máy thật) |
| 9 | Chỉnh UI: sơ đồ mạng lưới, Trợ lý nút nổi, tiện ích quanh ga, tin tức có ảnh ở Trang chủ, luồng mua vé 3 bước + thanh toán VietQR (SePay) | — | ✅ |
