import 'package:json_annotation/json_annotation.dart';
import 'package:municipality/models/emergency_contact.dart';
import 'package:municipality/models/monthly_balance.dart';
import 'package:municipality/models/payment_history.dart';
import 'package:municipality/models/property.dart';
import 'package:municipality/models/service_request.dart';
import 'package:municipality/models/utility_account.dart';
import 'family_member.dart';
part 'resident.g.dart';

@JsonSerializable(explicitToJson: true)
class Resident {
  // Core Identification
  final String residentId;         // Unique ID for each resident
  final String accountNumber;         // Unique ID for each resident
  final String firstName;
  final String lastName;
  final String nationalId;         // National identification number (e.g., Social Security Number or similar)
  final String gender;             // Male, Female, Non-binary, Prefer not to say
  final DateTime dateOfBirth;      // Resident's birth date

  // Contact Information
  final String email;              // Email address of the resident
  final String phoneNumber;        // Primary phone number for contact
  final String? alternativePhone;   // Backup contact number

  // Property Information
  final Property property;   // Date the resident moved out (nullable if they haven't moved out yet)

  // Family and Household
  final List<FamilyMember> familyMembers; // List of family members linked to this resident, including their details

  // Billing and Payments
  final List<MonthlyBalance>? balances;

  final List<UtilityAccount>? utilityAccounts; // Associated accounts for water, electricity, waste, etc.

  // Employment and Economic Data (optional)
  final String employmentStatus;   // Employed, Unemployed, Retired, Student, etc.
  final String employer;           // Name of the employer (if applicable)
  final double monthlyIncome;      // Estimated monthly income (useful for social services programs)

  final EmergencyContact emergencyContact;

  // Miscellaneous
  final String nationality;        // Resident's nationality (especially for foreign residents)
  final bool isDisabled;           // Disability status (if any special accommodations are required)
  final bool? isSeniorCitizen;      // Whether the resident qualifies for senior citizen benefits
  final String? notes;              // Additional notes (e.g., relevant personal information)

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
    this.alternativePhone,
    required this.property,
    required this.familyMembers,
    this.balances,
    required this.accountNumber,
    this.utilityAccounts,
    required this.employmentStatus,
    required this.employer,
    required this.monthlyIncome,
    required this.emergencyContact,
    required this.nationality,
    required this.isDisabled,
    required this.isSeniorCitizen,
    this.notes,
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
    Property? property,
    List<FamilyMember>? familyMembers,
    String? paymentMethod,
    List<PaymentHistory>? paymentHistory,
    List<ServiceRequest>? serviceRequests,
    List<UtilityAccount>? utilityAccounts,
    String? employmentStatus,
    String? employer,
    double? monthlyIncome,
    EmergencyContact? emergencyContact,
    String? nationality,
    bool? isDisabled,
    List<MonthlyBalance>? balances,
    bool? isSeniorCitizen,
    String? notes,
    String? accountStatus,
    DateTime? lastUpdated,
    String? accountNumber,
  }) {
    return Resident(
      accountNumber: accountNumber ?? this.accountNumber,
      residentId: residentId ?? this.residentId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nationalId: nationalId ?? this.nationalId,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      alternativePhone: alternativePhone ?? this.alternativePhone,
      property: property ?? this.property,
      familyMembers: familyMembers ?? this.familyMembers,
      balances: balances ?? this.balances,
      utilityAccounts: utilityAccounts ?? this.utilityAccounts,
      employmentStatus: employmentStatus ?? this.employmentStatus,
      employer: employer ?? this.employer,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      nationality: nationality ?? this.nationality,
      isDisabled: isDisabled ?? this.isDisabled,
      isSeniorCitizen: isSeniorCitizen ?? this.isSeniorCitizen,
      notes: notes ?? this.notes,
      accountStatus: accountStatus ?? this.accountStatus,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
