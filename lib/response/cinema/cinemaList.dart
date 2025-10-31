import 'package:json_annotation/json_annotation.dart';

part 'cinemaList.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class NowShowingMovie {
  final int? id;
  final String? name;
  final String? poster;
  final int? time;
  final String? levelName;
  final double? rate;
  final int? totalRatings;

  NowShowingMovie({
    this.id,
    this.name,
    this.poster,
    this.time,
    this.levelName,
    this.rate,
    this.totalRatings,
  });

  factory NowShowingMovie.fromJson(Map<String, dynamic> json) => _$NowShowingMovieFromJson(json);
  Map<String, dynamic> toJson() => _$NowShowingMovieToJson(this);
}

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
    final double? latitude;
    final double? longitude;
    final String? postalCode;
    
    final List<NowShowingMovie>? nowShowingMovies;
    
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
        this.nowShowingMovies,
        this.latitude,
        this.longitude,
        this.postalCode,
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
