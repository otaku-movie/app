import 'package:json_annotation/json_annotation.dart';
import 'package:otaku_movie/response/hello_movie.dart';
import 'package:otaku_movie/response/movie/movieList/movie.dart';

part 'movie_now_showing.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class MovieNowShowingResponse extends MovieResponse {
  
  final List<Cast>? cast;
  
  final List<HelloMovieResponse>? helloMovie;

  MovieNowShowingResponse({
    super.id,
    super.name,
    super.cover,
    this.cast,
    this.helloMovie,
    super.levelName,
    super.startDate,
  });

  factory MovieNowShowingResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieNowShowingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieNowShowingResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class Cast {
  
  final int? id;

  
  final String? name;

  Cast({
    this.id,
    this.name,
  });

  factory Cast.fromJson(Map<String, dynamic> json) => _$CastFromJson(json);

  Map<String, dynamic> toJson() => _$CastToJson(this);
}
