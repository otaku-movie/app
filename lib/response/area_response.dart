import 'package:json_annotation/json_annotation.dart';

part 'area_response.g.dart';


@JsonSerializable()
class AreaResponse {
    @JsonKey(name: "id")
    int? id;
    @JsonKey(name: "name")
    String? name;
    @JsonKey(name: "nameKana")
    String? nameKana;
    @JsonKey(name: "parentId")
    int? parentId;
    @JsonKey(name: "children")
    List<AreaResponse>? children;

    AreaResponse({
        this.id,
        this.name,
        this.nameKana,
        this.parentId,
        this.children,
    });

    factory AreaResponse.fromJson(Map<String, dynamic> json) => _$AreaResponseFromJson(json);

    Map<String, dynamic> toJson() => _$AreaResponseToJson(this);
}
