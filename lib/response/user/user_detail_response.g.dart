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
      hasPassword: json['hasPassword'] as bool?,
      oauthBindings: (json['oauthBindings'] as List<dynamic>?)
          ?.map((e) => OAuthBindingItem.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      'hasPassword': instance.hasPassword,
      'oauthBindings': instance.oauthBindings?.map((e) => e.toJson()).toList(),
    };

OAuthBindingItem _$OAuthBindingItemFromJson(Map<String, dynamic> json) =>
    OAuthBindingItem(
      provider: json['provider'] as String?,
      name: json['name'] as String?,
      picture: json['picture'] as String?,
      email: json['email'] as String?,
      lastLoginAt: json['lastLoginAt'] as String?,
      createTime: json['createTime'] as String?,
    );

Map<String, dynamic> _$OAuthBindingItemToJson(OAuthBindingItem instance) =>
    <String, dynamic>{
      'provider': instance.provider,
      'name': instance.name,
      'picture': instance.picture,
      'email': instance.email,
      'lastLoginAt': instance.lastLoginAt,
      'createTime': instance.createTime,
    };
