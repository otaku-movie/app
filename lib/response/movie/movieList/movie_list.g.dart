// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieListResponse _$MovieListResponseFromJson(Map<String, dynamic> json) =>
    MovieListResponse(
      id: (json['id'] as num?)?.toInt(),
      cover: json['cover'] as String?,
      name: json['name'] as String?,
      originalName: json['original_name'] as String?,
      description: json['description'] as String?,
      homePage: json['home_page'] as String?,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      status: (json['status'] as num?)?.toInt(),
      time: json['time'] as String?,
      cinemaCount: (json['cinema_count'] as num?)?.toInt(),
      theaterCount: (json['theater_count'] as num?)?.toInt(),
      commentCount: (json['comment_count'] as num?)?.toInt(),
      watchedCount: (json['watched_count'] as num?)?.toInt(),
      wantToSeeCount: (json['want_to_see_count'] as num?)?.toInt(),
      createTime: json['create_time'] as String?,
      updateTime: json['update_time'] as String?,
      spec: (json['spec'] as List<dynamic>?)
          ?.map((e) => Spec.fromJson(e as Map<String, dynamic>))
          .toList(),
      helloMovie: (json['hello_movie'] as List<dynamic>?)
          ?.map((e) => HelloMovie.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      levelId: (json['level_id'] as num?)?.toInt(),
      levelName: json['level_name'] as String?,
    );

Map<String, dynamic> _$MovieListResponseToJson(MovieListResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cover': instance.cover,
      'name': instance.name,
      'original_name': instance.originalName,
      'description': instance.description,
      'home_page': instance.homePage,
      'start_date': instance.startDate,
      'end_date': instance.endDate?.toIso8601String(),
      'status': instance.status,
      'time': instance.time,
      'cinema_count': instance.cinemaCount,
      'theater_count': instance.theaterCount,
      'comment_count': instance.commentCount,
      'watched_count': instance.watchedCount,
      'want_to_see_count': instance.wantToSeeCount,
      'create_time': instance.createTime,
      'update_time': instance.updateTime,
      'spec': instance.spec?.map((e) => e.toJson()).toList(),
      'hello_movie': instance.helloMovie?.map((e) => e.toJson()).toList(),
      'tags': instance.tags?.map((e) => e.toJson()).toList(),
      'level_id': instance.levelId,
      'level_name': instance.levelName,
    };

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
