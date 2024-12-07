// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailResponse _$OrderDetailResponseFromJson(Map<String, dynamic> json) =>
    OrderDetailResponse(
      id: (json['id'] as num?)?.toInt(),
      orderTotal: (json['order_total'] as num?)?.toInt(),
      orderState: (json['order_state'] as num?)?.toInt(),
      payMethod: json['pay_method'] as String?,
      payNumber: (json['pay_number'] as num?)?.toInt(),
      payState: (json['pay_state'] as num?)?.toInt(),
      payTotal: (json['pay_total'] as num?)?.toInt(),
      orderTime: json['order_time'] as String?,
      payTime: json['pay_time'] as String?,
      date: json['date'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      status: (json['status'] as num?)?.toInt(),
      movieId: (json['movie_id'] as num?)?.toInt(),
      movieName: json['movie_name'] as String?,
      moviePoster: json['movie_poster'] as String?,
      cinemaId: json['cinema_id'],
      cinemaName: json['cinema_name'] as String?,
      theaterHallName: json['theater_hall_name'] as String?,
      theaterHallSpecName: json['theater_hall_spec_name'] as String?,
      seat: (json['seat'] as List<dynamic>?)
          ?.map((e) => Seat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderDetailResponseToJson(
        OrderDetailResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_total': instance.orderTotal,
      'order_state': instance.orderState,
      'pay_method': instance.payMethod,
      'pay_number': instance.payNumber,
      'pay_state': instance.payState,
      'pay_total': instance.payTotal,
      'order_time': instance.orderTime,
      'pay_time': instance.payTime,
      'date': instance.date,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'status': instance.status,
      'movie_id': instance.movieId,
      'movie_name': instance.movieName,
      'movie_poster': instance.moviePoster,
      'cinema_id': instance.cinemaId,
      'cinema_name': instance.cinemaName,
      'theater_hall_name': instance.theaterHallName,
      'theater_hall_spec_name': instance.theaterHallSpecName,
      'seat': instance.seat?.map((e) => e.toJson()).toList(),
    };

Seat _$SeatFromJson(Map<String, dynamic> json) => Seat(
      seatX: (json['seat_x'] as num?)?.toInt(),
      seatY: (json['seat_y'] as num?)?.toInt(),
      seatName: json['seat_name'] as String?,
      movieTicketTypeName: json['movie_ticket_type_name'] as String?,
    );

Map<String, dynamic> _$SeatToJson(Seat instance) => <String, dynamic>{
      'seat_x': instance.seatX,
      'seat_y': instance.seatY,
      'seat_name': instance.seatName,
      'movie_ticket_type_name': instance.movieTicketTypeName,
    };
