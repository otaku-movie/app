import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieResponse {
    @JsonKey(name: "id")
    final int? id;

    @JsonKey(name: "name")
    final String? name;

    @JsonKey(name: "cover")
    final String? cover;

    @JsonKey(name: "level_name")
    final String? levelName;

    @JsonKey(name: "start_date")
    final String? startDate;

    MovieResponse({
        this.id,
        this.name,
        this.cover,
        this.levelName,
        this.startDate,
    });

    factory MovieResponse.fromJson(Map<String, dynamic> json) => _$MovieResponseFromJson(json);

    Map<String, dynamic> toJson() => _$MovieResponseToJson(this);
}
