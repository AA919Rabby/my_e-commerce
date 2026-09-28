class NotificationModel {
  final String id;
  final String title;
  final String subtitle;
  final DateTime time;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Notification',
      // Adjust 'message' if your backend calls it something else like 'body' or 'subtitle'
      subtitle: json['message'] ?? '',
      time: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      isRead: json['is_read'] ?? false,
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    DateTime? time,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
    );
  }
}