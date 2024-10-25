import 'package:json_annotation/json_annotation.dart';

part 'monthly_balance.g.dart';

@JsonSerializable()
class MonthlyBalance {
  final String month;
  final String year;
  final double balanceCarriedForward;
  final double bins;
  final double rates;
  final double sewerage;
  final double currentBalance; // Total balance including all previous months

  // Computed property for current month's total
  double get monthTotal => balanceCarriedForward + bins + rates + sewerage;

  MonthlyBalance({
    required this.month,
    required this.year,
    required this.balanceCarriedForward,
    required this.bins,
    required this.rates,
    required this.sewerage,
    required this.currentBalance,
  });

  factory MonthlyBalance.fromJson(Map<String, dynamic> json) => _$MonthlyBalanceFromJson(json);
  Map<String, dynamic> toJson() => _$MonthlyBalanceToJson(this);
}
