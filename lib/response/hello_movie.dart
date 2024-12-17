import 'package:json_annotation/json_annotation.dart';

part 'hello_movie.g.dart';

@JsonSerializable()
class HelloMovieResponse {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "code")
    final int? code;
    @JsonKey(name: "date")
    final String? date;

    HelloMovieResponse({
        this.id,
        this.code,
        this.date,
    });

    factory HelloMovieResponse.fromJson(Map<String, dynamic> json) => _$HelloMovieResponseFromJson(json);

    Map<String, dynamic> toJson() => _$HelloMovieResponseToJson(this);
}
