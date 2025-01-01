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
      cinemaId: (json['cinemaId'] as num?)?.toInt(),
      cinemaName: json['cinemaName'] as String?,
      cinemaAddress: json['cinemaAddress'] as String?,
      time: (json['time'] as List<dynamic>?)
          ?.map((e) => Time.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CinemaToJson(Cinema instance) => <String, dynamic>{
      'cinemaId': instance.cinemaId,
      'cinemaName': instance.cinemaName,
      'cinemaAddress': instance.cinemaAddress,
      'time': instance.time?.map((e) => e.toJson()).toList(),
    };

Time _$TimeFromJson(Map<String, dynamic> json) => Time(
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
    );

Map<String, dynamic> _$TimeToJson(Time instance) => <String, dynamic>{
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
    };
