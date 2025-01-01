import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'user_detail_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class UserDetailResponse {
    
    final int? id;
    
    final String? name;
    
    final String? cover;
    
    final String? email;
    
    final String? createTime;
    
    final int? orderCount;
    
    final int? wantCount;

    UserDetailResponse({
        this.id,
        this.name,
        this.cover,
        this.email,
        this.createTime,
        this.orderCount,
        this.wantCount,
    });

    factory UserDetailResponse.fromJson(Map<String, dynamic> json) => _$UserDetailResponseFromJson(json);

    Map<String, dynamic> toJson() => _$UserDetailResponseToJson(this);
}
