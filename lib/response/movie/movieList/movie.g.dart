// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieResponse _$MovieResponseFromJson(Map<String, dynamic> json) =>
    MovieResponse(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      cover: json['cover'] as String?,
      levelName: json['level_name'] as String?,
      startDate: json['start_date'] as String?,
    );

Map<String, dynamic> _$MovieResponseToJson(MovieResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cover': instance.cover,
      'level_name': instance.levelName,
      'start_date': instance.startDate,
    };
