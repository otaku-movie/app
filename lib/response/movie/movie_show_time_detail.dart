import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'movie_show_time_detail.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieShowTimeDetailResponse {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "date")
  final String? date;
  @JsonKey(name: "startTime")
  final String? startTime;
  @JsonKey(name: "endTime")
  final String? endTime;
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "movieId")
  final int? movieId;
  @JsonKey(name: "movieName")
  final String? movieName;
  @JsonKey(name: "cinemaId")
  final int? cinemaId;
  @JsonKey(name: "cinemaName")
  final String? cinemaName;
  @JsonKey(name: "theaterHallId")
  final int? theaterHallId;
  @JsonKey(name: "theaterHallName")
  final String? theaterHallName;

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
  });

  factory MovieShowTimeDetailResponse.fromJson(Map<String, dynamic> json) => _$MovieShowTimeDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieShowTimeDetailResponseToJson(this);
}
