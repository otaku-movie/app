import 'package:json_annotation/json_annotation.dart';

part 'hello_movie.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class HelloMovieResponse {
    
    final int? id;
    
    final int? code;
    
    final String? date;

    HelloMovieResponse({
        this.id,
        this.code,
        this.date,
    });

    factory HelloMovieResponse.fromJson(Map<String, dynamic> json) => _$HelloMovieResponseFromJson(json);

    Map<String, dynamic> toJson() => _$HelloMovieResponseToJson(this);
}
