// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailResponse _$OrderDetailResponseFromJson(Map<String, dynamic> json) =>
    OrderDetailResponse(
      id: (json['id'] as num?)?.toInt(),
      orderTotal: (json['orderTotal'] as num?)?.toInt(),
      orderState: (json['orderState'] as num?)?.toInt(),
      payMethod: json['payMethod'] as String?,
      payNumber: (json['payNumber'] as num?)?.toInt(),
      payState: (json['payState'] as num?)?.toInt(),
      payTotal: (json['payTotal'] as num?)?.toInt(),
      orderTime: json['orderTime'] as String?,
      payTime: json['payTime'] as String?,
      date: json['date'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      status: (json['status'] as num?)?.toInt(),
      movieId: (json['movieId'] as num?)?.toInt(),
      movieName: json['movieName'] as String?,
      moviePoster: json['moviePoster'] as String?,
      cinemaId: json['cinemaId'],
      cinemaName: json['cinemaName'] as String?,
      cinemaFullAddress: json['cinemaFullAddress'] as String?,
      theaterHallName: json['theaterHallName'] as String?,
      specName: json['specName'] as String?,
      seat: (json['seat'] as List<dynamic>?)
          ?.map((e) => Seat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderDetailResponseToJson(
        OrderDetailResponse instance) =>
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
      'status': instance.status,
      'movieId': instance.movieId,
      'movieName': instance.movieName,
      'moviePoster': instance.moviePoster,
      'cinemaId': instance.cinemaId,
      'cinemaName': instance.cinemaName,
      'cinemaFullAddress': instance.cinemaFullAddress,
      'theaterHallName': instance.theaterHallName,
      'specName': instance.specName,
      'seat': instance.seat?.map((e) => e.toJson()).toList(),
    };

Seat _$SeatFromJson(Map<String, dynamic> json) => Seat(
      seatX: (json['seatX'] as num?)?.toInt(),
      seatY: (json['seatY'] as num?)?.toInt(),
      seatName: json['seatName'] as String?,
      movieTicketTypeName: json['movieTicketTypeName'] as String?,
    );

Map<String, dynamic> _$SeatToJson(Seat instance) => <String, dynamic>{
      'seatX': instance.seatX,
      'seatY': instance.seatY,
      'seatName': instance.seatName,
      'movieTicketTypeName': instance.movieTicketTypeName,
    };
