import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import 'package:otaku_movie/config/config.dart';
import 'package:otaku_movie/controller/LanguageController.dart';
import 'package:otaku_movie/l10n/app_localizations.dart';
import 'package:otaku_movie/log/index.dart';
import 'package:otaku_movie/response/response.dart';
import 'package:otaku_movie/router/router.dart';
import 'package:otaku_movie/utils/toast.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// API 请求封装类
/// 提供统一的 HTTP 请求接口，包含请求拦截、错误处理、国际化错误消息等功能
class ApiRequest {
  late Dio _dio;
  SharedPreferences? _prefs;

  /// 构造函数
  /// 初始化 Dio 实例，配置请求拦截器、响应拦截器和错误拦截器
  ApiRequest() {
    _initializeSharedPreferences();
    _dio = Dio(
      BaseOptions(
        baseUrl: Config.baseUrl,
        connectTimeout: const Duration(seconds: 60 * 30), // 连接超时时间：30分钟
        receiveTimeout: const Duration(seconds: 60 * 30), // 接收超时时间：30分钟
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
          String? token = _prefs?.getString('token');
          
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
        onError: (DioException error, ErrorInterceptorHandler handler) {
          if (error.response?.statusCode == 401) {
            // 未授权，跳转到登录页
            routerConfig.pushNamed('login');
          } else {
            return handler.next(error);
          }
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
      
      // 检查响应状态码
      if (response.statusCode == 200 && apiResponse.code == 200) {
        return apiResponse;
      } else {
        // 显示错误消息
        ToastService.showInfo(apiResponse.message ?? '');
        return apiResponse;
      }
      
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
            if (responseData['code'] != 1 && responseData['message'] != null) {
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
