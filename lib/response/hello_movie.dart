import 'package:json_annotation/json_annotation.dart';

part 'hello_movie.g.dart';

@JsonSerializable()
class HelloMovie {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "code")
    final int? code;
    @JsonKey(name: "date")
    final DateTime? date;

    HelloMovie({
        this.id,
        this.code,
        this.date,
    });

    factory HelloMovie.fromJson(Map<String, dynamic> json) => _$HelloMovieFromJson(json);

    Map<String, dynamic> toJson() => _$HelloMovieToJson(this);
}
