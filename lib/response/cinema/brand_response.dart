import 'package:json_annotation/json_annotation.dart';

part 'brand_response.g.dart';

@JsonSerializable()
class BrandResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;

  BrandResponse({
    this.id,
    this.name,
  });

  factory BrandResponse.fromJson(Map<String, dynamic> json) => _$BrandResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BrandResponseToJson(this);
}

