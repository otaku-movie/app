import 'package:json_annotation/json_annotation.dart';

part 'cinema_detail_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class CinemaDetailResponse {
    
    final int? id;
    
    final String? name;
    
    final dynamic description; // 改为 dynamic，因为后端可能返回数字或字符串
    
    final String? address;
    final String? fullAddress;
    
    final String? tel;
    
    final String? homePage;
    
    final int? maxSelectSeatCount;
    
    final int? theaterCount;
    
    final int? brandId;
    
    final String? brandName;
    
    final List<Spec>? spec;
    
    final int? regionId;
    final int? prefectureId;
    final int? cityId;

    CinemaDetailResponse({
        this.id,
        this.name,
        this.description,
        this.address,
        this.fullAddress,
        this.tel,
        this.homePage,
        this.maxSelectSeatCount,
        this.theaterCount,
        this.brandId,
        this.brandName,
        this.spec,
        this.regionId,
        this.prefectureId,
        this.cityId,
    });

    factory CinemaDetailResponse.fromJson(Map<String, dynamic> json) => _$CinemaDetailResponseFromJson(json);

    Map<String, dynamic> toJson() => _$CinemaDetailResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class Spec {
    
    final int? id;
    
    final String? name;
    
    final dynamic description; // 改为 dynamic
    
    final dynamic plusPrice; // 改为 dynamic，因为后端可能返回字符串或数字

    Spec({
        this.id,
        this.name,
        this.description,
        this.plusPrice,
    });

    factory Spec.fromJson(Map<String, dynamic> json) => _$SpecFromJson(json);

    Map<String, dynamic> toJson() => _$SpecToJson(this);
}
