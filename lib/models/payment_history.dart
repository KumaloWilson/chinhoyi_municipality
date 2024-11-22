import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_history.g.dart';

@JsonSerializable()
class PaymentHistory {
  final Map<String, dynamic> paymentIntentId; // Unique identifier for the payment
  final double amountTotal; // Payment amount
  final String paymentMethod; // Payment method used (e.g., cash, bank transfer, mobile money)

  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final Timestamp timestamp; // Date the payment was made

  final String email; // Reference number provided by the payment processor
  final String status; // Payment status (Completed, Pending, Failed)
  final String currency; // Payment currency

  PaymentHistory({
    required this.paymentIntentId,
    required this.amountTotal,
    required this.paymentMethod,
    required this.timestamp,
    required this.email,
    required this.status,
    required this.currency,
  });

  // JSON serialization methods
  factory PaymentHistory.fromJson(Map<String, dynamic> json) => _$PaymentHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentHistoryToJson(this);

  // Custom serialization for Timestamp
  static Timestamp _timestampFromJson(dynamic json) => json is Timestamp ? json : Timestamp.fromMillisecondsSinceEpoch(json as int);
  static int _timestampToJson(Timestamp timestamp) => timestamp.millisecondsSinceEpoch;
}
