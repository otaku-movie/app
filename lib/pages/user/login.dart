import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:otaku_movie/analytics/analytics.dart';
import 'package:otaku_movie/analytics/events.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/config/auth_config.dart';
import 'package:otaku_movie/controller/LanguageController.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/log/index.dart';
import 'package:otaku_movie/response/user/login_response.dart';
import 'package:otaku_movie/service/auth_provider_service.dart';
import 'package:otaku_movie/service/auth_storage.dart';
import 'package:otaku_movie/utils/index.dart';
import 'package:otaku_movie/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final LanguageController languageController = Get.find();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // 关键：serverClientId 必须是「Web 应用」类型的 Client ID，
  // 这样后端拿到的 idToken 的 audience 才会落在 oauth.google.client-ids 列表中，
  // 否则会被 OAuthIdTokenVerifier 抛 "id_token audience invalid"。
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: AuthConfig.googleWebClientId.isEmpty
        ? null
        : AuthConfig.googleWebClientId,
    scopes: const ['email', 'profile', 'openid'],
  );
  Map<String, bool> _authProviderVisibility =
      AuthProviderService.instance.fallbackVisibility;

  late String selectedLanguage;

  // 控制密码是否可见
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();

    final controllerLang = languageController.locale.value.languageCode;
    selectedLanguage = controllerLang.isNotEmpty
        ? controllerLang
        : PlatformDispatcher.instance.locales.first.languageCode;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      languageController.changeLanguage(selectedLanguage);
    });

    // 开发期自动填充测试账号，方便调试；生产构建不会执行。
    if (kDebugMode) {
      emailController.text = 'diy4869@gmail.com';
      passwordController.text = '123456';
    }
    _loadAuthProviders();
  }

  Future<void> _loadAuthProviders() async {
    final visibility = await AuthProviderService.instance.loadVisibility();
    if (!mounted) return;
    setState(() {
      _authProviderVisibility = visibility;
    });
  }

  bool _isAuthProviderVisible(String code) {
    return _authProviderVisibility[code.toUpperCase()] ?? false;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 点击外部不会关闭弹窗
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent, // 透明背景
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ), // 显示加载动画
          ),
        );
      },
    );
  }

  // 关闭加载弹窗
  void _hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(); // 关闭弹窗
  }

  void handleEmailPasswordLogin() {
    

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // 检查邮箱和密码是否为空
    if (email.isEmpty) {
      return ToastService.showError(S.of(context).login_email_verify_notNull);
    }
    // 检查邮箱和密码是否合法
    if (!isValidEmail(email)) {
      return ToastService.showError(S.of(context).login_email_verify_isValid);
    }  

    if (password.isEmpty) {
      return ToastService.showError(S.of(context).login_password_verify_notNull);
    }
    
    // 直接提交明文密码，由后端 BCrypt 加盐哈希存储（传输依赖 HTTPS 保护）
    String pwd = passwordController.text;

    Analytics.instance.logEvent(Ev.loginStart, {P.type: 'account'});
    _showLoadingDialog(context);
    AuthStorage.instance.getOrCreateDeviceId().then((deviceId) {
    ApiRequest().request(
      path: '/user/login',
      method: 'POST',
      data: {
        "email": emailController.text,
        "password": pwd,
        "deviceId": deviceId
      },
      fromJsonT: (json) {
        return LoginResponse.fromJson(json);
      },
    ).then((res) async {
      if (res.data != null) {
        await AuthStorage.instance.saveTokens(
          accessToken: res.data?.accessToken ?? res.data?.token,
          refreshToken: res.data?.refreshToken,
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        
        // 存储用户信息（可以将 Map 转换为 JSON 字符串存储）
        prefs.setString('userInfo', res.data.toString());

        Analytics.instance.setUserId('${res.data?.id}');
        Analytics.instance.logEvent(Ev.loginSuccess, {P.type: 'account'});
        context.goNamed('home');
      }
    
    }).catchError((err) {
      Analytics.instance.logEvent(Ev.loginFail, {
        P.type: 'account',
        P.reason: err.toString(),
      });
    }).whenComplete(() {
      _hideLoadingDialog(context);
      // setState(() {
      //   loading = false;
      // });
    });
    });
  }

  void handleGoogleLogin() async {
    try {
      Analytics.instance.logEvent(Ev.loginStart, {P.type: 'google'});
      _showLoadingDialog(context);
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _hideLoadingDialog(context);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      if (googleAuth.idToken == null) {
        _hideLoadingDialog(context);
        ToastService.showError(S.of(context).login_googleLoginFailed);
        return;
      }
      final deviceId = await AuthStorage.instance.getOrCreateDeviceId();
      // 调用后端API进行谷歌登录
      ApiRequest().request(
        path: '/user/googleLogin',
        method: 'POST',
        data: {
          "idToken": googleAuth.idToken,
          "deviceId": deviceId,
        },
        fromJsonT: (json) {
          return LoginResponse.fromJson(json);
        },
      ).then((res) async {
        if (res.data != null) {
          await AuthStorage.instance.saveTokens(
            accessToken: res.data?.accessToken ?? res.data?.token,
            refreshToken: res.data?.refreshToken,
          );
          SharedPreferences prefs = await SharedPreferences.getInstance();
          
          // 存储用户信息
          prefs.setString('userInfo', res.data.toString());

          Analytics.instance.setUserId('${res.data?.id}');
          Analytics.instance.logEvent(Ev.loginSuccess, {P.type: 'google'});
          context.goNamed('home');
        }
      }).catchError((err) {
        Analytics.instance.logEvent(Ev.loginFail, {
          P.type: 'google',
          P.reason: err.toString(),
        });
        ToastService.showError(S.of(context).login_googleLoginFailed);
      }).whenComplete(() {
        _hideLoadingDialog(context);
      });
      
    } catch (error, stackTrace) {
      _hideLoadingDialog(context);
      Analytics.instance.logEvent(Ev.loginFail, {
        P.type: 'google',
        P.reason: error.toString(),
      });
      ToastService.showError(S.of(context).login_googleLoginFailed);
      log.e('Google login error', error: error, stackTrace: stackTrace);
    }
  }

  /// 生成符合 Apple 文档要求的随机 nonce 字符串（32 字节，URL-safe）。
  /// 真正传给 Apple 的是它的 sha256，原文留在本地由后端二次校验。
  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// nonce 原文 → sha256 hex（小写），与 Apple 文档示例一致。
  String _sha256OfString(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }

  Future<void> handleAppleLogin() async {
    if (!Platform.isIOS) return;
    try {
      Analytics.instance.logEvent(Ev.loginStart, {P.type: 'apple'});
      _showLoadingDialog(context);

      // Apple 防重放：客户端生成 rawNonce，把 sha256(rawNonce) 传给 Apple，
      // 拿到 idToken 后把 rawNonce 原文回传给后端，由后端再次 sha256 比对。
      final rawNonce = _generateNonce();
      final hashedNonce = _sha256OfString(rawNonce);

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );
      final idToken = credential.identityToken;
      if (idToken == null) {
        _hideLoadingDialog(context);
        ToastService.showError(S.of(context).login_appleLoginFailed);
        return;
      }
      final deviceId = await AuthStorage.instance.getOrCreateDeviceId();
      ApiRequest().request(
        path: '/user/appleLogin',
        method: 'POST',
        data: {
          'idToken': idToken,
          'deviceId': deviceId,
          'nonce': rawNonce,
          // Apple 只在「首次登录」返回 givenName / familyName，二次登录后这两个字段为 null。
          // 客户端无条件回传，后端只在 idToken 本身没有 name 时拿来兜底。
          if (credential.givenName != null) 'firstName': credential.givenName,
          if (credential.familyName != null) 'lastName': credential.familyName,
        },
        fromJsonT: (json) {
          return LoginResponse.fromJson(json);
        },
      ).then((res) async {
        if (res.data != null) {
          await AuthStorage.instance.saveTokens(
            accessToken: res.data?.accessToken ?? res.data?.token,
            refreshToken: res.data?.refreshToken,
          );
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userInfo', res.data.toString());
          Analytics.instance.setUserId('${res.data?.id}');
          Analytics.instance.logEvent(Ev.loginSuccess, {P.type: 'apple'});
          context.goNamed('home');
        }
      }).catchError((err) {
        Analytics.instance.logEvent(Ev.loginFail, {
          P.type: 'apple',
          P.reason: err.toString(),
        });
        ToastService.showError(S.of(context).login_appleLoginFailed);
      }).whenComplete(() {
        _hideLoadingDialog(context);
      });
    } catch (error, stackTrace) {
      _hideLoadingDialog(context);
      Analytics.instance.logEvent(Ev.loginFail, {
        P.type: 'apple',
        P.reason: error.toString(),
      });
      ToastService.showError(S.of(context).login_appleLoginFailed);
      log.e('Apple login error', error: error, stackTrace: stackTrace);
    }
  }

  /// X 登录走 OAuth 2.0 Authorization Code Flow + PKCE。
  ///
  /// 1. `flutter_appauth` 自动生成 `code_verifier` / `code_challenge`，
  ///    打开系统浏览器到 X 授权页
  /// 2. 用户授权后 X 通过 [AuthConfig.xRedirectUri] 回调到 App，携带 `code`
  /// 3. `flutter_appauth` 自动用 code + code_verifier 到 X token endpoint 换 access_token
  /// 4. App 把 access_token 回传给后端，由后端调 X `/2/users/me` 验真并取 profile
  Future<void> handleXLogin() async {
    if (AuthConfig.xClientId.isEmpty) {
      ToastService.showError(S.of(context).login_xLoginFailed);
      log.e('X login disabled: X_CLIENT_ID not configured at build time');
      return;
    }
    try {
      Analytics.instance.logEvent(Ev.loginStart, {P.type: 'x'});
      _showLoadingDialog(context);

      const appAuth = FlutterAppAuth();
      // allowInsecureConnections 仅在 X_REDIRECT_URI 是 http 时才需要打开，
      // 我们用的 custom scheme（otakumovie://）走 native intent，无影响。
      final result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AuthConfig.xClientId,
          AuthConfig.xRedirectUri,
          serviceConfiguration: const AuthorizationServiceConfiguration(
            authorizationEndpoint: AuthConfig.xAuthorizationEndpoint,
            tokenEndpoint: AuthConfig.xTokenEndpoint,
          ),
          scopes: AuthConfig.xScopes,
          // 强制展示授权确认页，避免「已授权过」时静默跳过导致用户以为卡死。
          // 注意：flutter_appauth 7.x 中 prompt 必须用 promptValues 专用字段，
          // 放进 additionalParameters 会抛 authorize_and_exchange_code_failed。
          promptValues: const ['consent'],
        ),
      );

      final accessToken = result.accessToken;
      if (accessToken == null || accessToken.isEmpty) {
        _hideLoadingDialog(context);
        ToastService.showError(S.of(context).login_xLoginFailed);
        return;
      }

      final deviceId = await AuthStorage.instance.getOrCreateDeviceId();
      await ApiRequest().request(
        path: '/user/twitterLogin',
        method: 'POST',
        data: {
          'accessToken': accessToken,
          'deviceId': deviceId,
        },
        fromJsonT: (json) {
          return LoginResponse.fromJson(json);
        },
      ).then((res) async {
        if (res.data != null) {
          await AuthStorage.instance.saveTokens(
            accessToken: res.data?.accessToken ?? res.data?.token,
            refreshToken: res.data?.refreshToken,
          );
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userInfo', res.data.toString());
          Analytics.instance.setUserId('${res.data?.id}');
          Analytics.instance.logEvent(Ev.loginSuccess, {P.type: 'x'});
          if (!mounted) return;
          context.goNamed('home');
        }
      }).catchError((err) {
        Analytics.instance.logEvent(Ev.loginFail, {
          P.type: 'x',
          P.reason: err.toString(),
        });
        ToastService.showError(S.of(context).login_xLoginFailed);
      }).whenComplete(() {
        _hideLoadingDialog(context);
      });
    } catch (error, stackTrace) {
      _hideLoadingDialog(context);
      // 用户在 X 授权页点了「取消」或按返回键时，flutter_appauth 会抛带 cancel 关键字的异常，
      // 这里静默处理；不同平台版本的异常类型不一致，统一用消息内容匹配。
      final msg = error.toString().toLowerCase();
      if (msg.contains('cancel')) {
        return;
      }
      Analytics.instance.logEvent(Ev.loginFail, {
        P.type: 'x',
        P.reason: error.toString(),
      });
      ToastService.showError(S.of(context).login_xLoginFailed);
      log.e('X login error', error: error, stackTrace: stackTrace);
    }
  }

  Widget _getLanguageFlag(String languageCode) {
    String flag;
    switch (languageCode) {
      case 'zh':
        flag = '🇨🇳';
        break;
      case 'ja':
        flag = '🇯🇵';
        break;
      case 'en':
        flag = '🇺🇸';
        break;
      default:
        flag = '🌐';
    }
    
    return Container(
      width: 24.w,
      height: 24.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: Colors.white.withValues(alpha: 0.2),
      ),
      child: Center(
        child: Text(
          flag,
          style: TextStyle(
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: CustomAppBar(
        backgroundColor: const Color(0xFF1989FA),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Image.asset(
                'assets/image/logo.png',
                width: 40.w,
                height: 40.w,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'シネコ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language_rounded,
                  color: Colors.white,
                  size: 26.sp,
                ),
                SizedBox(width: 8.w),
                DropdownButton<String>(
                  value: selectedLanguage,
                  items: languageController.lang.map((entry) => DropdownMenuItem<String>(
                    value: entry['code'],
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _getLanguageFlag(entry['code'] as String),
                          SizedBox(width: 12.w),
                          Text(
                            entry['name'] as String,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )).toList(),
                  dropdownColor: const Color(0xFF323233),
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  underline: const SizedBox(),
                  onChanged: (value) {
                    if (value != null) {
                      languageController.changeLanguage(value);
                      setState(() {
                        selectedLanguage = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView( 
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1989FA).withValues(alpha: 0.05),
                  const Color(0xFFF7F8FA),
                ],
              ),
            ),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h), 
                  
                  // Logo 区域
                Center(
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/image/logo.png',
                            width: 64.w,
                            height: 64.w,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'シネコ',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF323233),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // 登录表单卡片
                  Container(
                    padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 标题
                        Text(
                          S.of(context).login_loginButton,
                          style: TextStyle(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF323233),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          S.of(context).login_welcomeText,
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: const Color(0xFF969799),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 40.h),
                        
                        // 邮箱输入框
                        _buildEmailField(),
                        SizedBox(height: 24.h),
                        
                        // 密码输入框
                        _buildPasswordField(),
                        SizedBox(height: 32.h),
                        
                        // 登录按钮
                        _buildLoginButton(),
                        SizedBox(height: 24.h),
                        
                        // 分割线
                        _buildDivider(),
                        SizedBox(height: 24.h),
                        
                        // 第三方登录按钮区
                        if (_isAuthProviderVisible('GOOGLE')) ...[
                          _buildGoogleLoginButton(),
                          SizedBox(height: 16.h),
                        ],
                        if (_isAuthProviderVisible('APPLE') && Platform.isIOS) ...[
                          _buildAppleLoginButton(),
                          SizedBox(height: 16.h),
                        ],
                        if (_isAuthProviderVisible('X')) _buildXLoginButton(),
                        SizedBox(height: 24.h),
                        
                        // 注册链接
                        _buildRegisterLink(),
                        SizedBox(height: 16.h),
                        _buildAgreementNotice(),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 40.h),
                  
                  // 忘记密码
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        context.pushNamed('forgotPassword');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF1989FA).withValues(alpha: 0.1),
                              const Color(0xFF069EF0).withValues(alpha: 0.1),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(25.r),
                          border: Border.all(
                            color: const Color(0xFF1989FA).withValues(alpha: 0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1989FA).withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lock_reset,
                              color: const Color(0xFF1989FA),
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              S.of(context).login_forgotPassword,
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: const Color(0xFF1989FA),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: emailController,
        decoration: InputDecoration(
          labelText: S.of(context).login_email_text,
          labelStyle: TextStyle(
            color: const Color(0xFF969799),
            fontSize: 24.sp,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(12.w),
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1989FA).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.email_outlined,
              color: const Color(0xFF1989FA),
              size: 28.sp,
            ),
          ),
          filled: true,
          fillColor: const Color(0xFFF7F8FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: const BorderSide(
              color: Color(0xFF1989FA),
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  ),
                  keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontSize: 28.sp,
          color: const Color(0xFF323233),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
                  controller: passwordController,
        obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: S.of(context).login_password_text,
          labelStyle: TextStyle(
            color: const Color(0xFF969799),
            fontSize: 24.sp,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(12.w),
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1989FA).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.lock_outline,
              color: const Color(0xFF1989FA),
              size: 28.sp,
            ),
          ),
          suffixIcon: Container(
            margin: EdgeInsets.all(12.w),
            child: IconButton(
                      icon: Icon(
                _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: const Color(0xFF969799),
                size: 28.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
          filled: true,
          fillColor: const Color(0xFFF7F8FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: const BorderSide(
              color: Color(0xFF1989FA),
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        ),
        style: TextStyle(
          fontSize: 28.sp,
          color: const Color(0xFF323233),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1989FA), Color(0xFF069EF0)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1989FA).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: handleEmailPasswordLogin,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.login,
                  color: Colors.white,
                  size: 32.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  S.of(context).login_loginButton,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1.h,
            color: const Color(0xFFE6E6E6),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            S.of(context).login_or,
            style: TextStyle(
              fontSize: 24.sp,
              color: const Color(0xFF969799),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1.h,
            color: const Color(0xFFE6E6E6),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleLoginButton() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFE6E6E6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: handleGoogleLogin,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/social/google.svg',
                  width: 36.w,
                  height: 36.w,
                ),
                SizedBox(width: 12.w),
                Text(
                  S.of(context).login_googleLogin,
                  style: TextStyle(
                    fontSize: 28.sp,
                    color: const Color(0xFF323233),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _agreementNoticeText() {
    final lang = languageController.locale.value.languageCode;
    if (lang == 'zh') return '登录或注册即表示您已阅读并同意';
    if (lang == 'en') return 'By signing in or registering, you agree to';
    return 'ログインまたは登録により、以下に同意したものとみなされます';
  }

  Widget _buildAgreementNotice() {
    final linkStyle = TextStyle(
      fontSize: 22.sp,
      color: const Color(0xFF1989FA),
      fontWeight: FontWeight.w600,
    );
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4.w,
      runSpacing: 4.h,
      children: [
        Text(
          _agreementNoticeText(),
          style: TextStyle(fontSize: 22.sp, color: const Color(0xFF969799)),
        ),
        GestureDetector(
          onTap: () => context.pushNamed(
            'agreement',
            pathParameters: {'code': 'USER_TERMS'},
          ),
          child: Text(S.of(context).user_userTerms, style: linkStyle),
        ),
        Text(
          '/',
          style: TextStyle(fontSize: 22.sp, color: const Color(0xFF969799)),
        ),
        GestureDetector(
          onTap: () => context.pushNamed(
            'agreement',
            pathParameters: {'code': 'PRIVACY_POLICY'},
          ),
          child: Text(S.of(context).user_privateAgreement, style: linkStyle),
        ),
      ],
    );
  }

  Widget _buildAppleLoginButton() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: handleAppleLogin,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/social/apple.svg',
                  width: 32.w,
                  height: 32.w,
                ),
                SizedBox(width: 12.w),
                Text(
                  S.of(context).login_appleLogin,
                  style: TextStyle(
                    fontSize: 28.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildXLoginButton() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: handleXLogin,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/social/x.svg',
                  width: 28.w,
                  height: 28.w,
                ),
                SizedBox(width: 12.w),
                Text(
                  S.of(context).login_xLogin,
                  style: TextStyle(
                    fontSize: 28.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          S.of(context).login_noAccount,
          style: TextStyle(
            fontSize: 24.sp,
            color: const Color(0xFF969799),
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: () {
            context.pushNamed('register');
          },
          child: Text(
            S.of(context).register_registerButton,
            style: TextStyle(
              fontSize: 24.sp,
              color: const Color(0xFF1989FA),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
