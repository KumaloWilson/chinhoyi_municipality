import 'package:json_annotation/json_annotation.dart';

part 'property.g.dart';  // The generated file for JSON serialization

@JsonSerializable(explicitToJson: true)
class Property {
  String propertyId;             // Unique ID for each property
  String houseNumber;            // Current residential address (Street, Suburb, etc.)
  String suburb;             // Full address of the property
  String propertyType;           // Residential, Commercial, Municipal, etc.
  double propertySize;           // Size in square meters or feet
  String ownershipType;          // Owned by Resident, Rented, Municipal Lease
  String currentOwnerId;         // Foreign key linking to a Resident (Owner or Tenant)
  List<String> previousOwnerIds; // List of previous owners (resident IDs)
  String status;                 // Occupied, Vacant, Under Maintenance, etc.
  DateTime addedOn;              // Date the property was added to the system
  DateTime? lastModified;        // Date of last modification
  String notes;                  // Additional info about the property

  Property({
    required this.propertyId,
    required this.houseNumber,
    required this.suburb,
    required this.propertyType,
    required this.propertySize,
    required this.ownershipType,
    required this.currentOwnerId,
    required this.previousOwnerIds,
    required this.status,
    required this.addedOn,
    this.lastModified,
    this.notes = '',
  });

  // CopyWith method to update specific fields
  Property copyWith({
    String? propertyId,
    String? suburb,
    String? houseNumber,
    String? propertyType,
    double? propertySize,
    String? ownershipType,
    String? currentOwnerId,
    List<String>? previousOwnerIds,
    String? status,
    DateTime? addedOn,
    DateTime? lastModified,
    String? notes,
  }) {
    return Property(
      propertyId: propertyId ?? this.propertyId,
      suburb: suburb ?? this.suburb,
      houseNumber: houseNumber ?? this.houseNumber,
      propertyType: propertyType ?? this.propertyType,
      propertySize: propertySize ?? this.propertySize,
      ownershipType: ownershipType ?? this.ownershipType,
      currentOwnerId: currentOwnerId ?? this.currentOwnerId,
      previousOwnerIds: previousOwnerIds ?? this.previousOwnerIds,
      status: status ?? this.status,
      addedOn: addedOn ?? this.addedOn,
      lastModified: lastModified ?? this.lastModified,
      notes: notes ?? this.notes,
    );
  }

  // JSON serialization methods
  factory Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyToJson(this);
}
