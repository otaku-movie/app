import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'user_detail_response.g.dart';

@JsonSerializable()
class UserDetailResponse {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "name")
    final String? name;
    @JsonKey(name: "cover")
    final String? cover;
    @JsonKey(name: "email")
    final String? email;
    @JsonKey(name: "createTime")
    final String? createTime;
    @JsonKey(name: "orderCount")
    final int? orderCount;
    @JsonKey(name: "wantCount")
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
