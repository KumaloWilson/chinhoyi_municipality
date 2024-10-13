// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FamilyMember _$FamilyMemberFromJson(Map<String, dynamic> json) => FamilyMember(
      memberId: json['memberId'] as String,
      residentId: json['residentId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      relationship: json['relationship'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      isDependent: json['isDependent'] as bool,
    );

Map<String, dynamic> _$FamilyMemberToJson(FamilyMember instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'residentId': instance.residentId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'relationship': instance.relationship,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'isDependent': instance.isDependent,
    };
