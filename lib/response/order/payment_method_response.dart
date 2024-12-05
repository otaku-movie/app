import 'package:json_annotation/json_annotation.dart';

part 'payment_method_response.g.dart';

@JsonSerializable()
class PaymentMethodResponse {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "name")
    final String? name;

    PaymentMethodResponse({
        this.id,
        this.name,
    });

    factory PaymentMethodResponse.fromJson(Map<String, dynamic> json) => _$PaymentMethodResponseFromJson(json);

    Map<String, dynamic> toJson() => _$PaymentMethodResponseToJson(this);
}
