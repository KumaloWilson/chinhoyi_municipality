// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentHistory _$PaymentHistoryFromJson(Map<String, dynamic> json) =>
    PaymentHistory(
      paymentIntentId: json['paymentIntentId'] as Map<String, dynamic>,
      amountTotal: (json['amountTotal'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      timestamp: PaymentHistory._timestampFromJson(json['timestamp']),
      email: json['email'] as String,
      status: json['status'] as String,
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$PaymentHistoryToJson(PaymentHistory instance) =>
    <String, dynamic>{
      'paymentIntentId': instance.paymentIntentId,
      'amountTotal': instance.amountTotal,
      'paymentMethod': instance.paymentMethod,
      'timestamp': PaymentHistory._timestampToJson(instance.timestamp),
      'email': instance.email,
      'status': instance.status,
      'currency': instance.currency,
    };
