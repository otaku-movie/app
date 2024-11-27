import 'package:json_annotation/json_annotation.dart';

part 'character.g.dart';


@JsonSerializable()
class CharacterResponse {
    @JsonKey(name: "staff")
    final List<CharacterResponse>? staff;
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "name")
    final String? name;
    @JsonKey(name: "cover")
    final String? cover;

    CharacterResponse({
        this.staff,
        this.id,
        this.name,
        this.cover,
    });

    factory CharacterResponse.fromJson(Map<String, dynamic> json) => _$CharacterResponseFromJson(json);

    Map<String, dynamic> toJson() => _$CharacterResponseToJson(this);
}