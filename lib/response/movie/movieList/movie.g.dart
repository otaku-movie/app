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
      originalName: json['original_name'] as String?,
      description: json['description'] as String?,
      homePage: json['home_page'] as String?,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      status: (json['status'] as num?)?.toInt(),
      time: (json['time'] as num?)?.toInt(),
      cinemaCount: (json['cinema_count'] as num?)?.toInt(),
      theaterCount: (json['theater_count'] as num?)?.toInt(),
      commentCount: (json['comment_count'] as num?)?.toInt(),
      watchedCount: (json['watched_count'] as num?)?.toInt(),
      wantToSeeCount: (json['want_to_see_count'] as num?)?.toInt(),
      spec: (json['spec'] as List<dynamic>?)
          ?.map((e) => Spec.fromJson(e as Map<String, dynamic>))
          .toList(),
      helloMovie: json['hello_movie'] as List<dynamic>?,
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      levelId: (json['level_id'] as num?)?.toInt(),
      levelName: json['level_name'] as String?,
      levelDescription: json['level_description'] as String?,
    );

Map<String, dynamic> _$MovieResponseToJson(MovieResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cover': instance.cover,
      'name': instance.name,
      'original_name': instance.originalName,
      'description': instance.description,
      'home_page': instance.homePage,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'status': instance.status,
      'time': instance.time,
      'cinema_count': instance.cinemaCount,
      'theater_count': instance.theaterCount,
      'comment_count': instance.commentCount,
      'watched_count': instance.watchedCount,
      'want_to_see_count': instance.wantToSeeCount,
      'spec': instance.spec?.map((e) => e.toJson()).toList(),
      'hello_movie': instance.helloMovie,
      'tags': instance.tags?.map((e) => e.toJson()).toList(),
      'level_id': instance.levelId,
      'level_name': instance.levelName,
      'level_description': instance.levelDescription,
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
