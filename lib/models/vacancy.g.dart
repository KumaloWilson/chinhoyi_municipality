// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacancy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vacancy _$VacancyFromJson(Map<String, dynamic> json) => Vacancy(
      vacancyId: json['vacancyId'] as String,
      propertyId: json['propertyId'] as String,
      vacantSince: DateTime.parse(json['vacantSince'] as String),
      occupiedDate: json['occupiedDate'] == null
          ? null
          : DateTime.parse(json['occupiedDate'] as String),
      allocatedTo: json['allocatedTo'] as String? ?? '',
      status: json['status'] as String,
    );

Map<String, dynamic> _$VacancyToJson(Vacancy instance) => <String, dynamic>{
      'vacancyId': instance.vacancyId,
      'propertyId': instance.propertyId,
      'vacantSince': instance.vacantSince.toIso8601String(),
      'occupiedDate': instance.occupiedDate?.toIso8601String(),
      'allocatedTo': instance.allocatedTo,
      'status': instance.status,
    };
