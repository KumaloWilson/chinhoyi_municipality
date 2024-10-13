import 'package:json_annotation/json_annotation.dart';

part 'employment_history.g.dart'; // The generated file for JSON serialization

@JsonSerializable()
class EmploymentHistory {
  String company;                     // Name of the previous company
  String role;                        // Role held at the previous company
  DateTime startDate;                // Start date of employment
  DateTime endDate;                  // End date of employment
  String reasonForLeaving;            // Reason for leaving

  EmploymentHistory({
    required this.company,
    required this.role,
    required this.startDate,
    required this.endDate,
    required this.reasonForLeaving,
  });

  // JSON serialization methods
  factory EmploymentHistory.fromJson(Map<String, dynamic> json) => _$EmploymentHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$EmploymentHistoryToJson(this);
}
