// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlyBalance _$MonthlyBalanceFromJson(Map<String, dynamic> json) =>
    MonthlyBalance(
      month: json['month'] as String,
      balance: (json['balance'] as num).toDouble(),
    );

Map<String, dynamic> _$MonthlyBalanceToJson(MonthlyBalance instance) =>
    <String, dynamic>{
      'month': instance.month,
      'balance': instance.balance,
    };
