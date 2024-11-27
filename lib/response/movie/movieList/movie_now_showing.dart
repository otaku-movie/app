import 'package:json_annotation/json_annotation.dart';
import 'package:otaku_movie/response/hello_movie.dart';
import 'package:otaku_movie/response/movie/movieList/movie.dart';

part 'movie_now_showing.g.dart';

@JsonSerializable()
class MovieNowShowingResponse extends MovieResponse {
  @JsonKey(name: "cast")
  final List<Cast>? cast;
  
  @JsonKey(name: "hello_movie")
  final List<HelloMovie>? helloMovie;

  MovieNowShowingResponse({
    super.id,
    super.name,
    super.cover,
    this.cast,
    this.helloMovie,
    super.startDate,
  });

  factory MovieNowShowingResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieNowShowingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieNowShowingResponseToJson(this);
}

@JsonSerializable()
class Cast {
  @JsonKey(name: "id")
  final int? id;

  @JsonKey(name: "name")
  final String? name;

  Cast({
    this.id,
    this.name,
  });

  factory Cast.fromJson(Map<String, dynamic> json) => _$CastFromJson(json);

  Map<String, dynamic> toJson() => _$CastToJson(this);
}
