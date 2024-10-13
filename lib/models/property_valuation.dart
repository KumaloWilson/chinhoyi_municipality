import 'package:json_annotation/json_annotation.dart';

part 'property_valuation.g.dart';  // The generated file for JSON serialization

@JsonSerializable(explicitToJson: true)
class PropertyValuation {
  String valuationId;           // Unique ID for each valuation record
  String propertyId;            // Foreign key linking to a Property
  double valuationAmount;       // The appraised value of the property
  DateTime valuationDate;       // Date when the valuation was done
  String valuerName;            // Name of the person/entity performing the valuation
  String notes;                 // Additional details or remarks

  PropertyValuation({
    required this.valuationId,
    required this.propertyId,
    required this.valuationAmount,
    required this.valuationDate,
    required this.valuerName,
    this.notes = '',
  });

  // CopyWith method to update specific fields
  PropertyValuation copyWith({
    String? valuationId,
    String? propertyId,
    double? valuationAmount,
    DateTime? valuationDate,
    String? valuerName,
    String? notes,
  }) {
    return PropertyValuation(
      valuationId: valuationId ?? this.valuationId,
      propertyId: propertyId ?? this.propertyId,
      valuationAmount: valuationAmount ?? this.valuationAmount,
      valuationDate: valuationDate ?? this.valuationDate,
      valuerName: valuerName ?? this.valuerName,
      notes: notes ?? this.notes,
    );
  }

  // JSON serialization methods
  factory PropertyValuation.fromJson(Map<String, dynamic> json) => _$PropertyValuationFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyValuationToJson(this);
}
