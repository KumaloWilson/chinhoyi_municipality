// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utility_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UtilityAccount _$UtilityAccountFromJson(Map<String, dynamic> json) =>
    UtilityAccount(
      accountId: json['accountId'] as String,
      utilityType: json['utilityType'] as String,
      residentId: json['residentId'] as String,
      currentBalance: (json['currentBalance'] as num).toDouble(),
      lastBillingDate: DateTime.parse(json['lastBillingDate'] as String),
      lastPaymentAmount: (json['lastPaymentAmount'] as num).toDouble(),
      lastPaymentDate: json['lastPaymentDate'] == null
          ? null
          : DateTime.parse(json['lastPaymentDate'] as String),
    );

Map<String, dynamic> _$UtilityAccountToJson(UtilityAccount instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'utilityType': instance.utilityType,
      'residentId': instance.residentId,
      'currentBalance': instance.currentBalance,
      'lastBillingDate': instance.lastBillingDate.toIso8601String(),
      'lastPaymentAmount': instance.lastPaymentAmount,
      'lastPaymentDate': instance.lastPaymentDate?.toIso8601String(),
    };
