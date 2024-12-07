import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'order_detail_response.g.dart';

@JsonSerializable()
class OrderDetailResponse {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "order_total")
    final int? orderTotal;
    @JsonKey(name: "order_state")
    final int? orderState;
    @JsonKey(name: "pay_method")
    final String? payMethod;
    @JsonKey(name: "pay_number")
    final int? payNumber;
    @JsonKey(name: "pay_state")
    final int? payState;
    @JsonKey(name: "pay_total")
    final int? payTotal;
    @JsonKey(name: "order_time")
    final String? orderTime;
    @JsonKey(name: "pay_time")
    final String? payTime;
    @JsonKey(name: "date")
    final String? date;
    @JsonKey(name: "start_time")
    final String? startTime;
    @JsonKey(name: "end_time")
    final String? endTime;
    @JsonKey(name: "status")
    final int? status;
    @JsonKey(name: "movie_id")
    final int? movieId;
    @JsonKey(name: "movie_name")
    final String? movieName;
    @JsonKey(name: "movie_poster")
    final String? moviePoster;
    @JsonKey(name: "cinema_id")
    final dynamic cinemaId;
    @JsonKey(name: "cinema_name")
    final String? cinemaName;
    @JsonKey(name: "theater_hall_name")
    final String? theaterHallName;
    @JsonKey(name: "theater_hall_spec_name")
    final String? theaterHallSpecName;
    @JsonKey(name: "seat")
    final List<Seat>? seat;

    OrderDetailResponse({
        this.id,
        this.orderTotal,
        this.orderState,
        this.payMethod,
        this.payNumber,
        this.payState,
        this.payTotal,
        this.orderTime,
        this.payTime,
        this.date,
        this.startTime,
        this.endTime,
        this.status,
        this.movieId,
        this.movieName,
        this.moviePoster,
        this.cinemaId,
        this.cinemaName,
        this.theaterHallName,
        this.theaterHallSpecName,
        this.seat,
    });

    factory OrderDetailResponse.fromJson(Map<String, dynamic> json) => _$OrderDetailResponseFromJson(json);

    Map<String, dynamic> toJson() => _$OrderDetailResponseToJson(this);
}

@JsonSerializable()
class Seat {
    @JsonKey(name: "seat_x")
    final int? seatX;
    @JsonKey(name: "seat_y")
    final int? seatY;
    @JsonKey(name: "seat_name")
    final String? seatName;
    @JsonKey(name: "movie_ticket_type_name")
    final String? movieTicketTypeName;

    Seat({
        this.seatX,
        this.seatY,
        this.seatName,
        this.movieTicketTypeName,
    });

    factory Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);

    Map<String, dynamic> toJson() => _$SeatToJson(this);
}
