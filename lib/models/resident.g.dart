// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resident _$ResidentFromJson(Map<String, dynamic> json) => Resident(
      residentId: json['residentId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      nationalId: json['nationalId'] as String,
      gender: json['gender'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      alternativePhone: json['alternativePhone'] as String?,
      property: Property.fromJson(json['property'] as Map<String, dynamic>),
      familyMembers: (json['familyMembers'] as List<dynamic>)
          .map((e) => FamilyMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      balances: (json['balances'] as List<dynamic>?)
          ?.map((e) => MonthlyBalance.fromJson(e as Map<String, dynamic>))
          .toList(),
      accountNumber: json['accountNumber'] as String,
      paymentMethod: json['paymentMethod'] as String?,
      paymentHistory: (json['paymentHistory'] as List<dynamic>?)
          ?.map((e) => PaymentHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
      serviceRequests: (json['serviceRequests'] as List<dynamic>?)
          ?.map((e) => ServiceRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      utilityAccounts: (json['utilityAccounts'] as List<dynamic>?)
          ?.map((e) => UtilityAccount.fromJson(e as Map<String, dynamic>))
          .toList(),
      employmentStatus: json['employmentStatus'] as String,
      employer: json['employer'] as String,
      monthlyIncome: (json['monthlyIncome'] as num).toDouble(),
      emergencyContact: EmergencyContact.fromJson(
          json['emergencyContact'] as Map<String, dynamic>),
      nationality: json['nationality'] as String,
      isDisabled: json['isDisabled'] as bool,
      isSeniorCitizen: json['isSeniorCitizen'] as bool?,
      notes: json['notes'] as String?,
      accountStatus: json['accountStatus'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$ResidentToJson(Resident instance) => <String, dynamic>{
      'residentId': instance.residentId,
      'accountNumber': instance.accountNumber,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'nationalId': instance.nationalId,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'alternativePhone': instance.alternativePhone,
      'property': instance.property.toJson(),
      'familyMembers': instance.familyMembers.map((e) => e.toJson()).toList(),
      'balances': instance.balances?.map((e) => e.toJson()).toList(),
      'paymentMethod': instance.paymentMethod,
      'paymentHistory':
          instance.paymentHistory?.map((e) => e.toJson()).toList(),
      'serviceRequests':
          instance.serviceRequests?.map((e) => e.toJson()).toList(),
      'utilityAccounts':
          instance.utilityAccounts?.map((e) => e.toJson()).toList(),
      'employmentStatus': instance.employmentStatus,
      'employer': instance.employer,
      'monthlyIncome': instance.monthlyIncome,
      'emergencyContact': instance.emergencyContact.toJson(),
      'nationality': instance.nationality,
      'isDisabled': instance.isDisabled,
      'isSeniorCitizen': instance.isSeniorCitizen,
      'notes': instance.notes,
      'accountStatus': instance.accountStatus,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };
