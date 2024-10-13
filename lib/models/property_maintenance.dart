import 'package:json_annotation/json_annotation.dart';

part 'property_maintenance.g.dart';  // The generated file for JSON serialization

@JsonSerializable(explicitToJson: true)
class PropertyMaintenance {
  String maintenanceId;         // Unique ID for each maintenance record
  String propertyId;            // Foreign key linking to a Property
  String maintenanceType;       // Plumbing, Electrical, Structural, etc.
  String contractorName;        // Name of contractor/worker responsible
  DateTime maintenanceDate;     // Date when maintenance was carried out
  String status;                // Completed, Scheduled, In Progress, etc.
  String notes;                 // Description of the issue and solution

  PropertyMaintenance({
    required this.maintenanceId,
    required this.propertyId,
    required this.maintenanceType,
    required this.contractorName,
    required this.maintenanceDate,
    required this.status,
    this.notes = '',
  });

  // CopyWith method to update specific fields
  PropertyMaintenance copyWith({
    String? maintenanceId,
    String? propertyId,
    String? maintenanceType,
    String? contractorName,
    DateTime? maintenanceDate,
    String? status,
    String? notes,
  }) {
    return PropertyMaintenance(
      maintenanceId: maintenanceId ?? this.maintenanceId,
      propertyId: propertyId ?? this.propertyId,
      maintenanceType: maintenanceType ?? this.maintenanceType,
      contractorName: contractorName ?? this.contractorName,
      maintenanceDate: maintenanceDate ?? this.maintenanceDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }

  // JSON serialization methods
  factory PropertyMaintenance.fromJson(Map<String, dynamic> json) => _$PropertyMaintenanceFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyMaintenanceToJson(this);
}
