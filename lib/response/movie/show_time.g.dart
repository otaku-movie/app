// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowTimeResponse _$ShowTimeResponseFromJson(Map<String, dynamic> json) =>
    ShowTimeResponse(
      date: json['date'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Cinema.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShowTimeResponseToJson(ShowTimeResponse instance) =>
    <String, dynamic>{
      'date': instance.date,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

Cinema _$CinemaFromJson(Map<String, dynamic> json) => Cinema(
      cinemaId: (json['cinema_id'] as num?)?.toInt(),
      cinemaName: json['cinema_name'] as String?,
      cinemaAddress: json['cinema_address'] as String?,
      time: (json['time'] as List<dynamic>?)
          ?.map((e) => Time.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CinemaToJson(Cinema instance) => <String, dynamic>{
      'cinema_id': instance.cinemaId,
      'cinema_name': instance.cinemaName,
      'cinema_address': instance.cinemaAddress,
      'time': instance.time?.map((e) => e.toJson()).toList(),
    };

Time _$TimeFromJson(Map<String, dynamic> json) => Time(
      startTime: json['start_time'] == null
          ? null
          : DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] == null
          ? null
          : DateTime.parse(json['end_time'] as String),
    );

Map<String, dynamic> _$TimeToJson(Time instance) => <String, dynamic>{
      'start_time': instance.startTime?.toIso8601String(),
      'end_time': instance.endTime?.toIso8601String(),
    };
