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

  AgreementInfo? fallbackForCode(String code, String lang) {
    final normalizedLang = ['zh', 'ja', 'en'].contains(lang) ? lang : 'ja';
    final content = _fallbackContent[normalizedLang]?[code];
    final title = _fallbackTitle[normalizedLang]?[code];
    if (content == null || title == null) return null;
    return AgreementInfo(
      code: code,
      title: title,
      content: content,
      version: '1.0.0',
      language: normalizedLang,
      isRequiredAccept: code != 'THIRD_PARTY_SDK',
    );
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

  /// 拉取多个 code 对应的最新发布版本。网络异常时返回空列表。
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
      if (data == null) {
        return codes
            .map((code) => fallbackForCode(code, lang))
            .whereType<AgreementInfo>()
            .toList();
      }
      final list = <AgreementInfo>[];
      data.forEach((code, value) {
        if (value is Map) {
          list.add(
            AgreementInfo.fromJson(code, Map<String, dynamic>.from(value)),
          );
        }
      });
      final existingCodes = list.map((e) => e.code).toSet();
      for (final code in codes) {
        if (!existingCodes.contains(code)) {
          final fallback = fallbackForCode(code, lang);
          if (fallback != null) list.add(fallback);
        }
      }
      return list;
    } catch (e) {
      log.e('Fetch agreements failed', error: e);
      return codes
          .map((code) => fallbackForCode(code, lang))
          .whereType<AgreementInfo>()
          .toList();
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

const Map<String, Map<String, String>> _fallbackTitle = {
  'zh': {
    'USER_TERMS': '用户协议',
    'PRIVACY_POLICY': '隐私协议',
    'THIRD_PARTY_SDK': '第三方 SDK 清单',
  },
  'ja': {
    'USER_TERMS': '利用規約',
    'PRIVACY_POLICY': 'プライバシーポリシー',
    'THIRD_PARTY_SDK': 'サードパーティ SDK 一覧',
  },
  'en': {
    'USER_TERMS': 'User Terms',
    'PRIVACY_POLICY': 'Privacy Policy',
    'THIRD_PARTY_SDK': 'Third-party SDK List',
  },
};

const Map<String, Map<String, String>> _fallbackContent = {
  'zh': {
    'USER_TERMS': '''
# 用户协议

**版本号**：1.0.0

欢迎使用 Otaku Movie。本协议适用于您通过本 App 浏览电影、查询影院场次、在线选座购票、管理订单、发表评论以及使用 Google / Apple 等第三方账号登录的全部行为。

## 1. 账号与使用

您应提供真实、准确的信息，并妥善保管账号、密码及验证码。通过您的账号产生的操作视为您本人行为。发现账号异常时，请及时联系我们处理。

## 2. 票务与订单

电影票、场次、座位、价格以下单时页面展示为准。支付完成后生成订单和取票凭证。退改签规则以订单页、影院规则及适用法律法规为准。

## 3. 用户内容

您发布评论、评分、图片等内容时，应遵守法律法规，不得发布侵权、违法、骚扰、虚假或影响他人正常使用的内容。我们可依法对违规内容进行处理。

## 4. 协议更新

如本协议发生重要变更，我们会在 App 内向您提示。继续使用或点击同意即表示您接受更新后的协议。
''',
    'PRIVACY_POLICY': '''
# 隐私协议

**版本号**：1.0.0

我们重视您的个人信息保护。本隐私协议说明 Otaku Movie 在提供注册登录、电影票务、附近影院、订单管理和评论等服务时如何收集、使用和保护您的信息。

## 1. 我们收集的信息

- 账号信息：邮箱、昵称、头像，以及 Google / Apple 登录返回的账号标识。
- 订单信息：电影、影院、场次、座位、订单金额、支付状态、取票信息。
- 设备与日志：设备型号、系统版本、App 版本、IP 地址、接口访问日志、由 App 本地生成的 deviceId。
- 位置信息：仅在您授权后，用于推荐附近影院或展示城市信息。
- 图片信息：仅在您主动选择头像、评论图片或反馈截图时使用。

## 2. 使用目的

我们使用上述信息用于账号登录、安全风控、订单履约、客服处理、附近影院推荐、产品优化及依法合规所必需的场景。

## 3. 信息共享

我们不会出售您的个人信息。为实现登录、定位、图片选择、本地安全存储等功能，App 会使用必要的第三方 SDK，详情请查看《第三方 SDK 清单》。

## 4. 您的权利

您可以在 App 中查看和修改资料，也可以通过客服渠道申请注销账号、删除或更正个人信息。您可随时在系统设置中关闭定位、相册、相机等权限。
''',
    'THIRD_PARTY_SDK': '''
# 第三方 SDK 清单

**版本号**：1.0.0

为保障 App 正常运行，我们集成以下第三方 SDK 或系统能力。

| SDK / 服务 | 用途 | 触发场景 |
|---|---|---|
| google_sign_in | Google 账号登录 | 点击 Google 登录 |
| sign_in_with_apple | Apple ID 登录 | iOS 点击 Apple 登录 |
| flutter_appauth | X 账号登录 | 点击 X 登录 |
| geolocator / geocoding | 获取位置并解析城市 | 查询附近影院、选择城市 |
| image_picker / image_editor | 选择、拍摄、裁剪图片 | 修改头像、上传评论图片 |
| flutter_secure_storage | 加密保存 token 和 deviceId | 登录、刷新登录态 |
| shared_preferences | 保存语言等偏好 | 切换语言、保存本地设置 |
| dio / url_launcher | 网络请求、打开外部链接 | 使用 App 服务、点击链接 |

以上能力仅在相关功能触发时使用。系统权限可在手机系统设置中关闭。
''',
  },
  'ja': {
    'USER_TERMS': '''
# 利用規約

**バージョン**：1.0.0

Otaku Movie をご利用いただきありがとうございます。本規約は、映画情報の閲覧、劇場・上映回の検索、座席選択、チケット購入、注文管理、レビュー投稿、Google / Apple ログイン等の利用に適用されます。

## 1. アカウント

利用者は正確な情報を登録し、アカウント、パスワード、認証コードを適切に管理するものとします。アカウント上で行われた操作は、原則として本人による操作とみなされます。

## 2. チケットと注文

チケット、上映回、座席、価格は注文時の画面表示を基準とします。支払い完了後、注文情報と入場用情報が発行されます。返金・変更条件は注文画面、劇場規則および法令に従います。

## 3. 規約の変更

重要な変更がある場合、アプリ内で通知します。同意または継続利用により、更新後の規約に同意したものとみなされます。
''',
    'PRIVACY_POLICY': '''
# プライバシーポリシー

**バージョン**：1.0.0

Otaku Movie は個人情報の保護を重視します。本ポリシーは、ログイン、チケット購入、近くの映画館検索、注文管理、レビュー等の提供に必要な情報の取扱いを説明します。

## 1. 収集する情報

- アカウント情報：メールアドレス、ニックネーム、アイコン、Google / Apple ログイン識別子。
- 注文情報：映画、劇場、上映回、座席、金額、支払い状態。
- 端末・ログ情報：端末情報、OS、アプリバージョン、IP アドレス、deviceId。
- 位置情報：許可された場合のみ、近くの映画館表示等に使用します。
- 画像情報：利用者が選択または撮影した画像のみ使用します。

## 2. 利用目的

ログイン、注文処理、安全対策、近くの映画館表示、カスタマーサポート、サービス改善のために使用します。

## 3. 第三者 SDK

本アプリは必要な第三者 SDK を使用します。詳細は「サードパーティ SDK 一覧」をご確認ください。
''',
    'THIRD_PARTY_SDK': '''
# サードパーティ SDK 一覧

**バージョン**：1.0.0

| SDK / サービス | 目的 | 利用場面 |
|---|---|---|
| google_sign_in | Google ログイン | Google ログインを押した時 |
| sign_in_with_apple | Apple ID ログイン | iOS で Apple ログインを押した時 |
| flutter_appauth | X ログイン | X ログインを押した時 |
| geolocator / geocoding | 位置取得・都市名表示 | 近くの映画館検索 |
| image_picker / image_editor | 画像選択・編集 | アイコン変更、画像投稿 |
| flutter_secure_storage | token / deviceId の安全保存 | ログイン状態の保持 |
| shared_preferences | 言語などの設定保存 | 設定変更時 |
| dio / url_launcher | 通信・外部リンク表示 | アプリ利用、リンククリック |
''',
  },
  'en': {
    'USER_TERMS': '''
# User Terms

**Version**: 1.0.0

Welcome to Otaku Movie. These terms apply when you browse movies, search cinemas and showtimes, select seats, purchase tickets, manage orders, post reviews, or sign in with Google / Apple.

## 1. Account

You should provide accurate information and keep your account, password, and verification codes secure. Actions performed under your account are generally treated as your own actions.

## 2. Tickets and Orders

Tickets, showtimes, seats, and prices are based on the information displayed at checkout. Refunds and changes follow the order page, cinema rules, and applicable laws.

## 3. User Content

Reviews, ratings, and uploaded images must comply with applicable laws and must not infringe others' rights or disrupt the service.

## 4. Updates

If these terms are materially updated, we will notify you in the app. Continuing to use the app or tapping agree means you accept the updated terms.
''',
    'PRIVACY_POLICY': '''
# Privacy Policy

**Version**: 1.0.0

Otaku Movie values your privacy. This policy explains how we collect, use, and protect information when providing account login, ticketing, nearby cinema search, order management, and review features.

## 1. Information We Collect

- Account information: email, nickname, avatar, and Google / Apple login identifiers.
- Order information: movie, cinema, showtime, seat, amount, payment status, and ticket information.
- Device and logs: device model, OS version, app version, IP address, request logs, and locally generated deviceId.
- Location: only after permission is granted, for nearby cinema and city features.
- Images: only images you actively select or capture.

## 2. How We Use Information

We use information for login, security, order fulfillment, support, nearby cinema recommendations, product improvement, and legal compliance.

## 3. Third-party SDKs

The app uses necessary third-party SDKs for login, location, image selection, secure local storage, and networking. See the Third-party SDK List for details.
''',
    'THIRD_PARTY_SDK': '''
# Third-party SDK List

**Version**: 1.0.0

| SDK / Service | Purpose | Trigger |
|---|---|---|
| google_sign_in | Google account login | When tapping Google login |
| sign_in_with_apple | Apple ID login | When tapping Apple login on iOS |
| flutter_appauth | X account login | When tapping X login |
| geolocator / geocoding | Location and city lookup | Nearby cinema features |
| image_picker / image_editor | Pick, capture, and edit images | Avatar or image upload |
| flutter_secure_storage | Securely store token and deviceId | Login and session refresh |
| shared_preferences | Store language and local preferences | Settings changes |
| dio / url_launcher | Network requests and external links | App usage and link clicks |
''',
  },
};
