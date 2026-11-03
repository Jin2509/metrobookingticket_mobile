import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/core/di/core_providers.dart';

/// Banner Trang chủ. `image` là URL mạng hoặc đường dẫn `assets/...`.
@immutable
class HomeBanner {
  const HomeBanner({
    required this.title,
    required this.image,
    this.subtitle,
    this.linkPath,
  });

  factory HomeBanner.fromJson(Map<String, dynamic> j, String baseUrl) =>
      HomeBanner(
        title: j['title'] as String,
        subtitle: j['subtitle'] as String?,
        linkPath: j['linkPath'] as String?,
        image: '$baseUrl${j['imagePath']}',
      );

  final String title;
  final String? subtitle;
  final String image;
  final String? linkPath;
}

/// Hiện khi backend chưa bật lưu trữ, chưa có banner hoặc không tải được.
const fallbackBanners = [
  HomeBanner(
    title: 'Đặt chỗ gửi xe ngay trên app',
    image: 'assets/news/elevated_station.jpg',
    linkPath: '/p/parking/book',
  ),
  HomeBanner(
    title: 'Khám phá sơ đồ 3D',
    image: 'assets/news/train.jpg',
    linkPath: '/p/explore/network',
  ),
  HomeBanner(
    title: 'Tin tức Metro',
    image: 'assets/news/ben_thanh.jpg',
    linkPath: '/p/news',
  ),
];

/// Lỗi mạng không làm hỏng Trang chủ: quay về banner có sẵn.
Future<List<HomeBanner>> loadHomeBanners(Dio dio, String baseUrl) async {
  try {
    final res = await dio.get<List<dynamic>>('/api/content/banners');
    final banners = [
      for (final j in res.data ?? const <dynamic>[])
        HomeBanner.fromJson(j as Map<String, dynamic>, baseUrl),
    ];
    return banners.isEmpty ? fallbackBanners : banners;
  } on DioException {
    return fallbackBanners;
  }
}

final homeBannersProvider = FutureProvider<List<HomeBanner>>(
  (ref) => Env.useFakeAuth
      ? Future.value(fallbackBanners)
      : loadHomeBanners(ref.watch(dioProvider), Env.baseUrl),
);
