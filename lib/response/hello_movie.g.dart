// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hello_movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelloMovieResponse _$HelloMovieResponseFromJson(Map<String, dynamic> json) =>
    HelloMovieResponse(
      id: (json['id'] as num?)?.toInt(),
      code: (json['code'] as num?)?.toInt(),
      date: json['date'] as String?,
    );

Map<String, dynamic> _$HelloMovieResponseToJson(HelloMovieResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'date': instance.date,
    };
