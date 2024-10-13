import 'package:json_annotation/json_annotation.dart';

part 'building_permit.g.dart';  // The generated file for JSON serialization

@JsonSerializable(explicitToJson: true)
class BuildingPermit {
  String permitId;              // Unique ID for each permit
  String propertyId;            // Foreign key linking to a Property
  String applicantId;           // Foreign key linking to the Resident applying for the permit
  String permitType;            // Construction, Renovation, Demolition, etc.
  DateTime appliedDate;         // Date when the permit was applied for
  DateTime? approvedDate;       // Date when the permit was approved (nullable)
  String permitStatus;          // Pending, Approved, Denied, etc.
  String notes;                 // Additional info regarding the permit

  BuildingPermit({
    required this.permitId,
    required this.propertyId,
    required this.applicantId,
    required this.permitType,
    required this.appliedDate,
    this.approvedDate,
    required this.permitStatus,
    this.notes = '',
  });

  // CopyWith method for updating parts of the object
  BuildingPermit copyWith({
    String? permitId,
    String? propertyId,
    String? applicantId,
    String? permitType,
    DateTime? appliedDate,
    DateTime? approvedDate,
    String? permitStatus,
    String? notes,
  }) {
    return BuildingPermit(
      permitId: permitId ?? this.permitId,
      propertyId: propertyId ?? this.propertyId,
      applicantId: applicantId ?? this.applicantId,
      permitType: permitType ?? this.permitType,
      appliedDate: appliedDate ?? this.appliedDate,
      approvedDate: approvedDate ?? this.approvedDate,
      permitStatus: permitStatus ?? this.permitStatus,
      notes: notes ?? this.notes,
    );
  }

  // JSON serialization methods
  factory BuildingPermit.fromJson(Map<String, dynamic> json) => _$BuildingPermitFromJson(json);
  Map<String, dynamic> toJson() => _$BuildingPermitToJson(this);
}
