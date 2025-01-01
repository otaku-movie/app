import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class LoginResponse {
    
    final int? id;
    
    final String? cover;
    
    final String? name;
    
    final String? email;
    
    final DateTime? createTime;
    
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
