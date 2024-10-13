import 'package:json_annotation/json_annotation.dart';
import 'employment_history.dart';

part 'staff_profile.g.dart'; // The generated file for JSON serialization

@JsonSerializable(explicitToJson: true)
class StaffProfile {
  String staffId;                     // Unique ID for each staff member
  String firstName;                   // First name of the staff member
  String lastName;                    // Last name of the staff member
  String email;                       // Email address
  String phoneNumber;                 // Contact number
  String role;                        // Job title or role (e.g., Manager, Clerk, etc.)
  String department;                  // Department the staff belongs to
  DateTime dateOfBirth;              // Staff member's date of birth
  DateTime dateOfHire;               // Date the staff was hired
  String employmentStatus;            // Employment status (e.g., Active, Inactive)
  List<String> qualifications;        // List of qualifications or certifications
  List<EmploymentHistory> employmentHistory; // List of previous employment records

  StaffProfile({
    required this.staffId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.department,
    required this.dateOfBirth,
    required this.dateOfHire,
    required this.employmentStatus,
    required this.qualifications,
    required this.employmentHistory,
  });

  // CopyWith method to update specific fields
  StaffProfile copyWith({
    String? staffId,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? role,
    String? department,
    DateTime? dateOfBirth,
    DateTime? dateOfHire,
    String? employmentStatus,
    List<String>? qualifications,
    List<EmploymentHistory>? employmentHistory,
  }) {
    return StaffProfile(
      staffId: staffId ?? this.staffId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      department: department ?? this.department,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      dateOfHire: dateOfHire ?? this.dateOfHire,
      employmentStatus: employmentStatus ?? this.employmentStatus,
      qualifications: qualifications ?? this.qualifications,
      employmentHistory: employmentHistory ?? this.employmentHistory,
    );
  }

  // JSON serialization methods
  factory StaffProfile.fromJson(Map<String, dynamic> json) => _$StaffProfileFromJson(json);
  Map<String, dynamic> toJson() => _$StaffProfileToJson(this);
}
