// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_staff.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieStaffResponse _$MovieStaffResponseFromJson(Map<String, dynamic> json) =>
    MovieStaffResponse(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      position: (json['position'] as List<dynamic>?)
          ?.map((e) => Position.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieStaffResponseToJson(MovieStaffResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
      'position': instance.position?.map((e) => e.toJson()).toList(),
    };

Position _$PositionFromJson(Map<String, dynamic> json) => Position(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$PositionToJson(Position instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
