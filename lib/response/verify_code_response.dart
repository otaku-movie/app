import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'verify_code_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class VerifyCodeResponse {
    
    final String? token;

    VerifyCodeResponse({
        this.token,
    });

    factory VerifyCodeResponse.fromJson(Map<String, dynamic> json) => _$VerifyCodeResponseFromJson(json);

    Map<String, dynamic> toJson() => _$VerifyCodeResponseToJson(this);
}
