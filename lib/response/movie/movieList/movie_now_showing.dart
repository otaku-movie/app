import 'package:json_annotation/json_annotation.dart';
import 'package:otaku_movie/response/hello_movie.dart';
import 'package:otaku_movie/response/movie/movieList/movie.dart';

part 'movie_now_showing.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class MovieNowShowingResponse extends MovieResponse {
  
  final List<Cast>? cast;
  
  @override
  final List<HelloMovieResponse>? helloMovie;

  /// 是否有入场者特典（设计 3.4）
  final bool? hasBenefits;

  /// 是否来自重映计划
  final bool? isReRelease;

  /// 关联重映计划ID
  final int? reReleaseId;

  /// 重映特殊版本说明（可空）
  final String? reReleaseVersionInfo;

  MovieNowShowingResponse({
    super.id,
    super.name,
    super.cover,
    this.cast,
    this.helloMovie,
    super.levelName,
    super.startDate,
    super.presaleId,
    super.hasPresaleTicket,
    super.hasBonus,
    this.hasBenefits,
    this.isReRelease,
    this.reReleaseId,
    this.reReleaseVersionInfo,
  });

  factory MovieNowShowingResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieNowShowingResponseFromJson(json);

  @override
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
