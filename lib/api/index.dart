import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:otaku_movie/log/index.dart';
import 'package:otaku_movie/response/response.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
// import 'package:flutter/material.dart';

class ApiRequest {
  late Dio _dio;

  ApiRequest() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.1.7:8080/api', // 确1保baseUrl格式正确
        connectTimeout: const Duration(seconds: 60 * 5), // 连接超时
        receiveTimeout: const Duration(seconds: 60 * 5), // 接收超时
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          final locale = PlatformDispatcher.instance.locale;
          final languageCode = locale.languageCode;
          final countryCode = locale.countryCode ?? '';
          final acceptLanguage = '$languageCode-$countryCode';

          // 设置 Accept-Language 头
          options.headers['Accept-Language'] = acceptLanguage;

          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          return handler.next(error);
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
      )
    );
  }

  String snakeToCamel(String input) {
    return input.replaceAllMapped(RegExp('_(.)'), (match) {
      return match.group(1)!.toUpperCase();
    });
  }

  Future<ApiResponse<T>> request<T>({
    required String path,
    required String method,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required T Function(dynamic) fromJsonT,
  }) async {
    try {
      Options options = Options(
        method: method,
        headers: headers,
      );

      // Response response = await _dio.request(
      //   path,
      //   data: _convertToSnakeCase(data),
      //   queryParameters: _convertToSnakeCase(queryParameters),
      //   options: options,
      // );

      Response response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );


      ApiResponse<T> apiResponse = ApiResponse<T>.fromJson(
        response.data,
        (json) => fromJsonT(json),
      );

      return apiResponse;
    } catch (e) {
      print('----- api error -----');
      log.e(e);
    rethrow;
    }
  }
    
  /// 将驼峰命名转为下划线命名
  String camelToSnake(String text) {
    // 匹配大写字母并在前面加下划线
    return text.replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (match) {
      return '${match.group(1)}_${match.group(2)?.toLowerCase()}';
    }).toLowerCase();
  }

  Map<String, dynamic> _convertToSnakeCase(Map<String, dynamic>? json) {
  if (json == null) return {};

  final Map<String, dynamic> convertedJson = {};

  json.forEach((key, value) {
    // 将驼峰命名转换为下划线命名
    final newKey = camelToSnake(key);

    // 如果是 List 类型，递归转换
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


