// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theater_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TheaterDetailResponse _$TheaterDetailResponseFromJson(
        Map<String, dynamic> json) =>
    TheaterDetailResponse(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      rowCount: (json['rowCount'] as num?)?.toInt(),
      columnCount: (json['columnCount'] as num?)?.toInt(),
      cinemaId: (json['cinemaId'] as num?)?.toInt(),
      cinemaSpecId: (json['cinemaSpecId'] as num?)?.toInt(),
      cinemaSpecName: json['cinemaSpecName'] as String?,
      seatCount: (json['seatCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TheaterDetailResponseToJson(
        TheaterDetailResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'rowCount': instance.rowCount,
      'columnCount': instance.columnCount,
      'cinemaId': instance.cinemaId,
      'cinemaSpecId': instance.cinemaSpecId,
      'cinemaSpecName': instance.cinemaSpecName,
      'seatCount': instance.seatCount,
    };
