// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieVersionResponse _$MovieVersionResponseFromJson(
        Map<String, dynamic> json) =>
    MovieVersionResponse(
      id: (json['id'] as num?)?.toInt(),
      movieId: (json['movieId'] as num?)?.toInt(),
      versionCode: (json['versionCode'] as num?)?.toInt(),
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      languageId: (json['languageId'] as num?)?.toInt(),
      characters: (json['characters'] as List<dynamic>?)
          ?.map((e) => CharacterResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieVersionResponseToJson(
        MovieVersionResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'movieId': instance.movieId,
      'versionCode': instance.versionCode,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'languageId': instance.languageId,
      'characters': instance.characters?.map((e) => e.toJson()).toList(),
    };
