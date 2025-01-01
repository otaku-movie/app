// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cinemaList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CinemaListResponse _$CinemaListResponseFromJson(Map<String, dynamic> json) =>
    CinemaListResponse(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      address: json['address'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
      tel: json['tel'] as String?,
      homePage: json['homePage'] as String?,
      maxSelectSeatCount: (json['maxSelectSeatCount'] as num?)?.toInt(),
      theaterCount: (json['theaterCount'] as num?)?.toInt(),
      brandId: (json['brandId'] as num?)?.toInt(),
      brandName: json['brandName'] as String?,
      spec: (json['spec'] as List<dynamic>?)
          ?.map((e) => Spec.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CinemaListResponseToJson(CinemaListResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'tel': instance.tel,
      'homePage': instance.homePage,
      'maxSelectSeatCount': instance.maxSelectSeatCount,
      'theaterCount': instance.theaterCount,
      'brandId': instance.brandId,
      'brandName': instance.brandName,
      'spec': instance.spec?.map((e) => e.toJson()).toList(),
      'distance': instance.distance,
    };

Spec _$SpecFromJson(Map<String, dynamic> json) => Spec(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      plusPrice: json['plusPrice'],
    );

Map<String, dynamic> _$SpecToJson(Spec instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'plusPrice': instance.plusPrice,
    };
