// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffProfile _$StaffProfileFromJson(Map<String, dynamic> json) => StaffProfile(
      staffId: json['staffId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      role: json['role'] as String,
      post: json['post'] as String,
      department: json['department'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      dateOfHire: DateTime.parse(json['dateOfHire'] as String),
      employmentStatus: json['employmentStatus'] as String,
      qualifications: (json['qualifications'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      employmentHistory: (json['employmentHistory'] as List<dynamic>)
          .map((e) => EmploymentHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StaffProfileToJson(StaffProfile instance) =>
    <String, dynamic>{
      'staffId': instance.staffId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'role': instance.role,
      'post': instance.post,
      'department': instance.department,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'dateOfHire': instance.dateOfHire.toIso8601String(),
      'employmentStatus': instance.employmentStatus,
      'qualifications': instance.qualifications,
      'employmentHistory':
          instance.employmentHistory.map((e) => e.toJson()).toList(),
    };
