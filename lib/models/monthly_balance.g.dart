// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlyBalance _$MonthlyBalanceFromJson(Map<String, dynamic> json) =>
    MonthlyBalance(
      month: json['month'] as String,
      year: json['year'] as String,
      balanceCarriedForward: (json['balanceCarriedForward'] as num).toDouble(),
      bins: (json['bins'] as num).toDouble(),
      rates: (json['rates'] as num).toDouble(),
      sewerage: (json['sewerage'] as num).toDouble(),
      currentBalance: (json['currentBalance'] as num).toDouble(),
    );

Map<String, dynamic> _$MonthlyBalanceToJson(MonthlyBalance instance) =>
    <String, dynamic>{
      'month': instance.month,
      'year': instance.year,
      'balanceCarriedForward': instance.balanceCarriedForward,
      'bins': instance.bins,
      'rates': instance.rates,
      'sewerage': instance.sewerage,
      'currentBalance': instance.currentBalance,
    };
