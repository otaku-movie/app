import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'order_detail_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class OrderDetailResponse {
    
    final int? id;
    
    final int? orderTotal;
    
    final int? orderState;
    
    final String? payMethod;
    
    final int? payNumber;
    
    final int? payState;
    
    final int? payTotal;
    
    final String? orderTime;
    
    final String? payTime;
    
    final String? date;
    
    final String? startTime;
    
    final String? endTime;
    
    final int? status;
    
    final int? movieId;
    
    final String? movieName;
    
    final String? moviePoster;
    
    final dynamic cinemaId;
    
    final String? cinemaName;
    
    final String? theaterHallName;
    
    final String? theaterHallSpecName;
    
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

@JsonSerializable(fieldRename: FieldRename.none)
class Seat {
    
    final int? seatX;
    
    final int? seatY;
    
    final String? seatName;
    
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
