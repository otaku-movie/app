// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_show_time_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieShowTimeDetailResponse _$MovieShowTimeDetailResponseFromJson(
        Map<String, dynamic> json) =>
    MovieShowTimeDetailResponse(
      id: (json['id'] as num?)?.toInt(),
      date: json['date'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      status: (json['status'] as num?)?.toInt(),
      movieId: (json['movieId'] as num?)?.toInt(),
      movieName: json['movieName'] as String?,
      cinemaId: (json['cinemaId'] as num?)?.toInt(),
      cinemaName: json['cinemaName'] as String?,
      theaterHallId: (json['theaterHallId'] as num?)?.toInt(),
      theaterHallName: json['theaterHallName'] as String?,
      specName: json['specName'] as String?,
    );

Map<String, dynamic> _$MovieShowTimeDetailResponseToJson(
        MovieShowTimeDetailResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'status': instance.status,
      'movieId': instance.movieId,
      'movieName': instance.movieName,
      'cinemaId': instance.cinemaId,
      'cinemaName': instance.cinemaName,
      'theaterHallId': instance.theaterHallId,
      'theaterHallName': instance.theaterHallName,
      'specName': instance.specName,
    };
