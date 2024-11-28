import 'package:json_annotation/json_annotation.dart';

part 'movie_staff.g.dart';


@JsonSerializable()
class MovieStaffResponse {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "name")
    final String? name;
    @JsonKey(name: "avatar")
    final String? avatar;
    @JsonKey(name: "position")
    final List<Position>? position;

    MovieStaffResponse({
        this.id,
        this.name,
        this.avatar,
        this.position,
    });

    factory MovieStaffResponse.fromJson(Map<String, dynamic> json) => _$MovieStaffResponseFromJson(json);

    Map<String, dynamic> toJson() => _$MovieStaffResponseToJson(this);
}

@JsonSerializable()
class Position {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "name")
    final String? name;

    Position({
        this.id,
        this.name,
    });

    factory Position.fromJson(Map<String, dynamic> json) => _$PositionFromJson(json);

    Map<String, dynamic> toJson() => _$PositionToJson(this);
}
