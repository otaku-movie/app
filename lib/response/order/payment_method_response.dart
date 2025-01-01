import 'package:json_annotation/json_annotation.dart';

part 'payment_method_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class PaymentMethodResponse {
    
    final int? id;
    
    final String? name;

    PaymentMethodResponse({
        this.id,
        this.name,
    });

    factory PaymentMethodResponse.fromJson(Map<String, dynamic> json) => _$PaymentMethodResponseFromJson(json);

    Map<String, dynamic> toJson() => _$PaymentMethodResponseToJson(this);
}
