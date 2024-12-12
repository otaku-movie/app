// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cinema_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CinemaDetailResponse _$CinemaDetailResponseFromJson(
        Map<String, dynamic> json) =>
    CinemaDetailResponse(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      address: json['address'] as String?,
      tel: json['tel'] as String?,
      homePage: json['home_page'] as String?,
      maxSelectSeatCount: (json['max_select_seat_count'] as num?)?.toInt(),
      theaterCount: (json['theater_count'] as num?)?.toInt(),
      brandId: (json['brand_id'] as num?)?.toInt(),
      brandName: json['brand_name'] as String?,
      spec: (json['spec'] as List<dynamic>?)
          ?.map((e) => Spec.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CinemaDetailResponseToJson(
        CinemaDetailResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'tel': instance.tel,
      'home_page': instance.homePage,
      'max_select_seat_count': instance.maxSelectSeatCount,
      'theater_count': instance.theaterCount,
      'brand_id': instance.brandId,
      'brand_name': instance.brandName,
      'spec': instance.spec?.map((e) => e.toJson()).toList(),
    };

Spec _$SpecFromJson(Map<String, dynamic> json) => Spec(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      plusPrice: (json['plus_price'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SpecToJson(Spec instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'plus_price': instance.plusPrice,
    };
