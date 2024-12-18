// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieResponse _$MovieResponseFromJson(Map<String, dynamic> json) =>
    MovieResponse(
      id: (json['id'] as num?)?.toInt(),
      cover: json['cover'] as String?,
      name: json['name'] as String?,
      originalName: json['originalName'] as String?,
      description: json['description'] as String?,
      homePage: json['homePage'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      status: (json['status'] as num?)?.toInt(),
      time: (json['time'] as num?)?.toInt(),
      cinemaCount: (json['cinemaCount'] as num?)?.toInt(),
      theaterCount: (json['theaterCount'] as num?)?.toInt(),
      commentCount: (json['commentCount'] as num?)?.toInt(),
      watchedCount: (json['watchedCount'] as num?)?.toInt(),
      wantToSeeCount: (json['wantToSeeCount'] as num?)?.toInt(),
      spec: (json['spec'] as List<dynamic>?)
          ?.map((e) => Spec.fromJson(e as Map<String, dynamic>))
          .toList(),
      helloMovie: (json['helloMovie'] as List<dynamic>?)
          ?.map((e) => HelloMovieResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      levelId: (json['levelId'] as num?)?.toInt(),
      levelName: json['levelName'] as String?,
      levelDescription: json['levelDescription'] as String?,
    );

Map<String, dynamic> _$MovieResponseToJson(MovieResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cover': instance.cover,
      'name': instance.name,
      'originalName': instance.originalName,
      'description': instance.description,
      'homePage': instance.homePage,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'status': instance.status,
      'time': instance.time,
      'cinemaCount': instance.cinemaCount,
      'theaterCount': instance.theaterCount,
      'commentCount': instance.commentCount,
      'watchedCount': instance.watchedCount,
      'wantToSeeCount': instance.wantToSeeCount,
      'spec': instance.spec?.map((e) => e.toJson()).toList(),
      'helloMovie': instance.helloMovie?.map((e) => e.toJson()).toList(),
      'tags': instance.tags?.map((e) => e.toJson()).toList(),
      'levelId': instance.levelId,
      'levelName': instance.levelName,
      'levelDescription': instance.levelDescription,
    };

Spec _$SpecFromJson(Map<String, dynamic> json) => Spec(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$SpecToJson(Spec instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
