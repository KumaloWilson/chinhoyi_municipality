import 'package:json_annotation/json_annotation.dart';

part 'monthly_balance.g.dart';

@JsonSerializable()
class MonthlyPayment {
  final String dateOfPayment;
  final double amountPaid;

  MonthlyPayment({
    required this.dateOfPayment,
    required this.amountPaid,
  });

  factory MonthlyPayment.fromJson(Map<String, dynamic> json) => _$MonthlyPaymentFromJson(json);
  Map<String, dynamic> toJson() => _$MonthlyPaymentToJson(this);
}


@JsonSerializable()
class MonthlyBalance {
  final String month;
  final String year;
  final double balanceCarriedForward;
  final double bins;
  final double rates;
  final double sewerage;
  double currentBalance;

  @JsonKey(defaultValue: [])
  List<MonthlyPayment> monthlyPayments;

  double get monthTotal => balanceCarriedForward + bins + rates + sewerage;

  MonthlyBalance({
    required this.month,
    required this.year,
    required this.balanceCarriedForward,
    required this.bins,
    required this.rates,
    required this.sewerage,
    required this.currentBalance,
    this.monthlyPayments = const [],
  });

  void addPayment(String date, double amount) {
    // Add payment to the list
    monthlyPayments.add(MonthlyPayment(dateOfPayment: date, amountPaid: amount));

    // Update current balance by subtracting the payment amount
    currentBalance -= amount;

    // Ensure balance does not drop below zero (optional, depends on your business logic)
    if (currentBalance < 0) {
      currentBalance = 0;
    }
  }

  factory MonthlyBalance.fromJson(Map<String, dynamic> json) => _$MonthlyBalanceFromJson(json);
  Map<String, dynamic> toJson() => _$MonthlyBalanceToJson(this);
}
