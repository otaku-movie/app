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
      page: (json['page'] as num?)?.toInt() ?? 1, // 处理 null 值
      total: (json['total'] as num?)?.toInt() ?? 0, // 处理 null 值
      pageSize: (json['page_size'] as num?)?.toInt() ?? 10, // 处理 null 值
      list: (json['list'] as List<dynamic>?)
              ?.map((e) => fromJsonT(e)) // 防止 list 为 null
              .toList() ??
          [], // 处理 null 值
    );

Map<String, dynamic> _$ApiPaginationResponseToJson<T>(
  ApiPaginationResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'page': instance.page,
      'total': instance.total,
      'page_size': instance.pageSize,
      'list': instance.list.isNotEmpty
          ? instance.list.map((e) => toJsonT(e)).toList()
          : [], // 如果 list 为空，则转换为空列表
    };