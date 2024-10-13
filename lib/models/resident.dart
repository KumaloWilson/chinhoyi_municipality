import 'package:json_annotation/json_annotation.dart';
import 'package:municipality/models/payment_history.dart';
import 'package:municipality/models/service_request.dart';
import 'package:municipality/models/utility_account.dart';
import 'family_member.dart';
part 'resident.g.dart';

@JsonSerializable(explicitToJson: true)
class Resident {
  // Core Identification
  final String residentId;         // Unique ID for each resident
  final String firstName;
  final String lastName;
  final String nationalId;         // National identification number (e.g., Social Security Number or similar)
  final String gender;             // Male, Female, Non-binary, Prefer not to say
  final DateTime dateOfBirth;      // Resident's birth date

  // Contact Information
  final String email;              // Email address of the resident
  final String phoneNumber;        // Primary phone number for contact
  final String alternativePhone;   // Backup contact number
  final String address;            // Current residential address (Street, Suburb, etc.)
  final String postalCode;         // Postal/ZIP code for the address

  // Property Information
  final String propertyId;         // Foreign key linking to a Property entity, indicating the resident's home
  final String propertyType;       // Owner, Tenant, or Rented under Municipal Lease
  final DateTime moveInDate;       // Date the resident moved into the property
  final DateTime? moveOutDate;     // Date the resident moved out (nullable if they haven't moved out yet)

  // Family and Household
  final List<FamilyMember> familyMembers; // List of family members linked to this resident, including their details

  // Billing and Payments
  final double balanceDue;         // Outstanding balance for this resident (could be water bills, rent, etc.)
  final String paymentMethod;      // Payment method preference (e.g., cash, bank transfer, mobile money)
  final List<PaymentHistory> paymentHistory;  // Record of all payments made by the resident

  // Municipal Services and Requests
  final List<ServiceRequest> serviceRequests; // List of service requests or complaints raised by the resident
  final List<UtilityAccount> utilityAccounts; // Associated accounts for water, electricity, waste, etc.

  // Employment and Economic Data (optional)
  final String employmentStatus;   // Employed, Unemployed, Retired, Student, etc.
  final String employer;           // Name of the employer (if applicable)
  final double monthlyIncome;      // Estimated monthly income (useful for social services programs)

  // Emergency Contacts
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String relationshipToResident; // Relation to the resident (e.g., spouse, parent)

  // Miscellaneous
  final String nationality;        // Resident's nationality (especially for foreign residents)
  final bool isDisabled;           // Disability status (if any special accommodations are required)
  final bool isSeniorCitizen;      // Whether the resident qualifies for senior citizen benefits
  final String notes;              // Additional notes (e.g., relevant personal information)

  // Status Tracking
  final String accountStatus;      // Active, Inactive, or Archived
  final DateTime lastUpdated;      // Last time this record was updated

  // Constructor
  Resident({
    required this.residentId,
    required this.firstName,
    required this.lastName,
    required this.nationalId,
    required this.gender,
    required this.dateOfBirth,
    required this.email,
    required this.phoneNumber,
    required this.alternativePhone,
    required this.address,
    required this.postalCode,
    required this.propertyId,
    required this.propertyType,
    required this.moveInDate,
    this.moveOutDate,
    required this.familyMembers,
    required this.balanceDue,
    required this.paymentMethod,
    required this.paymentHistory,
    required this.serviceRequests,
    required this.utilityAccounts,
    required this.employmentStatus,
    required this.employer,
    required this.monthlyIncome,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.relationshipToResident,
    required this.nationality,
    required this.isDisabled,
    required this.isSeniorCitizen,
    required this.notes,
    required this.accountStatus,
    required this.lastUpdated,
  });

  // JSON serialization methods
  factory Resident.fromJson(Map<String, dynamic> json) => _$ResidentFromJson(json);
  Map<String, dynamic> toJson() => _$ResidentToJson(this);

  // CopyWith method
  Resident copyWith({
    String? residentId,
    String? firstName,
    String? lastName,
    String? nationalId,
    String? gender,
    DateTime? dateOfBirth,
    String? email,
    String? phoneNumber,
    String? alternativePhone,
    String? address,
    String? postalCode,
    String? propertyId,
    String? propertyType,
    DateTime? moveInDate,
    DateTime? moveOutDate,
    List<FamilyMember>? familyMembers,
    double? balanceDue,
    String? paymentMethod,
    List<PaymentHistory>? paymentHistory,
    List<ServiceRequest>? serviceRequests,
    List<UtilityAccount>? utilityAccounts,
    String? employmentStatus,
    String? employer,
    double? monthlyIncome,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? relationshipToResident,
    String? nationality,
    bool? isDisabled,
    bool? isSeniorCitizen,
    String? notes,
    String? accountStatus,
    DateTime? lastUpdated,
  }) {
    return Resident(
      residentId: residentId ?? this.residentId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nationalId: nationalId ?? this.nationalId,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      alternativePhone: alternativePhone ?? this.alternativePhone,
      address: address ?? this.address,
      postalCode: postalCode ?? this.postalCode,
      propertyId: propertyId ?? this.propertyId,
      propertyType: propertyType ?? this.propertyType,
      moveInDate: moveInDate ?? this.moveInDate,
      moveOutDate: moveOutDate ?? this.moveOutDate,
      familyMembers: familyMembers ?? this.familyMembers,
      balanceDue: balanceDue ?? this.balanceDue,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentHistory: paymentHistory ?? this.paymentHistory,
      serviceRequests: serviceRequests ?? this.serviceRequests,
      utilityAccounts: utilityAccounts ?? this.utilityAccounts,
      employmentStatus: employmentStatus ?? this.employmentStatus,
      employer: employer ?? this.employer,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      relationshipToResident: relationshipToResident ?? this.relationshipToResident,
      nationality: nationality ?? this.nationality,
      isDisabled: isDisabled ?? this.isDisabled,
      isSeniorCitizen: isSeniorCitizen ?? this.isSeniorCitizen,
      notes: notes ?? this.notes,
      accountStatus: accountStatus ?? this.accountStatus,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
