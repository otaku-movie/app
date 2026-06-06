import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:uuid/uuid.dart';
import 'package:otaku_movie/analytics/events.dart';
import 'package:otaku_movie/firebase_options.dart';

/// 统一埋点入口（Firebase Analytics + Crashlytics）。
///
/// 设计要点：
///   - **未配置 Firebase 时自动降级**：`init()` 里 `Firebase.initializeApp()` 失败时，
///     `_enabled=false`，之后所有 `logEvent` 变成 no-op，App 照常运行、不崩。
///   - **购票漏斗 flow_id**：进入漏斗（showtime_list_view）时 `startPurchaseFlow()`
///     生成一个 id，后续漏斗事件自动带上 `flow_id`，便于在 GA4 里把一次购票串成漏斗。
class Analytics {
  Analytics._();
  static final Analytics instance = Analytics._();

  static const _uuid = Uuid();

  bool _enabled = false;
  bool get enabled => _enabled;

  FirebaseAnalytics? _fa;
  String? _purchaseFlowId;

  /// 在 main() 里 await 调用一次。失败不抛，只降级。
  Future<void> init() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _fa = FirebaseAnalytics.instance;
      _enabled = true;

      // 把 Flutter / 异步未捕获异常转交 Crashlytics（debug 下不上报）。
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);
    } catch (e) {
      _enabled = false;
      if (kDebugMode) {
        debugPrint('[Analytics] Firebase 未配置，埋点已降级为 no-op：$e');
      }
    }
  }

  /// 路由观察者：接入 GoRouter 的 observers，自动上报 screen_view。
  /// 未启用时返回一个无副作用的普通 observer。
  NavigatorObserver get observer => _enabled && _fa != null
      ? FirebaseAnalyticsObserver(analytics: _fa!)
      : NavigatorObserver();

  /// 上报一个事件。params 会自动剔除 null、并把值规整成 Firebase 接受的类型。
  Future<void> logEvent(String name, [Map<String, Object?>? params]) async {
    if (!_enabled || _fa == null) return;
    try {
      await _fa!.logEvent(
        name: name,
        parameters: _sanitize(params),
      );
    } catch (e) {
      if (kDebugMode) debugPrint('[Analytics] logEvent($name) 失败：$e');
    }
  }

  Future<void> logScreenView(String screenName) async {
    if (!_enabled || _fa == null) return;
    try {
      await _fa!.logScreenView(screenName: screenName);
    } catch (_) {}
  }

  /// 登录后设置；登出传 null。
  Future<void> setUserId(String? id) async {
    if (!_enabled || _fa == null) return;
    try {
      await _fa!.setUserId(id: id);
    } catch (_) {}
  }

  Future<void> setUserProperty(String name, String? value) async {
    if (!_enabled || _fa == null) return;
    try {
      await _fa!.setUserProperty(name: name, value: value);
    } catch (_) {}
  }

  /// 记录一个非致命错误到 Crashlytics（如捕获到的业务异常）。
  Future<void> recordError(Object error, StackTrace? stack,
      {String? reason}) async {
    if (!_enabled) return;
    try {
      await FirebaseCrashlytics.instance
          .recordError(error, stack, reason: reason, fatal: false);
    } catch (_) {}
  }

  // ——— 购票漏斗 flow_id ———

  /// 进入购票漏斗时调用（showtime_list_view），生成新的 flow_id 并返回。
  String startPurchaseFlow() {
    _purchaseFlowId = _uuid.v4();
    return _purchaseFlowId!;
  }

  String? get purchaseFlowId => _purchaseFlowId;

  /// 上报一个购票漏斗事件，自动带上当前 flow_id。
  Future<void> logFunnel(String name, [Map<String, Object?>? params]) {
    final merged = <String, Object?>{
      if (_purchaseFlowId != null) P.flowId: _purchaseFlowId,
      ...?params,
    };
    return logEvent(name, merged);
  }

  Map<String, Object> _sanitize(Map<String, Object?>? params) {
    final out = <String, Object>{};
    if (params == null) return out;
    params.forEach((k, v) {
      if (v == null) return;
      if (v is int || v is double || v is String) {
        out[k] = v;
      } else if (v is bool) {
        out[k] = v ? 1 : 0; // GA4 不支持 bool，转 0/1
      } else {
        final s = v.toString();
        out[k] = s.length > 100 ? s.substring(0, 100) : s;
      }
    });
    return out;
  }
}
