import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import 'package:otaku_movie/analytics/analytics.dart';
import 'package:otaku_movie/analytics/events.dart';
import 'package:otaku_movie/config/config.dart';
import 'package:otaku_movie/controller/LanguageController.dart';
import 'package:otaku_movie/l10n/app_localizations.dart';
import 'package:otaku_movie/log/index.dart';
import 'package:otaku_movie/response/response.dart';
import 'package:otaku_movie/response/user/login_response.dart';
import 'package:otaku_movie/router/router.dart';
import 'package:otaku_movie/service/auth_storage.dart';
import 'package:otaku_movie/utils/toast.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// API 请求封装类
/// 提供统一的 HTTP 请求接口，包含请求拦截、错误处理、国际化错误消息等功能
class ApiRequest {
  late Dio _dio;
  SharedPreferences? _prefs;
  static Future<bool>? _refreshing;

  /// 构造函数
  /// 初始化 Dio 实例，配置请求拦截器、响应拦截器和错误拦截器
  ApiRequest() {
    _initializeSharedPreferences();
    _dio = Dio(
      BaseOptions(
        baseUrl: Config.baseUrl,
        // 连接超时：仅等待 TCP 建连，过长会导致「服务器宕机/地址错」时卡住半小时才报错
        connectTimeout: const Duration(seconds: 15),
        // 接收超时：等待首字节/完整响应；一般接口足够；大文件上传可单请求覆写 Options
        receiveTimeout: const Duration(seconds: 120),
        sendTimeout: const Duration(seconds: 120),
      ),
    );

    // 请求/响应/错误拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        /// 请求拦截器：在发送请求前添加 token 和语言设置
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
          // 确保 SharedPreferences 已经初始化
          _prefs ??= await SharedPreferences.getInstance();

          // 从本地存储获取 token
          String? token = await AuthStorage.instance.accessToken;
          
          // 获取用户选择的语言环境（优先使用 LanguageController 中的语言，否则使用系统语言）
          Locale locale;
          if (Get.isRegistered<LanguageController>()) {
            locale = Get.find<LanguageController>().locale.value;
          } else {
            locale = PlatformDispatcher.instance.locale;
          }
          final languageCode = locale.languageCode;
          final countryCode = locale.countryCode ?? '';
          final acceptLanguage = '$languageCode-$countryCode';

          // 设置请求头：Accept-Language 和 token
          options.headers['Accept-Language'] = acceptLanguage;
          options.headers['token'] = token;

          return handler.next(options);
        },
        /// 响应拦截器：处理响应数据
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          return handler.next(response);
        },
        /// 错误拦截器：处理 HTTP 错误，401 时跳转到登录页
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (error.response?.statusCode == 401) {
            final retried = await _tryRefreshAndReplay(error);
            if (retried != null) {
              return handler.resolve(retried);
            }
            await AuthStorage.instance.clearTokens();
            routerConfig.pushNamed('login');
            return handler.next(error);
          } else {
            return handler.next(error);
          }
        },
      ),
    );

    // 埋点拦截器：统一记录接口耗时与失败（api_error）。
    // 放在业务拦截器之后、日志拦截器之前；用 options.extra 暂存起始时间算 latency。
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.extra['_ts'] = DateTime.now().millisecondsSinceEpoch;
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // 业务码非 200（RestBean 约定）也算一次失败，便于排查后端异常。
          final data = response.data;
          if (data is Map && data['code'] != null && data['code'] != 200) {
            Analytics.instance.logEvent(Ev.apiError, {
              P.path: response.requestOptions.path,
              P.method: response.requestOptions.method,
              P.httpCode: response.statusCode,
              P.bizCode: data['code'],
              P.latencyMs: _latencyOf(response.requestOptions),
            });
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          Analytics.instance.logEvent(Ev.apiError, {
            P.path: error.requestOptions.path,
            P.method: error.requestOptions.method,
            P.httpCode: error.response?.statusCode ?? -1,
            P.bizCode: (error.response?.data is Map)
                ? (error.response!.data as Map)['code']
                : null,
            P.reason: error.type.name,
            P.latencyMs: _latencyOf(error.requestOptions),
          });
          return handler.next(error);
        },
      ),
    );

    // 调试模式：添加请求和响应日志拦截器
    _dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
    ));

    // 调试模式：添加美化日志拦截器（仅调试模式启用）
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: false,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 500,
      enabled: kDebugMode,
    ));
  }

  /// 初始化 SharedPreferences
  /// 用于存储和获取 token 等本地数据
  Future<void> _initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// 根据 onRequest 暂存的起始时间算接口耗时（毫秒）；缺失则返回 -1。
  int _latencyOf(RequestOptions options) {
    final ts = options.extra['_ts'];
    if (ts is int) return DateTime.now().millisecondsSinceEpoch - ts;
    return -1;
  }

  Future<Response<dynamic>?> _tryRefreshAndReplay(DioException error) async {
    final refreshToken = await AuthStorage.instance.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) return null;
    final ok = await _refreshAccessToken(refreshToken);
    if (!ok) return null;

    final accessToken = await AuthStorage.instance.accessToken;
    final requestOptions = error.requestOptions;
    requestOptions.headers['token'] = accessToken;
    return _dio.fetch(requestOptions);
  }

  Future<bool> _refreshAccessToken(String refreshToken) async {
    if (_refreshing != null) return _refreshing!;
    _refreshing = () async {
      try {
        final deviceId = await AuthStorage.instance.getOrCreateDeviceId();
        final dio = Dio(BaseOptions(baseUrl: Config.baseUrl));
        final response = await dio.post('/user/refresh', data: {
          'refreshToken': refreshToken,
          'deviceId': deviceId,
        });
        final apiResponse = ApiResponse<LoginResponse>.fromJson(
          response.data,
          (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
        );
        if (apiResponse.code == 200 && apiResponse.data != null) {
          await AuthStorage.instance.saveTokens(
            accessToken: apiResponse.data!.accessToken ?? apiResponse.data!.token,
            refreshToken: apiResponse.data!.refreshToken,
          );
          return true;
        }
      } catch (e) {
        log.e('Refresh token failed', error: e);
      } finally {
        _refreshing = null;
      }
      return false;
    }();
    return _refreshing!;
  }

  /// 将下划线命名转为驼峰命名
  /// 例如：hello_world -> helloWorld
  String snakeToCamel(String input) {
    return input.replaceAllMapped(RegExp('_(.)'), (match) {
      return match.group(1)!.toUpperCase();
    });
  }

  /// 发送 HTTP 请求
  /// 
  /// [path] 请求路径（相对于 baseUrl）
  /// [method] HTTP 方法（GET、POST、PUT、DELETE 等）
  /// [data] 请求体数据
  /// [queryParameters] URL 查询参数
  /// [headers] 额外的请求头
  /// [responseType] 响应类型（默认 JSON）
  /// [fromJsonT] JSON 转对象的转换函数
  /// 
  /// 返回 [ApiResponse<T>] 包装的响应数据
  Future<ApiResponse<T>> request<T>({
    required String path,
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    ResponseType? responseType,
    required T Function(dynamic) fromJsonT,
  }) async {
    try {
      Options options = Options(
        method: method,
        headers: headers,
        responseType: responseType ?? ResponseType.json
      );
      

      Response response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      final contentType = response.headers.value('content-type');

      // 检查响应类型：如果不是 JSON（如图片、文件等），直接包装返回
      if (contentType != null && !contentType.contains('application/json')) {
        return ApiResponse<T>(
          code: response.statusCode ?? 200,
          message: 'success',
          data: response.data as T,
        );
      }
      
      // 解析 JSON 响应数据
      ApiResponse<T> apiResponse = ApiResponse<T>.fromJson(
        response.data,
        (json) => fromJsonT(json),
      );
      
      // 检查响应状态码（与 RestBean 约定一致：200=成功）
      if (response.statusCode == 200 && apiResponse.code == 200) {
        return apiResponse;
      }
      // 非 200：显示错误消息后仍返回，由调用方根据 code 处理（如 3203 不可用座位）
      ToastService.showInfo(apiResponse.message ?? '');
      return apiResponse;
      
    } catch (e) {
      // 错误处理
      if (e is DioException) {
        // 处理网络连接错误（超时、连接失败等）
        if (e.type == DioExceptionType.connectionError || 
            e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          String errorMessage = _getNetworkErrorMessage(e);
          log.e('Network error: $errorMessage', error: e);
          ToastService.showError(errorMessage);
        } else if (e.response != null) {
          // 处理服务器返回的错误响应（如 400, 500 等）
          if (e.response?.data != null && e.response!.data is Map) {
            final responseData = e.response!.data as Map;
            // RestBean：200=成功，非 200 时展示 message
            if (responseData['code'] != 200 && responseData['message'] != null) {
              ToastService.showInfo(responseData['message'] as String);
            }
          }
        } else {
          // 其他类型的 DioException
          log.e('DioException: ${e.message}', error: e);
        }
      } else {
        // 非 DioException 的异常
        log.e('Unexpected error', error: e);
      }
      rethrow;
    }
  }

  /// 将驼峰命名转为下划线命名
  String camelToSnake(String text) {
    return text.replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (match) {
      return '${match.group(1)}_${match.group(2)?.toLowerCase()}';
    }).toLowerCase();
  }

  /// 获取网络错误消息（国际化）
  /// 
  /// 根据 [DioException] 的类型和错误信息，返回对应语言的错误提示
  /// 支持的错误类型：
  /// - 连接被拒绝（Connection refused）
  /// - 无法连接到主机（No route to host）
  /// - 连接超时（Connection timeout）
  /// - 网络不可达（Network unreachable）
  /// - 主机解析失败（Host lookup failed）
  /// - 发送超时（Send timeout）
  /// - 接收超时（Receive timeout）
  /// - 连接错误（Connection error）
  String _getNetworkErrorMessage(DioException e) {
    // 获取当前系统语言环境
    final locale = PlatformDispatcher.instance.locale;
    final localizations = lookupAppLocalizations(locale);
    
    // 根据错误信息判断错误类型
    if (e.error != null) {
      final error = e.error.toString().toLowerCase();
      if (error.contains('no route to host') || error.contains('errno = 113')) {
        return localizations.common_network_error_noRouteToHost;
      } else if (error.contains('connection refused') || error.contains('errno = 111')) {
        return localizations.common_network_error_connectionRefused;
      } else if (error.contains('connection timeout') || error.contains('timed out')) {
        return localizations.common_network_error_connectionTimeout;
      } else if (error.contains('network is unreachable') || error.contains('errno = 101')) {
        return localizations.common_network_error_networkUnreachable;
      } else if (error.contains('host lookup failed') || error.contains('errno = 11001')) {
        return localizations.common_network_error_hostLookupFailed;
      }
    }
    
    // 根据 DioException 类型返回对应的错误消息
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return localizations.common_network_error_connectionTimeout;
      case DioExceptionType.sendTimeout:
        return localizations.common_network_error_sendTimeout;
      case DioExceptionType.receiveTimeout:
        return localizations.common_network_error_receiveTimeout;
      case DioExceptionType.connectionError:
        return localizations.common_network_error_connectionError;
      default:
        return localizations.common_network_error_default;
    }
  }
}
