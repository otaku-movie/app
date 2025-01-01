import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'user_select_seat_data_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class UserSelectSeatDataResponse {
  
  final int? movieShowTimeId;
  
  final int? movieId;
  
  final String? movieName;
  
  final String? moviePoster;
  
  final String? date;
  
  final String? startTime;
  
  final String? endTime;
  
  final String? specName;
  
  final int? cinemaId;
  
  final String? cinemaName;
  
  final int? theaterHallId;
  
  final String? theaterHallName;
  
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

@JsonSerializable(fieldRename: FieldRename.none)
class Seat {
  
  final int? x;
  
  final int? y;
  
  final int? seatId;
  
  final String? seatName;
  
  final int? areaPrice;
  
  final String? areaName;
  
  int? movieTicketTypeId;
  
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
