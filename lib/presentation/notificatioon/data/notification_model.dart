class NotificationModel {
  final String id;
  final String title;
  final String subtitle;
  final bool isRead;
  final String? createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.isRead,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Notification',
      // Maps 'body' from FastAPI to 'subtitle' for the Flutter UI
      subtitle: json['body'] ?? json['subtitle'] ?? 'No details provided.',
      isRead: json['is_read'] ?? json['isRead'] ?? false,
      createdAt: json['created_at']?.toString(),
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    bool? isRead,
    String? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': subtitle,
      'is_read': isRead,
      'created_at': createdAt,
    };
  }
}