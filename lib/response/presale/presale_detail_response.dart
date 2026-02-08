import 'package:json_annotation/json_annotation.dart';

part 'presale_detail_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class PresaleDetailResponse {
  final String? cover;
  final List<String>? gallery;
  final List<PresaleSpecification>? specifications;
  final String? title;
  final String? code;
  final dynamic launchTime;
  final dynamic endTime;
  final dynamic usageStart;
  final dynamic usageEnd;
  final num? perUserLimit;
  final String? pickupNotes;
  final String? movieName;

  PresaleDetailResponse({
    this.cover,
    this.gallery,
    this.specifications,
    this.title,
    this.code,
    this.launchTime,
    this.endTime,
    this.usageStart,
    this.usageEnd,
    this.perUserLimit,
    this.pickupNotes,
    this.movieName,
  });

  factory PresaleDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$PresaleDetailResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PresaleDetailResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class PresaleSpecification {
  final String? name;
  final List<String>? images;
  final List<PresalePriceItem>? priceItems;
  final dynamic stock;
  /// 卡类型（字典 ticketType）
  final int? ticketType;
  final int? deliveryType;
  final String? bonusTitle;
  final String? bonusDescription;
  final List<String>? bonusImages;
  final bool? bonusIncluded;

  PresaleSpecification({
    this.name,
    this.images,
    this.priceItems,
    this.stock,
    this.ticketType,
    this.deliveryType,
    this.bonusTitle,
    this.bonusDescription,
    this.bonusImages,
    this.bonusIncluded,
  });

  factory PresaleSpecification.fromJson(Map<String, dynamic> json) =>
      _$PresaleSpecificationFromJson(json);
  Map<String, dynamic> toJson() => _$PresaleSpecificationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class PresalePriceItem {
  final String? label;
  final dynamic price;

  PresalePriceItem({this.label, this.price});

  factory PresalePriceItem.fromJson(Map<String, dynamic> json) =>
      _$PresalePriceItemFromJson(json);
  Map<String, dynamic> toJson() => _$PresalePriceItemToJson(this);
}
