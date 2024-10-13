import 'package:json_annotation/json_annotation.dart';

part 'payment_history.g.dart';

@JsonSerializable()
class PaymentHistory {
  final String paymentId;         // Unique identifier for the payment
  final double amount;            // Payment amount
  final String paymentMethod;     // Payment method used (e.g., cash, bank transfer, mobile money)
  final DateTime paymentDate;     // Date the payment was made
  final String referenceNumber;   // Reference number provided by the payment processor
  final String status;            // Payment status (Completed, Pending, Failed)

  PaymentHistory({
    required this.paymentId,
    required this.amount,
    required this.paymentMethod,
    required this.paymentDate,
    required this.referenceNumber,
    required this.status,
  });

  // JSON serialization methods
  factory PaymentHistory.fromJson(Map<String, dynamic> json) => _$PaymentHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentHistoryToJson(this);
}
