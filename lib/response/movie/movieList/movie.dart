import 'package:json_annotation/json_annotation.dart';
import 'package:otaku_movie/response/hello_movie.dart';

part 'movie.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class MovieResponse {
  final int? id;
  final String? cover;
  final String? name;
  final String? originalName;
  final String? description;
  final String? homePage;
  final String? startDate;
  final String? endDate;
  final int? status;
  final int? time;
  final int? cinemaCount;
  final int? theaterCount;
  final int? commentCount;
  final int? watchedCount;
  final int? wantToSeeCount;
  final List<Spec>? spec;
  final List<HelloMovieResponse>? helloMovie;
  final List<Tag>? tags;
  final int? levelId;
  final String? levelName;
  final String? levelDescription;

  MovieResponse({
    this.id,
    this.cover,
    this.name,
    this.originalName,
    this.description,
    this.homePage,
    this.startDate,
    this.endDate,
    this.status,
    this.time,
    this.cinemaCount,
    this.theaterCount,
    this.commentCount,
    this.watchedCount,
    this.wantToSeeCount,
    this.spec,
    this.helloMovie,
    this.tags,
    this.levelId,
    this.levelName,
    this.levelDescription,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieResponseToJson(this);
}

@JsonSerializable()
class Spec {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "name")
    final String? name;
    @JsonKey(name: "description")
    final String? description;

    Spec({
        this.id,
        this.name,
        this.description,
    });

    factory Spec.fromJson(Map<String, dynamic> json) => _$SpecFromJson(json);

    Map<String, dynamic> toJson() => _$SpecToJson(this);
}

@JsonSerializable()
class Tag {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "name")
    final String? name;

    Tag({
        this.id,
        this.name,
    });

    factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

    Map<String, dynamic> toJson() => _$TagToJson(this);
}
