import 'package:json_annotation/json_annotation.dart';

part 'ticket_detail_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class TicketDetailResponse {
  final int? id;
  final double? orderTotal;
  final int? orderState;
  final String? payMethod;
  final String? payNumber;
  final int? payState;
  final double? payTotal;
  final String? orderTime;
  final String? payTime;
  final String? date;
  final String? startTime;
  final String? endTime;
  final int? movieId;
  final String? movieName;
  final String? originalName;
  final String? moviePoster;
  final int? cinemaId;
  final String? cinemaName;
  final String? cinemaFullAddress;
  final String? cinemaTel;
  final int? theaterHallId;
  final String? theaterHallName;
  final String? specName;
  final List<SeatInfo>? seat;

  TicketDetailResponse({
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
    this.movieId,
    this.movieName,
    this.originalName,
    this.moviePoster,
    this.cinemaId,
    this.cinemaName,
    this.cinemaFullAddress,
    this.cinemaTel,
    this.theaterHallId,
    this.theaterHallName,
    this.specName,
    this.seat,
  });

  factory TicketDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$TicketDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TicketDetailResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class SeatInfo {
  final int? movieOrderId;
  final String? seatName;
  final String? movieTicketTypeName;
  final String? areaName;
  final num? areaPrice;

  SeatInfo({
    this.movieOrderId,
    this.seatName,
    this.movieTicketTypeName,
    this.areaName,
    this.areaPrice,
  });

  factory SeatInfo.fromJson(Map<String, dynamic> json) =>
      _$SeatInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SeatInfoToJson(this);
}

