import 'package:json_annotation/json_annotation.dart';

part 'utility_account.g.dart';

@JsonSerializable()
class UtilityAccount {
  final String accountId;          // Unique ID for the utility account
  final String utilityType;        // Type of utility (e.g., Water, Electricity, Waste)
  final String residentId;         // Foreign key linking the utility account to a resident
  final double currentBalance;     // Current outstanding balance for the utility
  final DateTime lastBillingDate;  // The date of the last bill
  final double lastPaymentAmount;  // The amount of the last payment
  final DateTime? lastPaymentDate; // Date of the last payment (nullable if no payment made yet)

  UtilityAccount({
    required this.accountId,
    required this.utilityType,
    required this.residentId,
    required this.currentBalance,
    required this.lastBillingDate,
    required this.lastPaymentAmount,
    this.lastPaymentDate,
  });

  // JSON serialization methods
  factory UtilityAccount.fromJson(Map<String, dynamic> json) => _$UtilityAccountFromJson(json);
  Map<String, dynamic> toJson() => _$UtilityAccountToJson(this);
}
