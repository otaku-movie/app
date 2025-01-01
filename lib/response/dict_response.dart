import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'dict_response.g.dart';

class DictResponse {
  final Map<String, List<DictItemResponse>> _data;

  DictResponse([Map<String, List<DictItemResponse>>? data])
      : _data = data ?? {}; // 如果未提供 data，则使用空 Map

  factory DictResponse.fromJson(Map<String, dynamic> json) {
    return DictResponse(
      json.map((key, value) => MapEntry(
        key,
        (value as List).map((e) => DictItemResponse.fromJson(e)).toList(),
      )),
    );
  }

  Map<String, dynamic> toJson() => _data.map(
        (key, value) => MapEntry(
          key,
          value.map((e) => e.toJson()).toList(),
        ),
      );

  List<DictItemResponse>? operator [](String key) => _data[key];
}



@JsonSerializable(fieldRename: FieldRename.none)
class DictItemResponse {
    
    final int? id;
    
    final String? name;
    
    final int? code;
    
    final int? dictId;

    DictItemResponse({
        this.id,
        this.name,
        this.code,
        this.dictId,
    });

    factory DictItemResponse.fromJson(Map<String, dynamic> json) => _$DictItemResponseFromJson(json);

    Map<String, dynamic> toJson() => _$DictItemResponseToJson(this);
}
