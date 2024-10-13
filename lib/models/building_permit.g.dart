// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'building_permit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuildingPermit _$BuildingPermitFromJson(Map<String, dynamic> json) =>
    BuildingPermit(
      permitId: json['permitId'] as String,
      propertyId: json['propertyId'] as String,
      applicantId: json['applicantId'] as String,
      permitType: json['permitType'] as String,
      appliedDate: DateTime.parse(json['appliedDate'] as String),
      approvedDate: json['approvedDate'] == null
          ? null
          : DateTime.parse(json['approvedDate'] as String),
      permitStatus: json['permitStatus'] as String,
      notes: json['notes'] as String? ?? '',
    );

Map<String, dynamic> _$BuildingPermitToJson(BuildingPermit instance) =>
    <String, dynamic>{
      'permitId': instance.permitId,
      'propertyId': instance.propertyId,
      'applicantId': instance.applicantId,
      'permitType': instance.permitType,
      'appliedDate': instance.appliedDate.toIso8601String(),
      'approvedDate': instance.approvedDate?.toIso8601String(),
      'permitStatus': instance.permitStatus,
      'notes': instance.notes,
    };
