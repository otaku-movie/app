import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'theater_detail_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class TheaterDetailResponse {
    
    final int? id;
    
    final String? name;
    
    final int? rowCount;
    
    final int? columnCount;
    
    final int? cinemaId;
    
    final int? cinemaSpecId;
    
    final String? cinemaSpecName;
    
    final int? seatCount;

    TheaterDetailResponse({
        this.id,
        this.name,
        this.rowCount,
        this.columnCount,
        this.cinemaId,
        this.cinemaSpecId,
        this.cinemaSpecName,
        this.seatCount,
    });

    factory TheaterDetailResponse.fromJson(Map<String, dynamic> json) => _$TheaterDetailResponseFromJson(json);

    Map<String, dynamic> toJson() => _$TheaterDetailResponseToJson(this);
}
