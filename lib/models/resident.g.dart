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
      alternativePhone: json['alternativePhone'] as String,
      address: json['address'] as String,
      postalCode: json['postalCode'] as String,
      propertyId: json['propertyId'] as String,
      propertyType: json['propertyType'] as String,
      moveInDate: DateTime.parse(json['moveInDate'] as String),
      moveOutDate: json['moveOutDate'] == null
          ? null
          : DateTime.parse(json['moveOutDate'] as String),
      familyMembers: (json['familyMembers'] as List<dynamic>)
          .map((e) => FamilyMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      balanceDue: (json['balanceDue'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      paymentHistory: (json['paymentHistory'] as List<dynamic>)
          .map((e) => PaymentHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
      serviceRequests: (json['serviceRequests'] as List<dynamic>)
          .map((e) => ServiceRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      utilityAccounts: (json['utilityAccounts'] as List<dynamic>)
          .map((e) => UtilityAccount.fromJson(e as Map<String, dynamic>))
          .toList(),
      employmentStatus: json['employmentStatus'] as String,
      employer: json['employer'] as String,
      monthlyIncome: (json['monthlyIncome'] as num).toDouble(),
      emergencyContactName: json['emergencyContactName'] as String,
      emergencyContactPhone: json['emergencyContactPhone'] as String,
      relationshipToResident: json['relationshipToResident'] as String,
      nationality: json['nationality'] as String,
      isDisabled: json['isDisabled'] as bool,
      isSeniorCitizen: json['isSeniorCitizen'] as bool,
      notes: json['notes'] as String,
      accountStatus: json['accountStatus'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$ResidentToJson(Resident instance) => <String, dynamic>{
      'residentId': instance.residentId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'nationalId': instance.nationalId,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'alternativePhone': instance.alternativePhone,
      'address': instance.address,
      'postalCode': instance.postalCode,
      'propertyId': instance.propertyId,
      'propertyType': instance.propertyType,
      'moveInDate': instance.moveInDate.toIso8601String(),
      'moveOutDate': instance.moveOutDate?.toIso8601String(),
      'familyMembers': instance.familyMembers.map((e) => e.toJson()).toList(),
      'balanceDue': instance.balanceDue,
      'paymentMethod': instance.paymentMethod,
      'paymentHistory': instance.paymentHistory.map((e) => e.toJson()).toList(),
      'serviceRequests':
          instance.serviceRequests.map((e) => e.toJson()).toList(),
      'utilityAccounts':
          instance.utilityAccounts.map((e) => e.toJson()).toList(),
      'employmentStatus': instance.employmentStatus,
      'employer': instance.employer,
      'monthlyIncome': instance.monthlyIncome,
      'emergencyContactName': instance.emergencyContactName,
      'emergencyContactPhone': instance.emergencyContactPhone,
      'relationshipToResident': instance.relationshipToResident,
      'nationality': instance.nationality,
      'isDisabled': instance.isDisabled,
      'isSeniorCitizen': instance.isSeniorCitizen,
      'notes': instance.notes,
      'accountStatus': instance.accountStatus,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };
