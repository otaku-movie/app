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
      rowCount: (json['row_count'] as num?)?.toInt(),
      columnCount: (json['column_count'] as num?)?.toInt(),
      cinemaId: (json['cinema_id'] as num?)?.toInt(),
      cinemaSpecId: (json['cinema_spec_id'] as num?)?.toInt(),
      cinemaSpecName: json['cinema_spec_name'] as String?,
      seatCount: (json['seat_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TheaterDetailResponseToJson(
        TheaterDetailResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'row_count': instance.rowCount,
      'column_count': instance.columnCount,
      'cinema_id': instance.cinemaId,
      'cinema_spec_id': instance.cinemaSpecId,
      'cinema_spec_name': instance.cinemaSpecName,
      'seat_count': instance.seatCount,
    };
