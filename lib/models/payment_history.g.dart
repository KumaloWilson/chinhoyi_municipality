// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentHistory _$PaymentHistoryFromJson(Map<String, dynamic> json) =>
    PaymentHistory(
      paymentId: json['paymentId'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      paymentDate: DateTime.parse(json['paymentDate'] as String),
      referenceNumber: json['referenceNumber'] as String,
      status: json['status'] as String,
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$PaymentHistoryToJson(PaymentHistory instance) =>
    <String, dynamic>{
      'paymentId': instance.paymentId,
      'amount': instance.amount,
      'paymentMethod': instance.paymentMethod,
      'paymentDate': instance.paymentDate.toIso8601String(),
      'referenceNumber': instance.referenceNumber,
      'status': instance.status,
      'reason': instance.reason,
    };
