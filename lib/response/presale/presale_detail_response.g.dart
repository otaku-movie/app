// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presale_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PresaleDetailResponse _$PresaleDetailResponseFromJson(
        Map<String, dynamic> json) =>
    PresaleDetailResponse(
      cover: json['cover'] as String?,
      gallery:
          (json['gallery'] as List<dynamic>?)?.map((e) => e as String).toList(),
      specifications: (json['specifications'] as List<dynamic>?)
          ?.map((e) => PresaleSpecification.fromJson(e as Map<String, dynamic>))
          .toList(),
      title: json['title'] as String?,
      code: json['code'] as String?,
      launchTime: json['launchTime'],
      endTime: json['endTime'],
      usageStart: json['usageStart'],
      usageEnd: json['usageEnd'],
      perUserLimit: json['perUserLimit'] as num?,
      pickupNotes: json['pickupNotes'] as String?,
      movieName: json['movieName'] as String?,
    );

Map<String, dynamic> _$PresaleDetailResponseToJson(
        PresaleDetailResponse instance) =>
    <String, dynamic>{
      'cover': instance.cover,
      'gallery': instance.gallery,
      'specifications':
          instance.specifications?.map((e) => e.toJson()).toList(),
      'title': instance.title,
      'code': instance.code,
      'launchTime': instance.launchTime,
      'endTime': instance.endTime,
      'usageStart': instance.usageStart,
      'usageEnd': instance.usageEnd,
      'perUserLimit': instance.perUserLimit,
      'pickupNotes': instance.pickupNotes,
      'movieName': instance.movieName,
    };

PresaleSpecification _$PresaleSpecificationFromJson(
        Map<String, dynamic> json) =>
    PresaleSpecification(
      name: json['name'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      priceItems: (json['priceItems'] as List<dynamic>?)
          ?.map((e) => PresalePriceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      stock: json['stock'],
      ticketType: (json['ticketType'] as num?)?.toInt(),
      deliveryType: (json['deliveryType'] as num?)?.toInt(),
      bonusTitle: json['bonusTitle'] as String?,
      bonusDescription: json['bonusDescription'] as String?,
      bonusImages: (json['bonusImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      bonusIncluded: json['bonusIncluded'] as bool?,
    );

Map<String, dynamic> _$PresaleSpecificationToJson(
        PresaleSpecification instance) =>
    <String, dynamic>{
      'name': instance.name,
      'images': instance.images,
      'priceItems': instance.priceItems?.map((e) => e.toJson()).toList(),
      'stock': instance.stock,
      'ticketType': instance.ticketType,
      'deliveryType': instance.deliveryType,
      'bonusTitle': instance.bonusTitle,
      'bonusDescription': instance.bonusDescription,
      'bonusImages': instance.bonusImages,
      'bonusIncluded': instance.bonusIncluded,
    };

PresalePriceItem _$PresalePriceItemFromJson(Map<String, dynamic> json) =>
    PresalePriceItem(
      label: json['label'] as String?,
      price: json['price'],
    );

Map<String, dynamic> _$PresalePriceItemToJson(PresalePriceItem instance) =>
    <String, dynamic>{
      'label': instance.label,
      'price': instance.price,
    };
