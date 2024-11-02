import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final int code;
  final T data;
  final String message;

  ApiResponse({
    required this.code,
    required this.data,
    required this.message,
  });

  // 从 JSON 映射转换为 ApiResponse 对象的工厂方法
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return _$ApiResponseFromJson(json, fromJsonT);
  }

  // 将 ApiResponse 对象转换为 JSON 映射的方法
  Map<String, dynamic> toJson(
    Object? Function(T value) toJsonT,
  ) {
    return _$ApiResponseToJson(this, toJsonT);
  }
}
