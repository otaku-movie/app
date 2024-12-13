import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'cinema_movie_showing_response.g.dart';

@JsonSerializable()
class CinemaMovieShowingResponse {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "name")
    final String? name;
    @JsonKey(name: "poster")
    final String? poster;
    @JsonKey(name: "time")
    final int? time;
    @JsonKey(name: "levelName")
    final String? levelName;

    CinemaMovieShowingResponse({
        this.id,
        this.name,
        this.poster,
        this.time,
        this.levelName,
    });

    factory CinemaMovieShowingResponse.fromJson(Map<String, dynamic> json) => _$CinemaMovieShowingResponseFromJson(json);

    Map<String, dynamic> toJson() => _$CinemaMovieShowingResponseToJson(this);
}
