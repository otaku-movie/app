import 'package:json_annotation/json_annotation.dart';

part 'api_pagination_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiPaginationResponse<T> {
  final int? page;
  final int? total;
  final int? pageSize;
  final List<T>? list;

  ApiPaginationResponse({
    required this.page,
    required this.total,
    required this.pageSize,
    required this.list,
  });

  // Adjusting fromJson to accept Object? instead of Map<String, dynamic>
  factory ApiPaginationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,  // Change here to accept Object? instead of Map<String, dynamic>
  ) =>
      _$ApiPaginationResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiPaginationResponseToJson(this, toJsonT);

  ApiPaginationResponse<T> copyWith({
    int? page,
    int? total,
    int? pageSize,
    List<T>? list,
  }) => ApiPaginationResponse<T>(
        page: page ?? this.page,
        total: total ?? this.total,
        pageSize: pageSize ?? this.pageSize,
        list: list ?? this.list,
      );
}
