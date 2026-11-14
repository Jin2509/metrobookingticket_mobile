import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/core/di/core_providers.dart';

/// Banner Trang chủ. `image` là URL mạng.
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

/// Lỗi mạng không làm hỏng Trang chủ: ẩn băng banner.
Future<List<HomeBanner>> loadHomeBanners(Dio dio, String baseUrl) async {
  try {
    final res = await dio.get<List<dynamic>>('/api/content/banners');
    final banners = [
      for (final j in res.data ?? const <dynamic>[])
        HomeBanner.fromJson(j as Map<String, dynamic>, baseUrl),
    ];
    return banners;
  } on DioException {
    return const [];
  }
}

final homeBannersProvider = FutureProvider<List<HomeBanner>>(
  (ref) => loadHomeBanners(ref.watch(dioProvider), Env.baseUrl),
);
