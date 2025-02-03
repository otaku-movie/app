import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'upload_response.g.dart';

@JsonSerializable()
class UploadResponse {
    @JsonKey(name: "url")
    final String? url;

    UploadResponse({
        this.url,
    });

    factory UploadResponse.fromJson(Map<String, dynamic> json) => _$UploadResponseFromJson(json);

    Map<String, dynamic> toJson() => _$UploadResponseToJson(this);
}
