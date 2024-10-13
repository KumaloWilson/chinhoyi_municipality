// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Property _$PropertyFromJson(Map<String, dynamic> json) => Property(
      propertyId: json['propertyId'] as String,
      address: json['address'] as String,
      propertyType: json['propertyType'] as String,
      propertySize: (json['propertySize'] as num).toDouble(),
      ownershipType: json['ownershipType'] as String,
      currentOwnerId: json['currentOwnerId'] as String,
      previousOwnerIds: (json['previousOwnerIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      status: json['status'] as String,
      addedOn: DateTime.parse(json['addedOn'] as String),
      lastModified: json['lastModified'] == null
          ? null
          : DateTime.parse(json['lastModified'] as String),
      notes: json['notes'] as String? ?? '',
    );

Map<String, dynamic> _$PropertyToJson(Property instance) => <String, dynamic>{
      'propertyId': instance.propertyId,
      'address': instance.address,
      'propertyType': instance.propertyType,
      'propertySize': instance.propertySize,
      'ownershipType': instance.ownershipType,
      'currentOwnerId': instance.currentOwnerId,
      'previousOwnerIds': instance.previousOwnerIds,
      'status': instance.status,
      'addedOn': instance.addedOn.toIso8601String(),
      'lastModified': instance.lastModified?.toIso8601String(),
      'notes': instance.notes,
    };
