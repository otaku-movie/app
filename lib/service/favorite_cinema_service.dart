import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/log/index.dart';
import 'package:otaku_movie/service/auth_storage.dart';

/// C 端「收藏影院」服务。收藏以 cinema_id 为准，需登录。
///
/// 接口：
///  - POST /app/cinema/favorite/toggle  收藏/取消（toggle），body: { cinemaId }
///  - GET  /app/cinema/favorite/ids     当前用户收藏的 cinema id 列表
class FavoriteCinemaService {
  FavoriteCinemaService._();
  static final FavoriteCinemaService instance = FavoriteCinemaService._();

  Future<bool> isLoggedIn() async {
    final token = await AuthStorage.instance.accessToken;
    return token != null && token.isNotEmpty;
  }

  Future<bool?> toggle(int cinemaId) async {
    try {
      final res = await ApiRequest().request<bool>(
        path: '/app/cinema/favorite/toggle',
        method: 'POST',
        data: {'cinemaId': cinemaId},
        fromJsonT: (json) => json == true,
      );
      if (res.code == 200) {
        return res.data ?? false;
      }
    } catch (e) {
      log.e('toggle favorite cinema failed', error: e);
    }
    return null;
  }

  Future<Set<int>> fetchIds() async {
    if (!await isLoggedIn()) return <int>{};
    try {
      final res = await ApiRequest().request<List<dynamic>>(
        path: '/app/cinema/favorite/ids',
        method: 'GET',
        fromJsonT: (json) => json as List<dynamic>? ?? [],
      );
      if (res.code == 200 && res.data != null) {
        return res.data!
            .map((e) => e is int ? e : int.tryParse(e.toString()))
            .whereType<int>()
            .toSet();
      }
    } catch (e) {
      log.e('fetch favorite cinema ids failed', error: e);
    }
    return <int>{};
  }
}
