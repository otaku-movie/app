import 'package:json_annotation/json_annotation.dart';

part 'movie_staff.g.dart';


@JsonSerializable(fieldRename: FieldRename.none)
class MovieStaffResponse {
    
    final int? id;
    
    final String? name;
    
    final String? avatar;
    
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

@JsonSerializable(fieldRename: FieldRename.none)
class Position {
    
    final int? id;
    
    final String? name;

    Position({
        this.id,
        this.name,
    });

    factory Position.fromJson(Map<String, dynamic> json) => _$PositionFromJson(json);

    Map<String, dynamic> toJson() => _$PositionToJson(this);
}
