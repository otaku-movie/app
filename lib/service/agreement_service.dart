import 'package:get/get.dart' hide Response;
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/controller/LanguageController.dart';
import 'package:otaku_movie/log/index.dart';
import 'package:otaku_movie/service/auth_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 协议信息（与后端 `Agreement` 字段对齐，仅保留前端关心的部分）。
class AgreementInfo {
  final String code;
  final String title;
  final String content;
  final String version;
  final String language;
  final bool isRequiredAccept;

  AgreementInfo({
    required this.code,
    required this.title,
    required this.content,
    required this.version,
    required this.language,
    required this.isRequiredAccept,
  });

  factory AgreementInfo.fromJson(String code, Map<String, dynamic> json) {
    return AgreementInfo(
      code: code,
      title: (json['title'] as String?) ?? '',
      content: (json['content'] as String?) ?? '',
      version: (json['version'] as String?) ?? '',
      language: (json['language'] as String?) ?? '',
      isRequiredAccept: (json['isRequiredAccept'] as bool?) ?? false,
    );
  }
}

/// 协议本地同意状态 & 远端同步逻辑。
///
/// 同意态以 `code -> "version|language"` 形式写到 `SharedPreferences`，
/// 启动时与 `/agreement/latest` 返回的最新版本对比，不一致即视为「有新协议」。
class AgreementService {
  AgreementService._();
  static final AgreementService instance = AgreementService._();

  static const _prefix = 'agreement_accepted_';

  /// 默认参与启动检查的协议码。
  static const List<String> defaultCodes = [
    'USER_TERMS',
    'PRIVACY_POLICY',
    'THIRD_PARTY_SDK',
  ];

  String _currentLang() {
    if (Get.isRegistered<LanguageController>()) {
      return Get.find<LanguageController>().locale.value.languageCode;
    }
    return 'ja';
  }

  String _key(String code) => '$_prefix$code';

  Future<String?> _readFingerprint(String code) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key(code));
  }

  Future<void> _writeFingerprint(
    String code,
    String version,
    String language,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(code), '$version|$language');
  }

  /// 拉取多个 code 对应的最新发布版本。
  /// DB 没有对应版本（或网络异常）时返回空列表 —— UI 应据此显示
  /// 「暂无内容」提示，而不是回退到内置静态文本（以免与 DB 内容长期漂移）。
  Future<List<AgreementInfo>> fetchLatest(
    List<String> codes,
    String lang,
  ) async {
    if (codes.isEmpty) return const [];
    try {
      final res = await ApiRequest().request<Map<String, dynamic>?>(
        path: '/agreement/latest',
        method: 'GET',
        queryParameters: {
          'codes': codes.join(','),
          'lang': lang,
        },
        fromJsonT: (json) =>
            json == null ? null : Map<String, dynamic>.from(json as Map),
      );
      final data = res.data;
      if (data == null) return const [];
      final list = <AgreementInfo>[];
      data.forEach((code, value) {
        if (value is Map) {
          list.add(
            AgreementInfo.fromJson(code, Map<String, dynamic>.from(value)),
          );
        }
      });
      return list;
    } catch (e) {
      log.e('Fetch agreements failed', error: e);
      return const [];
    }
  }

  /// 找出当前需要用户重新确认的协议（最新版本 vs 本地指纹不一致）。
  Future<List<AgreementInfo>> findPending({List<String>? codes}) async {
    final lang = _currentLang();
    final list = await fetchLatest(codes ?? defaultCodes, lang);
    final pending = <AgreementInfo>[];
    for (final item in list) {
      if (item.version.isEmpty) continue;
      final accepted = await _readFingerprint(item.code);
      final current = '${item.version}|${item.language}';
      if (accepted != current) {
        pending.add(item);
      }
    }
    return pending;
  }

  /// 标记某条协议已被用户同意。
  /// 本地立即写入；登录态下异步上报服务端，失败不阻塞 UI。
  Future<void> markAccepted(AgreementInfo info) async {
    await _writeFingerprint(info.code, info.version, info.language);
    final token = await AuthStorage.instance.accessToken;
    if (token == null || token.isEmpty) return;
    try {
      final deviceId = await AuthStorage.instance.getOrCreateDeviceId();
      await ApiRequest().request<Object?>(
        path: '/agreement/accept',
        method: 'POST',
        data: {
          'code': info.code,
          'version': info.version,
          'language': info.language,
          'deviceId': deviceId,
          'client': 'mobile',
        },
        fromJsonT: (json) => json,
      );
    } catch (e) {
      log.e('Report agreement accept failed for ${info.code}', error: e);
    }
  }
}
