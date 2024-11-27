import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final int? code;
  final T? data;
  final String? message;

  ApiResponse({
    this.code,
    this.data,
    this.message,
  });

  // 从 JSON 映射转换为 ApiResponse 对象的工厂方法
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {

    return ApiResponse<T>(
      code: json['code'] as int?, // 处理可能的 null 值
      data: json['data'] != null ?  fromJsonT(json['data']) : null, // 处理 data 可能的 null 值
      message: json['message'] as String?, // 处理可能的 null 值
    );
  }

  // 将 ApiResponse 对象转换为 JSON 映射的方法
  Map<String, dynamic> toJson(
    Object? Function(T? value) toJsonT,
  ) {
    return {
      'code': code, // 这里可以是 null
      'data': toJsonT(data), // 处理可能的 null 值
      'message': message, // 这里可以是 null
    };
  }
}
