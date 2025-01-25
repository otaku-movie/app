import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'movie_show_time_detail.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class MovieShowTimeDetailResponse {
  
  final int? id;
  
  final String? date;
  
  final String? startTime;
  
  final String? endTime;
  
  final int? status;
  
  final int? movieId;
  
  final String? movieName;
  
  final int? cinemaId;
  
  final String? cinemaName;
  
  final int? theaterHallId;
  
  final String? theaterHallName;

   final String? specName;

  MovieShowTimeDetailResponse({
    this.id,
    this.date,
    this.startTime,
    this.endTime,
    this.status,
    this.movieId,
    this.movieName,
    this.cinemaId,
    this.cinemaName,
    this.theaterHallId,
    this.theaterHallName,
    this.specName
  });

  factory MovieShowTimeDetailResponse.fromJson(Map<String, dynamic> json) => _$MovieShowTimeDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieShowTimeDetailResponseToJson(this);
}
