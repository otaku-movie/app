// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      id: (json['id'] as num?)?.toInt(),
      cover: json['cover'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      createTime: json['createTime'] == null
          ? null
          : DateTime.parse(json['createTime'] as String),
      token: json['token'] as String?,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      accessExpiresIn: (json['accessExpiresIn'] as num?)?.toInt(),
      refreshExpiresIn: (json['refreshExpiresIn'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cover': instance.cover,
      'name': instance.name,
      'email': instance.email,
      'createTime': instance.createTime?.toIso8601String(),
      'token': instance.token,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'accessExpiresIn': instance.accessExpiresIn,
      'refreshExpiresIn': instance.refreshExpiresIn,
    };
