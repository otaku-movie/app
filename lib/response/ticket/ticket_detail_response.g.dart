// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketDetailResponse _$TicketDetailResponseFromJson(
        Map<String, dynamic> json) =>
    TicketDetailResponse(
      id: (json['id'] as num?)?.toInt(),
      orderTotal: (json['orderTotal'] as num?)?.toDouble(),
      orderState: (json['orderState'] as num?)?.toInt(),
      payMethod: json['payMethod'] as String?,
      payNumber: json['payNumber'] as String?,
      payState: (json['payState'] as num?)?.toInt(),
      payTotal: (json['payTotal'] as num?)?.toDouble(),
      orderTime: json['orderTime'] as String?,
      payTime: json['payTime'] as String?,
      date: json['date'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      movieId: (json['movieId'] as num?)?.toInt(),
      movieName: json['movieName'] as String?,
      originalName: json['originalName'] as String?,
      moviePoster: json['moviePoster'] as String?,
      cinemaId: (json['cinemaId'] as num?)?.toInt(),
      cinemaName: json['cinemaName'] as String?,
      cinemaFullAddress: json['cinemaFullAddress'] as String?,
      cinemaTel: json['cinemaTel'] as String?,
      theaterHallId: (json['theaterHallId'] as num?)?.toInt(),
      theaterHallName: json['theaterHallName'] as String?,
      specName: json['specName'] as String?,
      seat: (json['seat'] as List<dynamic>?)
          ?.map((e) => SeatInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TicketDetailResponseToJson(
        TicketDetailResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderTotal': instance.orderTotal,
      'orderState': instance.orderState,
      'payMethod': instance.payMethod,
      'payNumber': instance.payNumber,
      'payState': instance.payState,
      'payTotal': instance.payTotal,
      'orderTime': instance.orderTime,
      'payTime': instance.payTime,
      'date': instance.date,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'movieId': instance.movieId,
      'movieName': instance.movieName,
      'originalName': instance.originalName,
      'moviePoster': instance.moviePoster,
      'cinemaId': instance.cinemaId,
      'cinemaName': instance.cinemaName,
      'cinemaFullAddress': instance.cinemaFullAddress,
      'cinemaTel': instance.cinemaTel,
      'theaterHallId': instance.theaterHallId,
      'theaterHallName': instance.theaterHallName,
      'specName': instance.specName,
      'seat': instance.seat?.map((e) => e.toJson()).toList(),
    };

SeatInfo _$SeatInfoFromJson(Map<String, dynamic> json) => SeatInfo(
      movieOrderId: (json['movieOrderId'] as num?)?.toInt(),
      seatName: json['seatName'] as String?,
      movieTicketTypeName: json['movieTicketTypeName'] as String?,
      areaName: json['areaName'] as String?,
      areaPrice: json['areaPrice'] as num?,
    );

Map<String, dynamic> _$SeatInfoToJson(SeatInfo instance) => <String, dynamic>{
      'movieOrderId': instance.movieOrderId,
      'seatName': instance.seatName,
      'movieTicketTypeName': instance.movieTicketTypeName,
      'areaName': instance.areaName,
      'areaPrice': instance.areaPrice,
    };
