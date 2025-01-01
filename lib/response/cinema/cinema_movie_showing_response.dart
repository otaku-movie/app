import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'cinema_movie_showing_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class CinemaMovieShowingResponse {
    
    final int? id;
    
    final String? name;
    
    final String? poster;
    
    final int? time;
    
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
