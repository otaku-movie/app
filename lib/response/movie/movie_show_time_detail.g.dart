// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_show_time_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieShowTimeDetailResponse _$MovieShowTimeDetailResponseFromJson(
        Map<String, dynamic> json) =>
    MovieShowTimeDetailResponse(
      id: (json['id'] as num?)?.toInt(),
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      status: (json['status'] as num?)?.toInt(),
      movieId: (json['movieId'] as num?)?.toInt(),
      movieName: json['movieName'] as String?,
      moviePoster: json['moviePoster'],
      cinemaId: (json['cinemaId'] as num?)?.toInt(),
      cinemaName: json['cinemaName'] as String?,
      theaterHallId: (json['theaterHallId'] as num?)?.toInt(),
      theaterHallName: json['theaterHallName'] as String?,
      selectedSeatCount: (json['selectedSeatCount'] as num?)?.toInt(),
      subtitleId: (json['subtitleId'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      movieShowTimeTagsId: (json['movieShowTimeTagsId'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      subtitle: (json['subtitle'] as List<dynamic>?)
          ?.map((e) => Subtitle.fromJson(e as Map<String, dynamic>))
          .toList(),
      movieShowTimeTags: (json['movieShowTimeTags'] as List<dynamic>?)
          ?.map((e) => MovieShowTimeTag.fromJson(e as Map<String, dynamic>))
          .toList(),
      specId: (json['specId'] as num?)?.toInt(),
      specName: json['specName'] as String?,
      open: json['open'] as bool?,
      theaterHallSpec: json['theaterHallSpec'] as String?,
      seatCount: json['seatCount'],
    );

Map<String, dynamic> _$MovieShowTimeDetailResponseToJson(
        MovieShowTimeDetailResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'status': instance.status,
      'movieId': instance.movieId,
      'movieName': instance.movieName,
      'moviePoster': instance.moviePoster,
      'cinemaId': instance.cinemaId,
      'cinemaName': instance.cinemaName,
      'theaterHallId': instance.theaterHallId,
      'theaterHallName': instance.theaterHallName,
      'selectedSeatCount': instance.selectedSeatCount,
      'subtitleId': instance.subtitleId,
      'movieShowTimeTagsId': instance.movieShowTimeTagsId,
      'subtitle': instance.subtitle?.map((e) => e.toJson()).toList(),
      'movieShowTimeTags':
          instance.movieShowTimeTags?.map((e) => e.toJson()).toList(),
      'specId': instance.specId,
      'specName': instance.specName,
      'open': instance.open,
      'theaterHallSpec': instance.theaterHallSpec,
      'seatCount': instance.seatCount,
    };

MovieShowTimeTag _$MovieShowTimeTagFromJson(Map<String, dynamic> json) =>
    MovieShowTimeTag(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$MovieShowTimeTagToJson(MovieShowTimeTag instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

Subtitle _$SubtitleFromJson(Map<String, dynamic> json) => Subtitle(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      code: json['code'] as String?,
    );

Map<String, dynamic> _$SubtitleToJson(Subtitle instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
    };
