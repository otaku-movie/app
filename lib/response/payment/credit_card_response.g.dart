// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardResponse _$CreditCardResponseFromJson(Map<String, dynamic> json) =>
    CreditCardResponse(
      id: (json['id'] as num?)?.toInt(),
      cardType: json['cardType'] as String?,
      lastFourDigits: json['lastFourDigits'] as String?,
      cardHolderName: json['cardHolderName'] as String?,
      expiryDate: json['expiryDate'] as String?,
      isDefault: json['isDefault'] as bool?,
      createTime: json['createTime'] as String?,
    );

Map<String, dynamic> _$CreditCardResponseToJson(CreditCardResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cardType': instance.cardType,
      'lastFourDigits': instance.lastFourDigits,
      'cardHolderName': instance.cardHolderName,
      'expiryDate': instance.expiryDate,
      'isDefault': instance.isDefault,
      'createTime': instance.createTime,
    };

CreditCardSaveRequest _$CreditCardSaveRequestFromJson(
        Map<String, dynamic> json) =>
    CreditCardSaveRequest(
      cardNumber: json['cardNumber'] as String,
      cardHolderName: json['cardHolderName'] as String,
      expiryDate: json['expiryDate'] as String,
      cvv: json['cvv'] as String,
      cardType: json['cardType'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
      saveCard: json['saveCard'] as bool? ?? true,
    );

Map<String, dynamic> _$CreditCardSaveRequestToJson(
        CreditCardSaveRequest instance) =>
    <String, dynamic>{
      'cardNumber': instance.cardNumber,
      'cardHolderName': instance.cardHolderName,
      'expiryDate': instance.expiryDate,
      'cvv': instance.cvv,
      'cardType': instance.cardType,
      'isDefault': instance.isDefault,
      'saveCard': instance.saveCard,
    };

PaymentRequest _$PaymentRequestFromJson(Map<String, dynamic> json) =>
    PaymentRequest(
      orderId: (json['orderId'] as num).toInt(),
      creditCardId: (json['creditCardId'] as num?)?.toInt(),
      tempCard: json['tempCard'] == null
          ? null
          : TempCard.fromJson(json['tempCard'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaymentRequestToJson(PaymentRequest instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'creditCardId': instance.creditCardId,
      'tempCard': instance.tempCard?.toJson(),
    };

TempCard _$TempCardFromJson(Map<String, dynamic> json) => TempCard(
      cardNumber: json['cardNumber'] as String,
      cardHolderName: json['cardHolderName'] as String,
      expiryDate: json['expiryDate'] as String,
      cvv: json['cvv'] as String,
      cardType: json['cardType'] as String,
    );

Map<String, dynamic> _$TempCardToJson(TempCard instance) => <String, dynamic>{
      'cardNumber': instance.cardNumber,
      'cardHolderName': instance.cardHolderName,
      'expiryDate': instance.expiryDate,
      'cvv': instance.cvv,
      'cardType': instance.cardType,
    };
