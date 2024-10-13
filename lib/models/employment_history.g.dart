// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employment_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmploymentHistory _$EmploymentHistoryFromJson(Map<String, dynamic> json) =>
    EmploymentHistory(
      company: json['company'] as String,
      role: json['role'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      reasonForLeaving: json['reasonForLeaving'] as String,
    );

Map<String, dynamic> _$EmploymentHistoryToJson(EmploymentHistory instance) =>
    <String, dynamic>{
      'company': instance.company,
      'role': instance.role,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'reasonForLeaving': instance.reasonForLeaving,
    };
