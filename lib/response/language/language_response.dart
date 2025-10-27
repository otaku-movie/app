import 'package:json_annotation/json_annotation.dart';

part 'language_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class LanguageResponse {
  final int? id;
  final String? name;
  final String? code;
  final String? description;

  LanguageResponse({
    this.id,
    this.name,
    this.code,
    this.description,
  });

  factory LanguageResponse.fromJson(Map<String, dynamic> json) =>
      _$LanguageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageResponseToJson(this);
}
