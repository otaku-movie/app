import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'cinema_detail_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class CinemaDetailResponse {
    
    final int? id;
    
    final String? name;
    
    final String? description;
    
    final String? address;
    
    final String? tel;
    
    final String? homePage;
    
    final int? maxSelectSeatCount;
    
    final int? theaterCount;
    
    final int? brandId;
    
    final String? brandName;
    
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

@JsonSerializable(fieldRename: FieldRename.none)
class Spec {
    
    final int? id;
    
    final String? name;
    
    final int? plusPrice;

    Spec({
        this.id,
        this.name,
        this.plusPrice,
    });

    factory Spec.fromJson(Map<String, dynamic> json) => _$SpecFromJson(json);

    Map<String, dynamic> toJson() => _$SpecToJson(this);
}
