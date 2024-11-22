// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieListResponse _$MovieListResponseFromJson(Map<String, dynamic> json) =>
    MovieListResponse(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      cover: json['cover'] as String?,
      spec: (json['spec'] as List<dynamic>?)
          ?.map((e) => Cast.fromJson(e as Map<String, dynamic>))
          .toList(),
      levelName: json['level_name'] as String?,
      cast: (json['cast'] as List<dynamic>?)
          ?.map((e) => Cast.fromJson(e as Map<String, dynamic>))
          .toList(),
      helloMovie: (json['hello_movie'] as List<dynamic>?)
          ?.map((e) => HelloMovie.fromJson(e as Map<String, dynamic>))
          .toList(),
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
    );

Map<String, dynamic> _$MovieListResponseToJson(MovieListResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cover': instance.cover,
      'spec': instance.spec?.map((e) => e.toJson()).toList(),
      'level_name': instance.levelName,
      'cast': instance.cast?.map((e) => e.toJson()).toList(),
      'hello_movie': instance.helloMovie?.map((e) => e.toJson()).toList(),
      'start_date': instance.startDate?.toIso8601String(),
    };

Cast _$CastFromJson(Map<String, dynamic> json) => Cast(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$CastToJson(Cast instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
