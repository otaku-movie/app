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
      dimensionType: (json['dimensionType'] as num?)?.toInt(),
      cinemaId: (json['cinemaId'] as num?)?.toInt(),
      cinemaName: json['cinemaName'] as String?,
      theaterHallId: (json['theaterHallId'] as num?)?.toInt(),
      theaterHallName: json['theaterHallName'] as String?,
      specPriceList: (json['specPriceList'] as List<dynamic>?)
          ?.map((e) => SpecPrice.fromJson(e as Map<String, dynamic>))
          .toList(),
      displayTypeName: json['displayTypeName'] as String?,
      displayTypeSurcharge: (json['displayTypeSurcharge'] as num?)?.toInt(),
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
      'dimensionType': instance.dimensionType,
      'cinemaId': instance.cinemaId,
      'cinemaName': instance.cinemaName,
      'theaterHallId': instance.theaterHallId,
      'theaterHallName': instance.theaterHallName,
      'specPriceList': instance.specPriceList?.map((e) => e.toJson()).toList(),
      'displayTypeName': instance.displayTypeName,
      'displayTypeSurcharge': instance.displayTypeSurcharge,
      'seat': instance.seat?.map((e) => e.toJson()).toList(),
    };

Seat _$SeatFromJson(Map<String, dynamic> json) => Seat(
      x: (json['x'] as num?)?.toInt(),
      y: (json['y'] as num?)?.toInt(),
      seatId: (json['seatId'] as num?)?.toInt(),
      seatName: json['seatName'] as String?,
      areaPrice: (json['areaPrice'] as num?)?.toInt(),
      areaName: json['areaName'] as String?,
      movieTicketTypeId: (json['movieTicketTypeId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SeatToJson(Seat instance) => <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'seatId': instance.seatId,
      'seatName': instance.seatName,
      'areaPrice': instance.areaPrice,
      'areaName': instance.areaName,
      'movieTicketTypeId': instance.movieTicketTypeId,
    };

SpecPrice _$SpecPriceFromJson(Map<String, dynamic> json) => SpecPrice(
      name: json['name'] as String?,
      plusPrice: (json['plusPrice'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SpecPriceToJson(SpecPrice instance) =>
    <String, dynamic>{
      'name': instance.name,
      'plusPrice': instance.plusPrice,
    };
