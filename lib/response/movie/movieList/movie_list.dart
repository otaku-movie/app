import 'package:json_annotation/json_annotation.dart';
import 'package:otaku_movie/response/hello_movie.dart';

part 'movie_list.g.dart';

@JsonSerializable()
class MovieListResponse {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "name")
    final String? name;
    @JsonKey(name: "cover")
    final String? cover;
    @JsonKey(name: "spec")
    final List<Cast>? spec;
    @JsonKey(name: "level_name")
    final String? levelName;
    @JsonKey(name: "cast")
    final List<Cast>? cast;
    @JsonKey(name: "hello_movie")
    final List<HelloMovie>? helloMovie;
    @JsonKey(name: "start_date")
    final DateTime? startDate;

    MovieListResponse({
        this.id,
        this.name,
        this.cover,
        this.spec,
        this.levelName,
        this.cast,
        this.helloMovie,
        this.startDate,
    });

    factory MovieListResponse.fromJson(Map<String, dynamic> json) => _$MovieListResponseFromJson(json);

    Map<String, dynamic> toJson() => _$MovieListResponseToJson(this);
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

