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
  final double? rate;
  final int? totalRatings;
  final bool? rated;
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
  final int? presaleShowTimeCount; // 预售场次数量
  final String? earliestShowTime; //最早场次时间
  /// 关联的预售券 id，有则可在 C 端跳转预售券详情
  final int? presaleId;
  /// 是否有预售券
  final bool? hasPresaleTicket;
  /// 该预售券是否含特典
  final bool? hasBonus;

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
    this.rate,
    this.rated = false,
    this.totalRatings,
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
    this.presaleShowTimeCount,
    this.earliestShowTime,
    this.presaleId,
    this.hasPresaleTicket,
    this.hasBonus
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class Spec {
    
    final int? id;
    
    final String? name;
    
    final String? description;

    Spec({
        this.id,
        this.name,
        this.description,
    });

    factory Spec.fromJson(Map<String, dynamic> json) => _$SpecFromJson(json);

    Map<String, dynamic> toJson() => _$SpecToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class Tag {
    
    final int? id;
    
    final String? name;

    Tag({
        this.id,
        this.name,
    });

    factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

    Map<String, dynamic> toJson() => _$TagToJson(this);
}
