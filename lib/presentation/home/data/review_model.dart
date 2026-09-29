class ReviewModel {
  final int? id;
  final int? serviceId;
  final int? userId;
  final String? userName;
  final String? userProfilePicture;
  final int? rating;
  final String? comment;
  final String? createdAt;

  ReviewModel({
    this.id,
    this.serviceId,
    this.userId,
    this.userName,
    this.userProfilePicture,
    this.rating,
    this.comment,
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      serviceId: json['service_id'],
      userId: json['user_id'],
      userName: json['user_name'] ?? 'Anonymous User',
      userProfilePicture: json['user_profile_picture'],
      rating: json['rating'] != null ? int.tryParse(json['rating'].toString()) ?? 5 : 5,
      comment: json['comment'] ?? '',
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_id': serviceId,
      'user_id': userId,
      'user_name': userName,
      'user_profile_picture': userProfilePicture,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt,
    };
  }
}