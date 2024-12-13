// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cinema_movie_showing_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CinemaMovieShowingResponse _$CinemaMovieShowingResponseFromJson(
        Map<String, dynamic> json) =>
    CinemaMovieShowingResponse(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      poster: json['poster'] as String?,
      time: (json['time'] as num?)?.toInt(),
      levelName: json['levelName'] as String?,
    );

Map<String, dynamic> _$CinemaMovieShowingResponseToJson(
        CinemaMovieShowingResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'poster': instance.poster,
      'time': instance.time,
      'levelName': instance.levelName,
    };
