// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_pagination_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiPaginationResponse<T> _$ApiPaginationResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ApiPaginationResponse<T>(
      page: (json['page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      pageSize: (json['page_size'] as num).toInt(),
      list: (json['list'] as List<dynamic>).map(fromJsonT).toList(),
    );

Map<String, dynamic> _$ApiPaginationResponseToJson<T>(
  ApiPaginationResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'page': instance.page,
      'total': instance.total,
      'page_size': instance.pageSize,
      'list': instance.list.map(toJsonT).toList(),
    };
