import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:otaku_movie/config/config.dart';
import 'package:otaku_movie/log/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 启动页（splash）的运营可配置项。
///
/// 后端只需返回一组运营档期的元数据，前端按字段渲染：
/// - [imageUrl]：背景图远程地址（不存在时回退到 bundled `assets/image/run.png`）
/// - [titleEn] / [titleZh] / [titleJa]：标题多语言文案
/// - [subtitleEn] / [subtitleZh] / [subtitleJa]：副标题多语言文案
/// - [minDurationMs]：最少展示时长（避免一闪而过）
/// - [maxDurationMs]：最长展示时长（兜底跳过）
/// - [tapAction]：点击启动图的动作（`movie:{id}` / `url:{https://...}` / 空表示不响应）
class SplashConfig {
  final String? imageUrl;
  final String? titleEn;
  final String? titleZh;
  final String? titleJa;
  final String? subtitleEn;
  final String? subtitleZh;
  final String? subtitleJa;
  final int minDurationMs;
  final int maxDurationMs;
  final String? tapAction;

  const SplashConfig({
    this.imageUrl,
    this.titleEn,
    this.titleZh,
    this.titleJa,
    this.subtitleEn,
    this.subtitleZh,
    this.subtitleJa,
    this.minDurationMs = 1500,
    this.maxDurationMs = 3500,
    this.tapAction,
  });

  static const SplashConfig fallback = SplashConfig(
    imageUrl: null,
    titleEn: 'Otaku Movie',
    titleZh: 'Otaku Movie',
    titleJa: 'Otaku Movie',
    subtitleEn: 'Anime movies, in one tap',
    subtitleZh: '动漫电影，一键直达',
    subtitleJa: 'アニメ映画をワンタップで',
    minDurationMs: 1500,
    maxDurationMs: 3500,
  );

  factory SplashConfig.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic v, int defaultValue) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? defaultValue;
      return defaultValue;
    }

    return SplashConfig(
      imageUrl: json['imageUrl'] as String?,
      titleEn: json['titleEn'] as String?,
      titleZh: json['titleZh'] as String?,
      titleJa: json['titleJa'] as String?,
      subtitleEn: json['subtitleEn'] as String?,
      subtitleZh: json['subtitleZh'] as String?,
      subtitleJa: json['subtitleJa'] as String?,
      minDurationMs: parseInt(json['minDurationMs'], 1500),
      maxDurationMs: parseInt(json['maxDurationMs'], 3500),
      tapAction: json['tapAction'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'imageUrl': imageUrl,
        'titleEn': titleEn,
        'titleZh': titleZh,
        'titleJa': titleJa,
        'subtitleEn': subtitleEn,
        'subtitleZh': subtitleZh,
        'subtitleJa': subtitleJa,
        'minDurationMs': minDurationMs,
        'maxDurationMs': maxDurationMs,
        'tapAction': tapAction,
      };

  String resolveTitle(String languageCode) {
    switch (languageCode) {
      case 'zh':
        return titleZh ?? titleEn ?? titleJa ?? '';
      case 'ja':
        return titleJa ?? titleEn ?? titleZh ?? '';
      default:
        return titleEn ?? titleJa ?? titleZh ?? '';
    }
  }

  String resolveSubtitle(String languageCode) {
    switch (languageCode) {
      case 'zh':
        return subtitleZh ?? subtitleEn ?? subtitleJa ?? '';
      case 'ja':
        return subtitleJa ?? subtitleEn ?? subtitleZh ?? '';
      default:
        return subtitleEn ?? subtitleJa ?? subtitleZh ?? '';
    }
  }
}

/// 启动页配置服务：
/// - 进入 App 时**立刻**返回本地缓存（首屏 0 延迟），再后台静默拉取最新配置
/// - 拉取成功后写回缓存，下次冷启动生效
/// - 任一步骤失败都不会阻塞 App 进入主流程
class SplashConfigService {
  SplashConfigService._();
  static final SplashConfigService instance = SplashConfigService._();

  static const _cacheKey = 'splash_config_cache_v1';

  Future<SplashConfig> loadCached() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cacheKey);
      if (raw == null || raw.isEmpty) return SplashConfig.fallback;
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return SplashConfig.fallback;
      return SplashConfig.fromJson(Map<String, dynamic>.from(decoded));
    } catch (e, st) {
      log.w('Read splash cache failed', error: e, stackTrace: st);
      return SplashConfig.fallback;
    }
  }

  Future<SplashConfig?> fetchRemote() async {
    try {
      // 启动期还没初始化主 ApiRequest，单开一个轻量 Dio 实例，超时设短以免拖慢进入主页。
      final dio = Dio(
        BaseOptions(
          baseUrl: Config.baseUrl,
          connectTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 4),
        ),
      );
      final response = await dio.get('/app/splash/current');
      final body = response.data;
      if (body is! Map || body['code'] != 200 || body['data'] is! Map) {
        return null;
      }
      final config = SplashConfig.fromJson(
        Map<String, dynamic>.from(body['data'] as Map),
      );
      // 后台写回缓存，下次冷启动直接命中。
      unawaited(_writeCache(config));
      return config;
    } catch (e, st) {
      log.w('Fetch splash config failed', error: e, stackTrace: st);
      return null;
    }
  }

  Future<void> _writeCache(SplashConfig config) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonEncode(config.toJson()));
    } catch (e, st) {
      log.w('Write splash cache failed', error: e, stackTrace: st);
    }
  }
}

/// 调用方手动忽略 Future 的语义糖（避免 lint 警告）。
void unawaited(Future<void> future) {
  // ignore: avoid_returning_null_for_void
  future.then((_) {}, onError: (_) {});
}
