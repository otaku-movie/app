import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AuthStorage {
  AuthStorage._();

  static final AuthStorage instance = AuthStorage._();

  static const _secureStorage = FlutterSecureStorage();
  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';
  static const _deviceIdKey = 'deviceId';
  final ValueNotifier<int> authVersion = ValueNotifier<int>(0);

  Future<String?> get accessToken async {
    final token = await _secureStorage.read(key: _accessTokenKey);
    if (token != null && token.isNotEmpty) return token;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // 旧版本兼容，后续登录/刷新会迁移到 secure storage
  }

  Future<String?> get refreshToken => _secureStorage.read(key: _refreshTokenKey);

  Future<String> getOrCreateDeviceId() async {
    String? deviceId = await _secureStorage.read(key: _deviceIdKey);
    if (deviceId != null && deviceId.isNotEmpty) return deviceId;
    deviceId = const Uuid().v4();
    await _secureStorage.write(key: _deviceIdKey, value: deviceId);
    return deviceId;
  }

  Future<void> saveTokens({
    required String? accessToken,
    required String? refreshToken,
  }) async {
    var changed = false;
    if (accessToken != null && accessToken.isNotEmpty) {
      await _secureStorage.write(key: _accessTokenKey, value: accessToken);
      changed = true;
    }
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
      changed = true;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    if (changed) _notifyAuthChanged();
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userInfo');
    _notifyAuthChanged();
  }

  void _notifyAuthChanged() {
    authVersion.value++;
  }
}
