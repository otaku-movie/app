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
      showTimes: (json['showTimes'] as List<dynamic>?)
          ?.map((e) => ShowTime.fromJson(e as Map<String, dynamic>))
          .toList(),
      cinemaLatitude: (json['cinemaLatitude'] as num?)?.toDouble(),
      cinemaLongitude: (json['cinemaLongitude'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CinemaToJson(Cinema instance) => <String, dynamic>{
      'cinemaId': instance.cinemaId,
      'cinemaName': instance.cinemaName,
      'cinemaAddress': instance.cinemaAddress,
      'showTimes': instance.showTimes?.map((e) => e.toJson()).toList(),
      'cinemaLatitude': instance.cinemaLatitude,
      'cinemaLongitude': instance.cinemaLongitude,
      'distance': instance.distance,
    };

ShowTime _$ShowTimeFromJson(Map<String, dynamic> json) => ShowTime(
      id: (json['id'] as num?)?.toInt(),
      theaterHallId: (json['theaterHallId'] as num?)?.toInt(),
      theaterHallName: json['theaterHallName'] as String?,
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      specName: json['specName'] as String?,
      totalSeats: (json['totalSeats'] as num?)?.toInt(),
      selectedSeats: (json['selectedSeats'] as num?)?.toInt(),
      availableSeats: (json['availableSeats'] as num?)?.toInt(),
      subtitleId: json['subtitleId'],
      showTimeTagId: json['showTimeTagId'],
      subtitle: json['subtitle'],
      showTimeTags: json['showTimeTags'],
    );

Map<String, dynamic> _$ShowTimeToJson(ShowTime instance) => <String, dynamic>{
      'id': instance.id,
      'theaterHallId': instance.theaterHallId,
      'theaterHallName': instance.theaterHallName,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'specName': instance.specName,
      'totalSeats': instance.totalSeats,
      'selectedSeats': instance.selectedSeats,
      'availableSeats': instance.availableSeats,
      'subtitleId': instance.subtitleId,
      'showTimeTagId': instance.showTimeTagId,
      'subtitle': instance.subtitle,
      'showTimeTags': instance.showTimeTags,
    };
