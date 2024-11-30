import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "cover")
    final String? cover;
    @JsonKey(name: "name")
    final String? name;
    @JsonKey(name: "email")
    final String? email;
    @JsonKey(name: "create_time")
    final DateTime? createTime;
    @JsonKey(name: "token")
    final String? token;

    LoginResponse({
        this.id,
        this.cover,
        this.name,
        this.email,
        this.createTime,
        this.token,
    });

    factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

    Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
