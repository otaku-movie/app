// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_now_showing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieNowShowingResponse _$MovieNowShowingResponseFromJson(
        Map<String, dynamic> json) =>
    MovieNowShowingResponse(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      cover: json['cover'] as String?,
      cast: (json['cast'] as List<dynamic>?)
          ?.map((e) => Cast.fromJson(e as Map<String, dynamic>))
          .toList(),
      helloMovie: (json['helloMovie'] as List<dynamic>?)
          ?.map((e) => HelloMovieResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      levelName: json['levelName'] as String?,
      startDate: json['startDate'] as String?,
    );

Map<String, dynamic> _$MovieNowShowingResponseToJson(
        MovieNowShowingResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cover': instance.cover,
      'name': instance.name,
      'startDate': instance.startDate,
      'levelName': instance.levelName,
      'cast': instance.cast?.map((e) => e.toJson()).toList(),
      'helloMovie': instance.helloMovie?.map((e) => e.toJson()).toList(),
    };

Cast _$CastFromJson(Map<String, dynamic> json) => Cast(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$CastToJson(Cast instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
