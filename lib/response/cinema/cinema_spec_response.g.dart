// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cinema_spec_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CinemaSpecResponse _$CinemaSpecResponseFromJson(Map<String, dynamic> json) =>
    CinemaSpecResponse(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CinemaSpecResponseToJson(CinemaSpecResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };
