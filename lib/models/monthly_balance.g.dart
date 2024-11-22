// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlyPayment _$MonthlyPaymentFromJson(Map<String, dynamic> json) =>
    MonthlyPayment(
      dateOfPayment: json['dateOfPayment'] as String,
      amountPaid: (json['amountPaid'] as num).toDouble(),
    );

Map<String, dynamic> _$MonthlyPaymentToJson(MonthlyPayment instance) =>
    <String, dynamic>{
      'dateOfPayment': instance.dateOfPayment,
      'amountPaid': instance.amountPaid,
    };

MonthlyBalance _$MonthlyBalanceFromJson(Map<String, dynamic> json) =>
    MonthlyBalance(
      month: json['month'] as String,
      year: json['year'] as String,
      balanceCarriedForward: (json['balanceCarriedForward'] as num).toDouble(),
      bins: (json['bins'] as num).toDouble(),
      rates: (json['rates'] as num).toDouble(),
      sewerage: (json['sewerage'] as num).toDouble(),
      currentBalance: (json['currentBalance'] as num).toDouble(),
      monthlyPayments: (json['monthlyPayments'] as List<dynamic>?)
              ?.map((e) => MonthlyPayment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
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
      'monthlyPayments': instance.monthlyPayments,
    };
