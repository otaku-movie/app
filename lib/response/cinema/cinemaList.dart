import 'package:json_annotation/json_annotation.dart';

part 'cinemaList.g.dart';

@JsonSerializable()
class CinemaListResponse {
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
    @JsonKey(name: "distance")
    double? distance;

    CinemaListResponse({
        this.id,
        this.name,
        this.description,
        this.address,
        this.distance,
        this.tel,
        this.homePage,
        this.maxSelectSeatCount,
        this.theaterCount,
        this.brandId,
        this.brandName,
        this.spec,
    });

    factory CinemaListResponse.fromJson(Map<String, dynamic> json) => _$CinemaListResponseFromJson(json);

    Map<String, dynamic> toJson() => _$CinemaListResponseToJson(this);
}

@JsonSerializable()
class Spec {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "name")
    final String? name;
    @JsonKey(name: "plus_price")
    final dynamic plusPrice;

    Spec({
        this.id,
        this.name,
        this.plusPrice,
    });

    factory Spec.fromJson(Map<String, dynamic> json) => _$SpecFromJson(json);

    Map<String, dynamic> toJson() => _$SpecToJson(this);
}
