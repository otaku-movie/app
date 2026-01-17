import 'package:json_annotation/json_annotation.dart';
import 'package:otaku_movie/response/movie/movieList/character.dart';

part 'movie_version.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class MovieVersionResponse {
  final int? id;
  final int? movieId;
  final int? versionCode;
  final String? startDate;
  final String? endDate;
  final int? languageId;
  final List<CharacterResponse>? characters;

  MovieVersionResponse({
    this.id,
    this.movieId,
    this.versionCode,
    this.startDate,
    this.endDate,
    this.languageId,
    this.characters,
  });

  factory MovieVersionResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieVersionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieVersionResponseToJson(this);
}
