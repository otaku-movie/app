import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'movie_ticket_type_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class MovieTicketTypeResponse {
  
  final int? id;
  
  final String? name;
  
  final int? price;
  
  final int? cinemaId;
  
  final String? createTime;
  
  final String? updateTime;
  
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
