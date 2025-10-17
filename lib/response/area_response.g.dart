// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AreaResponse _$AreaResponseFromJson(Map<String, dynamic> json) => AreaResponse(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      nameKana: json['nameKana'] as String?,
      parentId: (json['parentId'] as num?)?.toInt(),
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => AreaResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AreaResponseToJson(AreaResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameKana': instance.nameKana,
      'parentId': instance.parentId,
      'children': instance.children?.map((e) => e.toJson()).toList(),
    };
