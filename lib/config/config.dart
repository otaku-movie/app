import 'dart:io';
import 'package:flutter/foundation.dart';

enum EnvironmentType { dev, test, preprod, prod }

// 定义环境配置类
class EnvironmentConfig {
  final String apiUrl;
  final String imageBaseUrl;
  final String appTitle;

  const EnvironmentConfig({
    required this.apiUrl,
    required this.imageBaseUrl,
    required this.appTitle,
  });

  // 各环境的取值统一来自 dart-define（推荐用 --dart-define-from-file=env/<env>.json 注入）：
  //   - API_URL / IMAGE_BASE_URL 等地址都放在 env/*.json 里，启动命令只切环境文件。
  //   - 源码里的 defaultValue 仅作兜底，正常都被环境文件覆盖。
  static const String _apiUrlDefine =
      String.fromEnvironment('API_URL', defaultValue: '');
  static const String _imageBaseUrlDefine = String.fromEnvironment(
    'IMAGE_BASE_URL',
    defaultValue: 'https://static.otaku-movie.com',
  );

  // 根据 EnvironmentType 生成对应配置
  factory EnvironmentConfig.fromType(EnvironmentType env, {String? localIp}) {
    switch (env) {
      case EnvironmentType.dev:
        // dev：显式给了 API_URL 就用；否则按 DEV_SERVER_IP / 自动探测的局域网 IP 拼本地后端。
        const devServerIp =
            String.fromEnvironment('DEV_SERVER_IP', defaultValue: '192.168.3.47');
        final ip = localIp ?? (devServerIp.isNotEmpty ? devServerIp : '192.168.3.47');
        return EnvironmentConfig(
          apiUrl: _apiUrlDefine.isNotEmpty ? _apiUrlDefine : 'http://$ip:8080/api',
          imageBaseUrl: _imageBaseUrlDefine,
          appTitle: 'Dev Otaku Movie',
        );
      case EnvironmentType.test:
        return EnvironmentConfig(
          apiUrl: _apiUrlDefine.isNotEmpty
              ? _apiUrlDefine
              : 'https://test-api.otaku-movie.com/api',
          imageBaseUrl: _imageBaseUrlDefine,
          appTitle: 'Test Otaku Movie',
        );
      case EnvironmentType.preprod:
        return EnvironmentConfig(
          apiUrl: _apiUrlDefine,
          imageBaseUrl: _imageBaseUrlDefine,
          appTitle: 'Preprod Otaku Movie',
        );
      case EnvironmentType.prod:
        // 生产接口域名必须是 https（iOS ATS / Android 默认均禁止明文 HTTP）。
        return EnvironmentConfig(
          apiUrl: _apiUrlDefine.isNotEmpty
              ? _apiUrlDefine
              : 'https://api.otaku-movie.com/api',
          imageBaseUrl: _imageBaseUrlDefine,
          appTitle: 'Prod Otaku Movie',
        );
    }
  }
}

class Config {
  static EnvironmentType currentEnvironment = EnvironmentType.dev;
  static String? _localIpAddress;
  static String? _cachedLocalIp;

  /// 获取本机 IPv4 地址（仅在桌面平台，移动设备返回 null）
  static Future<String?> getLocalIpAddress() async {
    // 如果已经缓存，直接返回
    if (_cachedLocalIp != null) {
      return _cachedLocalIp;
    }

    // 只在桌面平台（Windows/Mac/Linux）自动获取 IP
    // 移动设备（Android/iOS）应该使用默认 IP 或通过 dart-define 传入
    if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
      try {
        // 获取所有网络接口
        final interfaces = await NetworkInterface.list(
          includeLinkLocal: false,
          type: InternetAddressType.IPv4,
        );

        // 优先查找非回环地址的 IPv4，优先选择局域网地址（192.168.x.x, 10.x.x.x, 172.16-31.x.x）
        String? preferredIp;
        String? fallbackIp;

        for (var interface in interfaces) {
          for (var addr in interface.addresses) {
            // 跳过回环地址 (127.0.0.1) 和链路本地地址 (169.254.x.x)
            if (!addr.isLoopback && 
                !addr.address.startsWith('169.254.') &&
                addr.type == InternetAddressType.IPv4) {
              
              final ip = addr.address;
              
              // 优先选择局域网 IP
              if (ip.startsWith('192.168.') || 
                  ip.startsWith('10.') || 
                  (ip.startsWith('172.') && 
                   int.tryParse(ip.split('.')[1]) != null &&
                   int.parse(ip.split('.')[1]) >= 16 &&
                   int.parse(ip.split('.')[1]) <= 31)) {
                preferredIp = ip;
                break;
              } else {
                fallbackIp ??= ip;
              }
            }
          }
          if (preferredIp != null) break;
        }

        _cachedLocalIp = preferredIp ?? fallbackIp;
        return _cachedLocalIp;
      } catch (e) {
        print('获取本机 IP 地址失败: $e');
      }
    }

    return null;
  }

  /// 初始化配置（异步获取本机 IP）
  static Future<void> initialize() async {
    if (currentEnvironment == EnvironmentType.dev) {
      // 检查是否通过 dart-define 传入了服务器 IP
      const devServerIp = String.fromEnvironment('DEV_SERVER_IP', defaultValue: '');
      if (devServerIp.isNotEmpty) {
        _localIpAddress = devServerIp;
        print('使用 dart-define 传入的开发服务器 IP: $devServerIp');
      } else {
        // 尝试自动获取（仅在桌面平台）
        _localIpAddress = await getLocalIpAddress();
        if (_localIpAddress != null) {
          print('自动检测到开发机器 IP 地址: $_localIpAddress');
        } else {
          print('未能自动获取 IP 地址，使用默认配置');
        }
      }
      
      final apiUrl = 'http://${_localIpAddress ?? '192.168.3.47'}:8080/api';
      print('API URL 已设置为: $apiUrl');
    }
  }

  static EnvironmentConfig get environmentConfig =>
      EnvironmentConfig.fromType(currentEnvironment, localIp: _localIpAddress);

  static String get baseUrl => environmentConfig.apiUrl;
  static String get imageBaseUrl => environmentConfig.imageBaseUrl;
  static String get appTitle => environmentConfig.appTitle;

  /// Android：与 `android/app/build.gradle` 的 `applicationId` 一致；发布前可用 `--dart-define=GOOGLE_PLAY_APPLICATION_ID=...` 覆盖。
  static const String googlePlayApplicationId = String.fromEnvironment(
    'GOOGLE_PLAY_APPLICATION_ID',
    defaultValue: 'com.otakumovie.app',
  );

  /// iOS：App Store Connect 中的数字 App ID（非 Bundle ID）。未配置时「立即更新」回退使用接口返回的 `downloadUrl`。
  /// 构建示例：`--dart-define=APP_STORE_APP_ID=1234567890`
  static const String appStoreAppId = String.fromEnvironment(
    'APP_STORE_APP_ID',
    defaultValue: '',
  );

  /// Google Play 应用详情页（https）。
  static String get googlePlayStoreUrl =>
      'https://play.google.com/store/apps/details?id=$googlePlayApplicationId';

  /// App Store 应用页（https）；未配置 [appStoreAppId] 时返回 null。
  static String? get appStoreListingUrl {
    final id = appStoreAppId.trim();
    if (id.isEmpty) return null;
    return 'https://apps.apple.com/app/id$id';
  }
}
