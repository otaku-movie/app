// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_ticket_type_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieTicketTypeResponse _$MovieTicketTypeResponseFromJson(
        Map<String, dynamic> json) =>
    MovieTicketTypeResponse(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toInt(),
      cinemaId: (json['cinemaId'] as num?)?.toInt(),
      createTime: json['createTime'] as String?,
      updateTime: json['updateTime'] as String?,
      deleted: (json['deleted'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MovieTicketTypeResponseToJson(
        MovieTicketTypeResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'cinemaId': instance.cinemaId,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'deleted': instance.deleted,
    };
