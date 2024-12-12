import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'theater_detail_response.g.dart';

@JsonSerializable()
class TheaterDetailResponse {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "name")
    final String? name;
    @JsonKey(name: "row_count")
    final int? rowCount;
    @JsonKey(name: "column_count")
    final int? columnCount;
    @JsonKey(name: "cinema_id")
    final int? cinemaId;
    @JsonKey(name: "cinema_spec_id")
    final int? cinemaSpecId;
    @JsonKey(name: "cinema_spec_name")
    final String? cinemaSpecName;
    @JsonKey(name: "seat_count")
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
