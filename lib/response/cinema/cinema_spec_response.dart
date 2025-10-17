import 'package:json_annotation/json_annotation.dart';

part 'cinema_spec_response.g.dart';

@JsonSerializable()
class CinemaSpecResponse {
    @JsonKey(name: "id")
    int? id;
    @JsonKey(name: "name")
    String? name;
    @JsonKey(name: "description")
    String? description;

    CinemaSpecResponse({
        this.id,
        this.name,
        this.description,
    });

    factory CinemaSpecResponse.fromJson(Map<String, dynamic> json) => _$CinemaSpecResponseFromJson(json);

    Map<String, dynamic> toJson() => _$CinemaSpecResponseToJson(this);
}
