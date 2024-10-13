import 'package:json_annotation/json_annotation.dart';

part 'family_member.g.dart';

@JsonSerializable()
class FamilyMember {
  final String memberId;           // Unique ID for the family member
  final String residentId;         // Foreign key linking the family member to a resident
  final String firstName;          // First name of the family member
  final String lastName;           // Last name of the family member
  final String relationship;       // Relationship to the resident (e.g., Spouse, Child, Parent)
  final DateTime dateOfBirth;      // Date of birth of the family member
  final bool isDependent;          // Indicates if the member is a dependent (e.g., children or elderly parents)

  FamilyMember({
    required this.memberId,
    required this.residentId,
    required this.firstName,
    required this.lastName,
    required this.relationship,
    required this.dateOfBirth,
    required this.isDependent,
  });

  // JSON serialization methods
  factory FamilyMember.fromJson(Map<String, dynamic> json) => _$FamilyMemberFromJson(json);
  Map<String, dynamic> toJson() => _$FamilyMemberToJson(this);
}
