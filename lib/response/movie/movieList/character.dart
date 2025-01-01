import 'package:json_annotation/json_annotation.dart';

part 'character.g.dart';


@JsonSerializable(fieldRename: FieldRename.none)
class CharacterResponse {
    
    final List<CharacterResponse>? staff;
    
    final int? id;
    
    final String? name;
    
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