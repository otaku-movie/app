import 'package:json_annotation/json_annotation.dart';

part 'credit_card_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class CreditCardResponse {
  final int? id;
  final String? cardType;
  final String? lastFourDigits;
  final String? cardHolderName;
  final String? expiryDate;
  final bool? isDefault;
  final String? createTime;

  CreditCardResponse({
    this.id,
    this.cardType,
    this.lastFourDigits,
    this.cardHolderName,
    this.expiryDate,
    this.isDefault,
    this.createTime,
  });

  factory CreditCardResponse.fromJson(Map<String, dynamic> json) => _$CreditCardResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CreditCardResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class CreditCardSaveRequest {
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cvv;
  final String cardType;
  final bool isDefault;
  final bool saveCard;

  CreditCardSaveRequest({
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvv,
    required this.cardType,
    this.isDefault = false,
    this.saveCard = true,
  });

  factory CreditCardSaveRequest.fromJson(Map<String, dynamic> json) => _$CreditCardSaveRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreditCardSaveRequestToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class PaymentRequest {
  final int orderId;
  final int? creditCardId;
  final TempCard? tempCard;

  PaymentRequest({
    required this.orderId,
    this.creditCardId,
    this.tempCard,
  });

  factory PaymentRequest.fromJson(Map<String, dynamic> json) => _$PaymentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentRequestToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class TempCard {
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cvv;
  final String cardType;

  TempCard({
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvv,
    required this.cardType,
  });

  factory TempCard.fromJson(Map<String, dynamic> json) => _$TempCardFromJson(json);
  Map<String, dynamic> toJson() => _$TempCardToJson(this);
}
