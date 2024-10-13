// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_maintenance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyMaintenance _$PropertyMaintenanceFromJson(Map<String, dynamic> json) =>
    PropertyMaintenance(
      maintenanceId: json['maintenanceId'] as String,
      propertyId: json['propertyId'] as String,
      maintenanceType: json['maintenanceType'] as String,
      contractorName: json['contractorName'] as String,
      maintenanceDate: DateTime.parse(json['maintenanceDate'] as String),
      status: json['status'] as String,
      notes: json['notes'] as String? ?? '',
    );

Map<String, dynamic> _$PropertyMaintenanceToJson(
        PropertyMaintenance instance) =>
    <String, dynamic>{
      'maintenanceId': instance.maintenanceId,
      'propertyId': instance.propertyId,
      'maintenanceType': instance.maintenanceType,
      'contractorName': instance.contractorName,
      'maintenanceDate': instance.maintenanceDate.toIso8601String(),
      'status': instance.status,
      'notes': instance.notes,
    };
