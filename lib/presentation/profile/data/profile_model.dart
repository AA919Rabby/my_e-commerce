class ProfileModel {
  final int? id;
  final int? userId;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? profilePictureUrl;
  final String? address;
  final String? createdAt;
  final String? updatedAt;
  final int totalCompletedServices;

  ProfileModel({
    this.id,
    this.userId,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.profilePictureUrl,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.totalCompletedServices = 0,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      userId: json['user_id'] ?? json['userId'],
      fullName: json['full_name'] ?? json['fullName'] ?? '',
      email: json['email'] ?? json['user']?['email'] ?? '',
      phoneNumber: json['phone_number'] ?? json['phoneNumber'] ?? '',
      profilePictureUrl: json['profile_picture_url'] ?? json['profilePictureUrl'] ?? '',
      address: json['address'] ?? '',
      createdAt: json['created_at']?.toString() ?? json['createdAt']?.toString(),
      updatedAt: json['updated_at']?.toString() ?? json['updatedAt']?.toString(),
      totalCompletedServices: json['total_completed_services'] != null
          ? int.tryParse(json['total_completed_services'].toString()) ?? 0
          : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'phone_number': phoneNumber,
      'profile_picture_url': profilePictureUrl,
      'address': address,
    };
  }
}