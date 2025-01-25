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
      cinemaAddress: json['cinemaAddress'] as String?,
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
      'cinemaAddress': instance.cinemaAddress,
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
    };
