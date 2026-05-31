import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/config/auth_config.dart';
import 'package:otaku_movie/log/index.dart';
import 'package:otaku_movie/service/auth_storage.dart';

/// 退出登录链路。
///
/// 一个「干净」的退出需要做四件事，缺一不可：
/// 1. 调后端 `/user/logout`：让后端把 refreshToken 失效、Sa-Token 会话踢掉。
///    带 `refresh-token` header 让后端能精确撤销当前设备的 refreshToken。
/// 2. 调三方 SDK signOut/disconnect：清掉系统级缓存，下次再点 Google 登录会
///    重新弹账号选择器，而不是默认沿用上次的账号。
/// 3. 清本地 secure storage 中的 token / userInfo。
/// 4. 把路由切到登录页（由调用方负责，方便处理「确认弹窗」等 UI）。
class AuthLogoutService {
  AuthLogoutService._();
  static final AuthLogoutService instance = AuthLogoutService._();

  Future<void> logout() async {
    await _callBackendLogout();
    await _signOutThirdParty();
    await AuthStorage.instance.clearTokens();
  }

  Future<void> _callBackendLogout() async {
    try {
      final refreshToken = await AuthStorage.instance.refreshToken;
      await ApiRequest().request<Object?>(
        path: '/user/logout',
        method: 'POST',
        headers: refreshToken == null || refreshToken.isEmpty
            ? null
            : {'refresh-token': refreshToken},
        fromJsonT: (_) => null,
      );
    } on DioException catch (e) {
      // 401/网络异常都不能阻塞退出：本地状态必须能清。
      log.w('Backend logout call failed, continue local cleanup. code=${e.response?.statusCode}');
    } catch (e, st) {
      log.w('Backend logout unexpected error', error: e, stackTrace: st);
    }
  }

  Future<void> _signOutThirdParty() async {
    // Google：用与登录页一致的 serverClientId，否则同一个 SDK 实例可能拿不到当前会话。
    try {
      final google = GoogleSignIn(
        serverClientId: AuthConfig.googleWebClientId.isEmpty
            ? null
            : AuthConfig.googleWebClientId,
        scopes: const ['email', 'profile', 'openid'],
      );
      // signOut：清当前 App 的 Google 登录态；下次会重新弹账号选择器。
      // disconnect：连带撤销 OAuth 授权（用户体验更彻底但有时会报错）。失败不抛。
      if (await google.isSignedIn()) {
        await google.signOut();
        try {
          await google.disconnect();
        } catch (_) {}
      }
    } catch (e, st) {
      log.w('Google signOut failed', error: e, stackTrace: st);
    }

    // Apple 没有公开的 signOut API（Apple 的 ID 是在系统设置里管理的），略过。
    // X (Twitter)：flutter_appauth 没有显式 signOut，Cookie 清掉即可，略过。

    // ignore: avoid_print
    if (Platform.isIOS || Platform.isAndroid) {
      // 占位：将来若引入 LINE / Facebook 等其他 IDP，统一在这里挂 signOut 调用。
    }
  }
}
