import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:otaku_movie/config/config.dart';
import 'package:otaku_movie/log/index.dart';
import 'package:otaku_movie/response/response.dart';
import 'package:otaku_movie/router/router.dart';
import 'package:otaku_movie/utils/toast.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiRequest {
  late Dio _dio;
  SharedPreferences? _prefs;

  ApiRequest() {
    _initializeSharedPreferences();  // 在构造函数中初始化 SharedPreferences
    _dio = Dio(
      BaseOptions(
        baseUrl: Config.baseUrl, // 确保baseUrl格式正确
        connectTimeout: const Duration(seconds: 60 * 30), // 连接超时
        receiveTimeout: const Duration(seconds: 60 * 30), // 接收超时
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
          // 确保 SharedPreferences 已经初始化
          _prefs ??= await SharedPreferences.getInstance();

          String? token = _prefs?.getString('token');  // 获取 token
          
          final locale = PlatformDispatcher.instance.locale;
          final languageCode = locale.languageCode;
          final countryCode = locale.countryCode ?? '';
          final acceptLanguage = '$languageCode-$countryCode';

          // 设置 Accept-Language 和 token
          options.headers['Accept-Language'] = acceptLanguage;
          options.headers['token'] = token;

          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          if (error.response?.statusCode == 401) {
            routerConfig.pushNamed('login');
          } else {
            return handler.next(error);
          }
        },
      ),
    );

    // 调试用：记录请求和响应
    _dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
    ));

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

  // 初始化 SharedPreferences
  Future<void> _initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String snakeToCamel(String input) {
    return input.replaceAllMapped(RegExp('_(.)'), (match) {
      return match.group(1)!.toUpperCase();
    });
  }

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

      // 检查响应类型 - 如果不是 JSON，直接包装成 ApiResponse 返回
      if (contentType != null && !contentType.contains('application/json')) {
        return ApiResponse<T>(
          code: response.statusCode ?? 200,
          message: 'success',
          data: response.data as T,  // 直接返回原始数据（图片、文件等）
        );
      }
      
      ApiResponse<T> apiResponse = ApiResponse<T>.fromJson(
        response.data,
        (json) => fromJsonT(json),
      );
      
      if (response.statusCode == 200 && apiResponse.code == 200) {
        return apiResponse;
      } else {
        ToastService.showInfo(apiResponse.message ?? '');
        return apiResponse;
      }
      
    } catch (e) {
      if (e is DioException) {
        if (e.response?.data['code'] != 1) {
          ToastService.showInfo(e.response?.data['message'] ?? '');
        }
      }
      log.e(e);
      rethrow;
    }
  }

  /// 将驼峰命名转为下划线命名
  String camelToSnake(String text) {
    return text.replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (match) {
      return '${match.group(1)}_${match.group(2)?.toLowerCase()}';
    }).toLowerCase();
  }

  Map<String, dynamic> _convertToSnakeCase(Map<String, dynamic>? json) {
    if (json == null) return {};

    final Map<String, dynamic> convertedJson = {};

    json.forEach((key, value) {
      final newKey = camelToSnake(key);

      if (value is List) {
        convertedJson[newKey] = value.map((item) {
          return item is Map<String, dynamic> ? _convertToSnakeCase(item) : item;
        }).toList();
      } else if (value is Map) {
        convertedJson[newKey] = _convertToSnakeCase(value as Map<String, dynamic>);
      } else {
        convertedJson[newKey] = value;
      }
    });

    return convertedJson;
  }
}
