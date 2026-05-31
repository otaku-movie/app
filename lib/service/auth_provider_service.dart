import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:otaku_movie/config/config.dart';
import 'package:otaku_movie/log/index.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProviderInfo {
  final String code;
  final String name;
  final bool enabled;
  final String platform;
  final int sort;

  const AuthProviderInfo({
    required this.code,
    required this.name,
    required this.enabled,
    required this.platform,
    required this.sort,
  });

  factory AuthProviderInfo.fromJson(Map<String, dynamic> json) {
    return AuthProviderInfo(
      code: (json['code'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      enabled: (json['enabled'] as bool?) ?? false,
      platform: (json['platform'] as String?) ?? 'ALL',
      sort: (json['sort'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'enabled': enabled,
        'platform': platform,
        'sort': sort,
      };
}

class AuthProviderService {
  AuthProviderService._();
  static final AuthProviderService instance = AuthProviderService._();

  static const _cacheKey = 'auth_provider_config_cache';

  Map<String, bool> get fallbackVisibility => {
        'EMAIL': true,
        'GOOGLE': true,
        'APPLE': kDebugMode,
        'X': true,
      };

  Future<Map<String, bool>> loadVisibility() async {
    final cached = await _readCache();
    final fallback = cached ?? fallbackVisibility;

    try {
      final providers = await _fetchRemoteProviders();
      await _writeCache(providers);
      return _toVisibility(providers);
    } catch (e, stackTrace) {
      log.e('Fetch auth providers failed', error: e, stackTrace: stackTrace);
      return fallback;
    }
  }

  Future<Map<String, bool>?> _readCache() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cacheKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      return _toVisibility(
        decoded
            .whereType<Map>()
            .map((e) => AuthProviderInfo.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
    } catch (e) {
      log.e('Read auth provider cache failed', error: e);
      return null;
    }
  }

  Future<void> _writeCache(List<AuthProviderInfo> providers) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _cacheKey,
      jsonEncode(providers.map((e) => e.toJson()).toList()),
    );
  }

  Future<List<AuthProviderInfo>> _fetchRemoteProviders() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final platform =
        defaultTargetPlatform == TargetPlatform.iOS ? 'IOS' : 'Android';
    final dio = Dio(
      BaseOptions(
        baseUrl: Config.baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 8),
      ),
    );
    final response = await dio.get(
      '/app/auth/providers',
      queryParameters: {
        'platform': platform,
        'appVersion': packageInfo.version,
      },
    );
    final body = response.data;
    if (body is! Map || body['code'] != 200 || body['data'] is! List) {
      throw StateError('Invalid auth providers response');
    }
    return (body['data'] as List)
        .whereType<Map>()
        .map((e) => AuthProviderInfo.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => a.sort.compareTo(b.sort));
  }

  Map<String, bool> _toVisibility(List<AuthProviderInfo> providers) {
    final result = <String, bool>{
      'EMAIL': true,
      'GOOGLE': false,
      'APPLE': false,
      'X': false,
    };
    for (final provider in providers) {
      final code = provider.code.trim().toUpperCase();
      if (code.isEmpty) continue;
      result[code] = provider.enabled;
    }
    // 邮箱密码登录是基础兜底入口，避免后台误关导致用户完全无法登录。
    result['EMAIL'] = true;
    return result;
  }
}
