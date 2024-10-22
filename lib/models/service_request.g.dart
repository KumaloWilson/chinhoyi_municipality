// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceRequest _$ServiceRequestFromJson(Map<String, dynamic> json) =>
    ServiceRequest(
      requestId: json['requestId'] as String,
      resident: Resident.fromJson(json['resident'] as Map<String, dynamic>),
      description: json['description'] as String,
      category: json['category'] as String,
      requestDate: DateTime.parse(json['requestDate'] as String),
      status: json['status'] as String,
      resolutionDate: json['resolutionDate'] == null
          ? null
          : DateTime.parse(json['resolutionDate'] as String),
      resolutionNotes: json['resolutionNotes'] as String,
    );

Map<String, dynamic> _$ServiceRequestToJson(ServiceRequest instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'resident': instance.resident,
      'description': instance.description,
      'category': instance.category,
      'requestDate': instance.requestDate.toIso8601String(),
      'status': instance.status,
      'resolutionDate': instance.resolutionDate?.toIso8601String(),
      'resolutionNotes': instance.resolutionNotes,
    };
