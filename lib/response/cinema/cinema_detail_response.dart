import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'cinema_detail_response.g.dart';

@JsonSerializable()
class CinemaDetailResponse {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "name")
    final String? name;
    @JsonKey(name: "description")
    final String? description;
    @JsonKey(name: "address")
    final String? address;
    @JsonKey(name: "tel")
    final String? tel;
    @JsonKey(name: "home_page")
    final String? homePage;
    @JsonKey(name: "max_select_seat_count")
    final int? maxSelectSeatCount;
    @JsonKey(name: "theater_count")
    final int? theaterCount;
    @JsonKey(name: "brand_id")
    final int? brandId;
    @JsonKey(name: "brand_name")
    final String? brandName;
    @JsonKey(name: "spec")
    final List<Spec>? spec;

    CinemaDetailResponse({
        this.id,
        this.name,
        this.description,
        this.address,
        this.tel,
        this.homePage,
        this.maxSelectSeatCount,
        this.theaterCount,
        this.brandId,
        this.brandName,
        this.spec,
    });

    factory CinemaDetailResponse.fromJson(Map<String, dynamic> json) => _$CinemaDetailResponseFromJson(json);

    Map<String, dynamic> toJson() => _$CinemaDetailResponseToJson(this);
}

@JsonSerializable()
class Spec {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "name")
    final String? name;
    @JsonKey(name: "plus_price")
    final int? plusPrice;

    Spec({
        this.id,
        this.name,
        this.plusPrice,
    });

    factory Spec.fromJson(Map<String, dynamic> json) => _$SpecFromJson(json);

    Map<String, dynamic> toJson() => _$SpecToJson(this);
}
