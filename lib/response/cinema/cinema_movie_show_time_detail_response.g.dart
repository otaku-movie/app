// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cinema_movie_show_time_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CinemaMovieShowTimeDetailResponse _$CinemaMovieShowTimeDetailResponseFromJson(
        Map<String, dynamic> json) =>
    CinemaMovieShowTimeDetailResponse(
      cinemaId: (json['cinemaId'] as num?)?.toInt(),
      cinemaName: json['cinemaName'] as String?,
      cinemaFullAddress: json['cinemaFullAddress'] as String?,
      cinemaTel: json['cinemaTel'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CinemaMovieShowTimeDetailResponseDatum.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CinemaMovieShowTimeDetailResponseToJson(
        CinemaMovieShowTimeDetailResponse instance) =>
    <String, dynamic>{
      'cinemaId': instance.cinemaId,
      'cinemaName': instance.cinemaName,
      'cinemaFullAddress': instance.cinemaFullAddress,
      'cinemaTel': instance.cinemaTel,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

CinemaMovieShowTimeDetailResponseDatum
    _$CinemaMovieShowTimeDetailResponseDatumFromJson(
            Map<String, dynamic> json) =>
        CinemaMovieShowTimeDetailResponseDatum(
          date: json['date'] as String?,
          data: (json['data'] as List<dynamic>?)
              ?.map((e) =>
                  TheaterHallShowTime.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$CinemaMovieShowTimeDetailResponseDatumToJson(
        CinemaMovieShowTimeDetailResponseDatum instance) =>
    <String, dynamic>{
      'date': instance.date,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

TheaterHallShowTime _$TheaterHallShowTimeFromJson(Map<String, dynamic> json) =>
    TheaterHallShowTime(
      id: (json['id'] as num?)?.toInt(),
      theaterHallId: (json['theaterHallId'] as num?)?.toInt(),
      theaterHallName: json['theaterHallName'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      specName: json['specName'] as String?,
      movieShowTimeTags: (json['movieShowTimeTags'] as List<dynamic>?)
          ?.map((e) => ShowTimeTag.fromJson(e as Map<String, dynamic>))
          .toList(),
      showTimeTags: (json['showTimeTags'] as List<dynamic>?)
          ?.map((e) => ShowTimeTag.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtitle: (json['subtitle'] as List<dynamic>?)
          ?.map((e) => ShowTimeSubtitle.fromJson(e as Map<String, dynamic>))
          .toList(),
      seatStatus: (json['seatStatus'] as num?)?.toInt(),
      availableSeats: (json['availableSeats'] as num?)?.toInt(),
      totalSeats: (json['totalSeats'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TheaterHallShowTimeToJson(
        TheaterHallShowTime instance) =>
    <String, dynamic>{
      'id': instance.id,
      'theaterHallId': instance.theaterHallId,
      'theaterHallName': instance.theaterHallName,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'specName': instance.specName,
      'movieShowTimeTags':
          instance.movieShowTimeTags?.map((e) => e.toJson()).toList(),
      'showTimeTags': instance.showTimeTags?.map((e) => e.toJson()).toList(),
      'subtitle': instance.subtitle?.map((e) => e.toJson()).toList(),
      'seatStatus': instance.seatStatus,
      'availableSeats': instance.availableSeats,
      'totalSeats': instance.totalSeats,
    };

ShowTimeTag _$ShowTimeTagFromJson(Map<String, dynamic> json) => ShowTimeTag(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$ShowTimeTagToJson(ShowTimeTag instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

ShowTimeSubtitle _$ShowTimeSubtitleFromJson(Map<String, dynamic> json) =>
    ShowTimeSubtitle(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      code: json['code'] as String?,
    );

Map<String, dynamic> _$ShowTimeSubtitleToJson(ShowTimeSubtitle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
    };
