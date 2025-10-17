import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cinemaList.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class CinemaListResponse {
    
    final int? id;
    
    final String? name;
    
    final String? description;
    
    final String? address;
    final String? fullAddress;
    
    final String? tel;
    
    final String? homePage;
    
    final int? maxSelectSeatCount;
    
    final int? theaterCount;
    
    final int? brandId;
    
    final String? brandName;
    
    final List<Spec>? spec;
    
    double? distance;

    CinemaListResponse({
        this.id,
        this.name,
        this.description,
        this.address,
        this.fullAddress,
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

@JsonSerializable(fieldRename: FieldRename.none)
class Spec {
    
    final int? id;
    
    final String? name;
    
    final dynamic plusPrice;

    Spec({
        this.id,
        this.name,
        this.plusPrice,
    });

    factory Spec.fromJson(Map<String, dynamic> json) => _$SpecFromJson(json);

    Map<String, dynamic> toJson() => _$SpecToJson(this);
}
