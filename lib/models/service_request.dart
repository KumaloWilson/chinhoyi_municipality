import 'package:json_annotation/json_annotation.dart';

part 'service_request.g.dart';

@JsonSerializable()
class ServiceRequest {
  final String requestId;
  final String residentAddress;         // Foreign key linking the request to a resident
  final String description;        // Description of the issue or service needed
  final String category;           // Category (e.g., Water, Electricity, Waste, Maintenance)
  final DateTime requestDate;      // Date the request was made
  final String status;             // Status (Open, In Progress, Resolved, Closed)
  final DateTime? resolutionDate;  // Date the issue was resolved (nullable if still open)
  final String resolutionNotes;    // Notes on how the request was resolved (optional)

  ServiceRequest({
    required this.requestId,
    required this.residentAddress,
    required this.description,
    required this.category,
    required this.requestDate,
    required this.status,
    this.resolutionDate,
    required this.resolutionNotes,
  });

  // JSON serialization methods
  factory ServiceRequest.fromJson(Map<String, dynamic> json) => _$ServiceRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceRequestToJson(this);

  // CopyWith method
  ServiceRequest copyWith({
    String? requestId,
    String? residentAddress,
    String? description,
    String? category,
    DateTime? requestDate,
    String? status,
    DateTime? resolutionDate,
    String? resolutionNotes,
  }) {
    return ServiceRequest(
      requestId: requestId ?? this.requestId,
      residentAddress: residentAddress ?? this.residentAddress,
      description: description ?? this.description,
      category: category ?? this.category,
      requestDate: requestDate ?? this.requestDate,
      status: status ?? this.status,
      resolutionDate: resolutionDate ?? this.resolutionDate,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
    );
  }
}
