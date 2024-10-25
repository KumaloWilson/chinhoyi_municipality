// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) => Announcement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      category: json['category'] as String,
      attachmentUrl: json['attachmentUrl'] as String?,
      status: json['status'] as String? ?? 'active',
      isHighPriority: json['isHighPriority'] as bool? ?? false,
    );

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'category': instance.category,
      'attachmentUrl': instance.attachmentUrl,
      'status': instance.status,
      'isHighPriority': instance.isHighPriority,
    };
