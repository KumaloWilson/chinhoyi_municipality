// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_valuation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyValuation _$PropertyValuationFromJson(Map<String, dynamic> json) =>
    PropertyValuation(
      valuationId: json['valuationId'] as String,
      propertyId: json['propertyId'] as String,
      valuationAmount: (json['valuationAmount'] as num).toDouble(),
      valuationDate: DateTime.parse(json['valuationDate'] as String),
      valuerName: json['valuerName'] as String,
      notes: json['notes'] as String? ?? '',
    );

Map<String, dynamic> _$PropertyValuationToJson(PropertyValuation instance) =>
    <String, dynamic>{
      'valuationId': instance.valuationId,
      'propertyId': instance.propertyId,
      'valuationAmount': instance.valuationAmount,
      'valuationDate': instance.valuationDate.toIso8601String(),
      'valuerName': instance.valuerName,
      'notes': instance.notes,
    };
