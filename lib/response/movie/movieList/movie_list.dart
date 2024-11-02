import 'package:json_annotation/json_annotation.dart';

part 'movie_list.g.dart';

@JsonSerializable(explicitToJson: true)
class MovieListResponse {
  int? id;
  String? cover;
  String? name;
  String? originalName;
  String? description;
  String? homePage; // 改为 String? 类型
  String? startDate;
  DateTime? endDate;
  int? status;
  String? time; // 改为 String? 类型
  int? cinemaCount;
  int? theaterCount;
  int? commentCount;
  int? watchedCount;
  int? wantToSeeCount; // 改为 int? 类型
  String? createTime; // 改为 String? 类型
  String? updateTime; // 改为 String? 类型
  List<Spec>? spec;
  List<HelloMovie>? helloMovie;
  List<Tag>? tags;
  int? levelId;
  String? levelName;

  MovieListResponse({
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
    this.createTime,
    this.updateTime,
    this.spec,
    this.helloMovie,
    this.tags,
    this.levelId,
    this.levelName,
  });

  factory MovieListResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieListResponseToJson(this);
}

@JsonSerializable()
class HelloMovie {
  int? id;
  int? code;
  DateTime? date;

  HelloMovie({
    this.id,
    this.code,
    this.date,
  });

  factory HelloMovie.fromJson(Map<String, dynamic> json) =>
      _$HelloMovieFromJson(json);

  Map<String, dynamic> toJson() => _$HelloMovieToJson(this);
}

@JsonSerializable()
class Spec {
  int? id;
  String? name;
  String? description;

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
  int? id;
  String? name;

  Tag({
    this.id,
    this.name,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}
