import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'user_select_seat_data_response.g.dart';

@JsonSerializable()
class UserSelectSeatDataResponse {
  @JsonKey(name: "movieShowTimeId")
  final int? movieShowTimeId;
  @JsonKey(name: "movieId")
  final int? movieId;
  @JsonKey(name: "movieName")
  final String? movieName;
  @JsonKey(name: "moviePoster")
  final String? moviePoster;
  @JsonKey(name: "date")
  final String? date;
  @JsonKey(name: "startTime")
  final String? startTime;
  @JsonKey(name: "endTime")
  final String? endTime;
  @JsonKey(name: "specName")
  final String? specName;
  @JsonKey(name: "cinemaId")
  final int? cinemaId;
  @JsonKey(name: "cinemaName")
  final String? cinemaName;
  @JsonKey(name: "theaterHallId")
  final int? theaterHallId;
  @JsonKey(name: "theaterHallName")
  final String? theaterHallName;
  @JsonKey(name: "seat")
  final List<Seat>? seat;

  UserSelectSeatDataResponse({
    this.movieShowTimeId,
    this.movieId,
    this.movieName,
    this.moviePoster,
    this.date,
    this.startTime,
    this.endTime,
    this.specName,
    this.cinemaId,
    this.cinemaName,
    this.theaterHallId,
    this.theaterHallName,
    this.seat,
  });

  factory UserSelectSeatDataResponse.fromJson(Map<String, dynamic> json) => _$UserSelectSeatDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserSelectSeatDataResponseToJson(this);
}

@JsonSerializable()
class Seat {
  @JsonKey(name: "x")
  final int? x;
  @JsonKey(name: "y")
  final int? y;
  @JsonKey(name: "seatId")
  final int? seatId;
  @JsonKey(name: "seatName")
  final String? seatName;
  @JsonKey(name: "areaPrice")
  final int? areaPrice;
  @JsonKey(name: "areaName")
  final String? areaName;
  @JsonKey(name: "movieTicketTypeId")
  int? movieTicketTypeId;
  @JsonKey(name: "plusPrice")
  final int? plusPrice;

  Seat({
    this.x,
    this.y,
    this.seatId,
    this.seatName,
    this.areaPrice,
    this.areaName,
    this.movieTicketTypeId,
    this.plusPrice,
  });

  factory Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);

  Map<String, dynamic> toJson() => _$SeatToJson(this);
}
