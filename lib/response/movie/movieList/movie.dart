import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
class MovieResponse {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "cover")
    final String? cover;
    @JsonKey(name: "name")
    final String? name;
    @JsonKey(name: "original_name")
    final String? originalName;
    @JsonKey(name: "description")
    final String? description;
    @JsonKey(name: "home_page")
    final String? homePage;
    @JsonKey(name: "start_date")
    final String? startDate;
    @JsonKey(name: "end_date")
    final String? endDate;
    @JsonKey(name: "status")
    final int? status;
    @JsonKey(name: "time")
    final int? time;
    @JsonKey(name: "cinema_count")
    final int? cinemaCount;
    @JsonKey(name: "theater_count")
    final int? theaterCount;
    @JsonKey(name: "comment_count")
    final int? commentCount;
    @JsonKey(name: "watched_count")
    final int? watchedCount;
    @JsonKey(name: "want_to_see_count")
    final int? wantToSeeCount;
    @JsonKey(name: "spec")
    final List<Spec>? spec;
    @JsonKey(name: "hello_movie")
    final List<dynamic>? helloMovie;
    @JsonKey(name: "tags")
    final List<Tag>? tags;
    @JsonKey(name: "level_id")
    final int? levelId;
    @JsonKey(name: "level_name")
    final String? levelName;
    
    @JsonKey(name: "level_description")
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
        this.levelDescription
    });

    factory MovieResponse.fromJson(Map<String, dynamic> json) => _$MovieResponseFromJson(json);

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
