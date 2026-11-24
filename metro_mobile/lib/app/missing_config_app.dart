import 'package:flutter/material.dart';

/// Hiện khi build thiếu `--dart-define-from-file`: `BASE_URL` rỗng thì mọi
/// request đều lỗi và app chỉ báo "Không có kết nối mạng", rất khó đoán ra
/// nguyên nhân. Màn này nói thẳng cần chạy lệnh gì.
class MissingConfigApp extends StatelessWidget {
  const MissingConfigApp({super.key});

  static const _commands =
      'make run-device      # điện thoại thật cắm USB\n'
      'make run             # máy ảo Android\n\n'
      'hoặc:\n'
      'flutter run --dart-define-from-file=config/device.json';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.settings_ethernet, size: 48),
              const SizedBox(height: 16),
              Text(
                'Chưa cấu hình BASE_URL',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'App được build mà không có file cấu hình nên không biết '
                'backend ở đâu. Dừng app rồi chạy lại bằng một trong các '
                'lệnh sau (trong thư mục metro_mobile):',
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const SelectableText(
                  _commands,
                  style: TextStyle(fontFamily: 'monospace', fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
