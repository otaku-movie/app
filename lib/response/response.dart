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

  /// 安全解析 code：后端可能返回 int、num 或 String（如 "200"）
  static int? _parseCode(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  // 从 JSON 映射转换为 ApiResponse 对象的工厂方法
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiResponse<T>(
      code: _parseCode(json['code']),
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'] as String?,
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
