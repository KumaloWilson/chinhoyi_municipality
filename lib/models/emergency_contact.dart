import 'package:json_annotation/json_annotation.dart';

part 'emergency_contact.g.dart';

@JsonSerializable()
class EmergencyContact {
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String relationshipToResident;

  // Constructor
  EmergencyContact({
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.relationshipToResident,
  });

  // Factory method to create an object from JSON
  factory EmergencyContact.fromJson(Map<String, dynamic> json) => _$EmergencyContactFromJson(json);

  // Method to convert the object to JSON
  Map<String, dynamic> toJson() => _$EmergencyContactToJson(this);
}
