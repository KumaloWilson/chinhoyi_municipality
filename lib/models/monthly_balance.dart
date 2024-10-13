import 'package:json_annotation/json_annotation.dart';

part 'monthly_balance.g.dart';

@JsonSerializable()
class MonthlyBalance {
  final String month; // e.g., "January 2024"
  final double balance; // Balance for the month

  MonthlyBalance({
    required this.month,
    required this.balance,
  });

  factory MonthlyBalance.fromJson(Map<String, dynamic> json) => _$MonthlyBalanceFromJson(json);
  Map<String, dynamic> toJson() => _$MonthlyBalanceToJson(this);
}
