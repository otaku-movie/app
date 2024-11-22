// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hello_movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelloMovie _$HelloMovieFromJson(Map<String, dynamic> json) => HelloMovie(
      id: (json['id'] as num?)?.toInt(),
      code: (json['code'] as num?)?.toInt(),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$HelloMovieToJson(HelloMovie instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'date': instance.date?.toIso8601String(),
    };
