import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:otaku_movie/response/response.dart';
// import 'package:flutter/material.dart';

class ApiRequest {
  late Dio _dio;

  ApiRequest() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://test-api.otaku-movie.com/api', // 确保baseUrl格式正确
        connectTimeout: const Duration(seconds: 5), // 连接超时
        receiveTimeout: const Duration(seconds: 5), // 接收超时
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
    // _dio.interceptors.add(LogInterceptor(
    //   responseBody: true,
    //   requestBody: true,
    // ));

    // _dio.interceptors.add(PrettyDioLogger(
    //     requestHeader: true,
    //     requestBody: true,
    //     responseBody: true,
    //     responseHeader: false,
    //     error: true,
    //     compact: true,
    //     maxWidth: 90,
    //     enabled: kDebugMode,
    //   )
    // );
  }

  Future<ApiResponse<T>> request<T>({
    required String path,
    required String method,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required T Function(Map<String, dynamic>) fromJsonT,
  }) async {
    try {
      Options options = Options(
        method: method,
        headers: headers,
      );

      Response response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      ApiResponse<T> apiResponse = ApiResponse<T>.fromJson(
        response.data,
        (json) => fromJsonT(json as Map<String, dynamic>),
      );

      return apiResponse;
    } catch (e) {
      print('----- api error -----');
      rethrow;
    }
  }
}


