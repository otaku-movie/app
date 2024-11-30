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
      createTime: json['create_time'] == null
          ? null
          : DateTime.parse(json['create_time'] as String),
      token: json['token'] as String?,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cover': instance.cover,
      'name': instance.name,
      'email': instance.email,
      'create_time': instance.createTime?.toIso8601String(),
      'token': instance.token,
    };
