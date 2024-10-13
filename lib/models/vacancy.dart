import 'package:json_annotation/json_annotation.dart';

part 'vacancy.g.dart';  // The generated file for JSON serialization

@JsonSerializable(explicitToJson: true)
class Vacancy {
  String vacancyId;             // Unique ID for each vacancy record
  String propertyId;            // Foreign key linking to a Property
  DateTime vacantSince;         // Date since the property is vacant
  DateTime? occupiedDate;       // Date when the property gets occupied (nullable)
  String allocatedTo;           // Foreign key linking to a Resident who will occupy the property (nullable)
  String status;                // Available, Allocated, etc.

  Vacancy({
    required this.vacancyId,
    required this.propertyId,
    required this.vacantSince,
    this.occupiedDate,
    this.allocatedTo = '',
    required this.status,
  });

  // CopyWith method to update specific fields
  Vacancy copyWith({
    String? vacancyId,
    String? propertyId,
    DateTime? vacantSince,
    DateTime? occupiedDate,
    String? allocatedTo,
    String? status,
  }) {
    return Vacancy(
      vacancyId: vacancyId ?? this.vacancyId,
      propertyId: propertyId ?? this.propertyId,
      vacantSince: vacantSince ?? this.vacantSince,
      occupiedDate: occupiedDate ?? this.occupiedDate,
      allocatedTo: allocatedTo ?? this.allocatedTo,
      status: status ?? this.status,
    );
  }

  // JSON serialization methods
  factory Vacancy.fromJson(Map<String, dynamic> json) => _$VacancyFromJson(json);
  Map<String, dynamic> toJson() => _$VacancyToJson(this);
}
