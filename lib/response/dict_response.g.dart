// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dict_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DictItemResponse _$DictItemResponseFromJson(Map<String, dynamic> json) =>
    DictItemResponse(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      code: (json['code'] as num?)?.toInt(),
      dictId: (json['dictId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DictItemResponseToJson(DictItemResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'dictId': instance.dictId,
    };
