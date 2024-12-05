// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_select_seat_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSelectSeatDataResponse _$UserSelectSeatDataResponseFromJson(
        Map<String, dynamic> json) =>
    UserSelectSeatDataResponse(
      movieShowTimeId: (json['movieShowTimeId'] as num?)?.toInt(),
      movieId: (json['movieId'] as num?)?.toInt(),
      movieName: json['movieName'] as String?,
      moviePoster: json['moviePoster'] as String?,
      date: json['date'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      specName: json['specName'] as String?,
      cinemaId: (json['cinemaId'] as num?)?.toInt(),
      cinemaName: json['cinemaName'] as String?,
      theaterHallId: (json['theaterHallId'] as num?)?.toInt(),
      theaterHallName: json['theaterHallName'] as String?,
      seat: (json['seat'] as List<dynamic>?)
          ?.map((e) => Seat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserSelectSeatDataResponseToJson(
        UserSelectSeatDataResponse instance) =>
    <String, dynamic>{
      'movieShowTimeId': instance.movieShowTimeId,
      'movieId': instance.movieId,
      'movieName': instance.movieName,
      'moviePoster': instance.moviePoster,
      'date': instance.date,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'specName': instance.specName,
      'cinemaId': instance.cinemaId,
      'cinemaName': instance.cinemaName,
      'theaterHallId': instance.theaterHallId,
      'theaterHallName': instance.theaterHallName,
      'seat': instance.seat?.map((e) => e.toJson()).toList(),
    };

Seat _$SeatFromJson(Map<String, dynamic> json) => Seat(
      x: (json['x'] as num?)?.toInt(),
      y: (json['y'] as num?)?.toInt(),
      seatName: json['seatName'] as String?,
      areaPrice: (json['areaPrice'] as num?)?.toInt(),
      areaName: json['areaName'] as String?,
      movieTicketTypeId: (json['movieTicketTypeId'] as num?)?.toInt(),
      plusPrice: (json['plusPrice'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SeatToJson(Seat instance) => <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'seatName': instance.seatName,
      'areaPrice': instance.areaPrice,
      'areaName': instance.areaName,
      'movieTicketTypeId': instance.movieTicketTypeId,
      'plusPrice': instance.plusPrice,
    };
