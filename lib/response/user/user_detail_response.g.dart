// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetailResponse _$UserDetailResponseFromJson(Map<String, dynamic> json) =>
    UserDetailResponse(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      cover: json['cover'] as String?,
      email: json['email'] as String?,
      createTime: json['createTime'] as String?,
      orderCount: (json['orderCount'] as num?)?.toInt(),
      wantCount: (json['wantCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserDetailResponseToJson(UserDetailResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cover': instance.cover,
      'email': instance.email,
      'createTime': instance.createTime,
      'orderCount': instance.orderCount,
      'wantCount': instance.wantCount,
    };
