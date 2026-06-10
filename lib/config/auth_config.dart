/// 第三方登录 / 分享相关配置
///
/// 用于集中管理各家 OAuth 应用的 Key / Secret / Redirect URI 以及分享落地域名。
///
/// 推荐通过 `--dart-define=...` 在构建时注入真实值，
/// 避免把密钥硬编码进仓库。例如：
///
/// ```bash
/// flutter run \
///   --dart-define=GOOGLE_WEB_CLIENT_ID=xxxxxxxxx.apps.googleusercontent.com \
///   --dart-define=X_CLIENT_ID=xxxx \
///   --dart-define=X_REDIRECT_URI=otakumovie://x-login-callback
/// ```
class AuthConfig {
  AuthConfig._();

  // ===================== Google =====================
  //
  // serverClientId 必须是 GCP OAuth 中类型为「Web 应用」的 Client ID，
  // 后端 `oauth.google.client-ids` 也要包含同一个 ID，否则 idToken 的 audience
  // 校验会失败导致登录被拒。
  //
  // 移动端额外创建的「iOS / Android 应用」Client ID 不需要在这里填，
  // 只需放好 GoogleService-Info.plist / google-services.json 即可。

  /// GCP「Web 应用」类型的 Client ID。
  /// 用作 GoogleSignIn 的 `serverClientId`，决定后端拿到的 idToken 的 audience。
  static const String googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue:
        '848743710183-olc0gj881jpn02gkc9n5bbqiot8slh7k.apps.googleusercontent.com',
  );

  // ===================== Apple =====================
  //
  // Apple 登录在 iOS 上不需要任何客户端密钥；后端通过 Apple 公钥 JWKS 校验 idToken。
  // 这里保留一个 audience 标识，主要用于在 Web/Android 端用 OIDC 流程时拼接 redirect。

  /// Apple 登录的 audience，应与后端 `oauth.apple.client-ids` 中的一项一致，
  /// 也与 Xcode capabilities 里 Sign in with Apple 绑定的 Bundle ID 一致。
  static const String appleAudience = String.fromEnvironment(
    'APPLE_AUDIENCE',
    defaultValue: '',
  );

  // ===================== X (Twitter) - OAuth 2.0 PKCE =====================
  //
  // 在 X Developer Portal (https://developer.x.com) 创建 OAuth 2.0 客户端时：
  // - **Type 选 "Native App"**（公共客户端，不发 client_secret）
  // - Callback URLs / Redirect URI 填 [xRedirectUri] 完全一致的值
  // - Required Scopes 至少包含 `users.read`、`tweet.read`、`offline.access`
  //
  // 公共客户端只持有 client_id，没有 client_secret 也无需传 secret —— PKCE 的 code_verifier
  // 就是安全保证。token 交换由 flutter_appauth 自动完成，App 拿到 access_token 后回传给
  // 后端，由后端调 X /2/users/me 验真，再签发我们自己的会话 token。

  /// X OAuth 2.0 Client ID（Native App 类型）。
  static const String xClientId = String.fromEnvironment(
    'X_CLIENT_ID',
    defaultValue: 'ZWQzNzNfZi1zRU1pT2ZWSVBFclQ6MTpjaQ',
  );

  /// X 登录回调地址，必须与 `AndroidManifest.xml` / `Info.plist`
  /// 中配置的 URL scheme 保持一致，并且 X Developer Portal 中也配同一条。
  static const String xRedirectUri = String.fromEnvironment(
    'X_REDIRECT_URI',
    defaultValue: 'otakumovie://x-login-callback',
  );

  /// X OAuth 2.0 授权与 token endpoint。
  /// 授权页优先走 x.com 域名（twitter.com 会跳转，部分机型 Custom Tab 里容易丢 OAuth state）。
  static const String xAuthorizationEndpoint =
      'https://x.com/i/oauth2/authorize';
  static const String xTokenEndpoint = 'https://api.twitter.com/2/oauth2/token';

  /// 申请的 scope。`offline.access` 用于换取 refresh_token，可在 token 过期后续期；
  /// 仅做一次性登录的话可去掉这个 scope。
  static const List<String> xScopes = <String>[
    'users.read',
    'tweet.read',
    'offline.access',
  ];

  // ===================== 分享落地页 =====================
  //
  // 分享出去的链接指向的 H5 域名。未装 App 的用户会落到 movie-web 站点，
  // 已装 App 用户会通过 Universal Link / App Link 直接跳到对应页面。

  /// 分享落地站点（movie-web 部署到的根域名）。
  static const String webShareBaseUrl = String.fromEnvironment(
    'WEB_SHARE_BASE_URL',
    defaultValue: 'https://otaku-movie.com',
  );
}
