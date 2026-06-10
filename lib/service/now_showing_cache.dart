import 'dart:async';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:otaku_movie/config/config.dart';
import 'package:otaku_movie/controller/LanguageController.dart';
import 'package:otaku_movie/log/index.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/movie/movieList/movie_now_showing.dart';

/// 「上映中」首屏数据的内存预取缓存。
///
/// 目的：splash（启动页）有一段最短展示时间（默认 1.5s）是纯等待的空档，
/// 在这段时间里把「上映中」第一页拉好放进内存，进首页时 [NowShowing] 直接
/// 命中缓存渲染（0 loading），再后台静默刷新，避免首页那一下白屏 loading。
///
/// 设计要点：
/// - **不阻塞启动**：[prefetch] 由 splash `unawaited` 调用，独立轻量 Dio +
///   短超时，失败静默忽略——拿不到就让 [NowShowing] 自己按原逻辑请求。
/// - **不污染 splash UI**：不走主 `ApiRequest`（它失败会弹 toast），自带 Dio，
///   只附带 `Accept-Language`，公开接口无需 token。
/// - **一次性消费**：[consume] 读取后清空，保证缓存只用于「本次启动首屏」，
///   之后的下拉刷新 / 分页仍走页面原有网络逻辑，不会拿到过期数据。
class NowShowingCache {
  NowShowingCache._();
  static final NowShowingCache instance = NowShowingCache._();

  /// 首屏预取页大小，需与 [NowShowing] 首页请求一致（pageSize=10）。
  static const int firstPageSize = 10;

  List<MovieNowShowingResponse>? _data;
  int _total = 0;
  int _pageSize = firstPageSize;
  Future<void>? _inflight;

  /// 预取第一页。重复调用复用同一个在途请求，不会重复打网络。
  Future<void> prefetch() {
    if (_data != null) return Future.value();
    return _inflight ??= _fetch();
  }

  Future<void> _fetch() async {
    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: Config.baseUrl,
          connectTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 4),
          headers: {'Accept-Language': _acceptLanguage()},
        ),
      );
      final resp = await dio.get(
        '/app/movie/nowShowing',
        queryParameters: {'page': 1, 'pageSize': firstPageSize},
      );
      final body = resp.data;
      if (body is! Map || body['code'] != 200 || body['data'] is! Map) return;
      final pag = ApiPaginationResponse<MovieNowShowingResponse>.fromJson(
        Map<String, dynamic>.from(body['data'] as Map),
        (d) => MovieNowShowingResponse.fromJson(d as Map<String, dynamic>),
      );
      _data = pag.list ?? <MovieNowShowingResponse>[];
      _total = pag.total ?? 0;
      _pageSize = pag.pageSize ?? firstPageSize;
    } catch (e, st) {
      // 预取失败不致命：页面会自己再拉。仅记日志，不弹 toast、不抛。
      log.w('Prefetch nowShowing failed', error: e, stackTrace: st);
    } finally {
      _inflight = null;
    }
  }

  /// 取走缓存快照（一次性）：返回后立即清空，确保只在首屏命中一次。
  /// 未预取到 / 已被消费时返回 null。
  CachedNowShowing? consume() {
    final list = _data;
    if (list == null) return null;
    _data = null;
    return CachedNowShowing(list: list, total: _total, pageSize: _pageSize);
  }

  String _acceptLanguage() {
    Locale locale;
    if (Get.isRegistered<LanguageController>()) {
      locale = Get.find<LanguageController>().locale.value;
    } else {
      locale = PlatformDispatcher.instance.locale;
    }
    return '${locale.languageCode}-${locale.countryCode ?? ''}';
  }
}

/// 预取到的「上映中」首屏快照。
class CachedNowShowing {
  final List<MovieNowShowingResponse> list;
  final int total;
  final int pageSize;

  const CachedNowShowing({
    required this.list,
    required this.total,
    required this.pageSize,
  });
}
