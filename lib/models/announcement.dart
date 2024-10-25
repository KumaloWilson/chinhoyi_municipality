import 'package:json_annotation/json_annotation.dart';

part 'announcement.g.dart';

@JsonSerializable()
class Announcement {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String category;
  final String? imageUrl;
  final String status;
  final bool isHighPriority;

  Announcement({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    this.imageUrl,
    this.status = 'active',
    this.isHighPriority = false,
  });

  // Factory constructor for creating a new `Announcement` instance from a map.
  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);

  // A method to convert this object into a map.
  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);

  // CopyWith method to create a modified copy of the instance
  Announcement copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? category,
    String? imageUrl,
    String? status,
    bool? isHighPriority,
  }) {
    return Announcement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      isHighPriority: isHighPriority ?? this.isHighPriority,
    );
  }
}
