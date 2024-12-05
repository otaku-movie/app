import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'movie_ticket_type_response.g.dart';

@JsonSerializable()
class MovieTicketTypeResponse {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "price")
  final int? price;
  @JsonKey(name: "cinemaId")
  final int? cinemaId;
  @JsonKey(name: "createTime")
  final String? createTime;
  @JsonKey(name: "updateTime")
  final String? updateTime;
  @JsonKey(name: "deleted")
  final int? deleted;

  MovieTicketTypeResponse({
    this.id,
    this.name,
    this.price,
    this.cinemaId,
    this.createTime,
    this.updateTime,
    this.deleted,
  });

  factory MovieTicketTypeResponse.fromJson(Map<String, dynamic> json) => _$MovieTicketTypeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieTicketTypeResponseToJson(this);
}
