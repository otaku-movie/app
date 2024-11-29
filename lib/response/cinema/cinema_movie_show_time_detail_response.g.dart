// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cinema_movie_show_time_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CinemaMovieShowTimeDetailResponse _$CinemaMovieShowTimeDetailResponseFromJson(
        Map<String, dynamic> json) =>
    CinemaMovieShowTimeDetailResponse(
      cinemaId: (json['cinema_id'] as num?)?.toInt(),
      cinemaName: json['cinema_name'] as String?,
      cinemaAddress: json['cinema_address'] as String?,
      cinemaTel: json['cinema_tel'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CinemaMovieShowTimeDetailResponseDatum.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CinemaMovieShowTimeDetailResponseToJson(
        CinemaMovieShowTimeDetailResponse instance) =>
    <String, dynamic>{
      'cinema_id': instance.cinemaId,
      'cinema_name': instance.cinemaName,
      'cinema_address': instance.cinemaAddress,
      'cinema_tel': instance.cinemaTel,
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
      theaterHallId: (json['theater_hall_id'] as num?)?.toInt(),
      theaterHallName: json['theater_hall_name'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
    );

Map<String, dynamic> _$TheaterHallShowTimeToJson(
        TheaterHallShowTime instance) =>
    <String, dynamic>{
      'id': instance.id,
      'theater_hall_id': instance.theaterHallId,
      'theater_hall_name': instance.theaterHallName,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
    };
