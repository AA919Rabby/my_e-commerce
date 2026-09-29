class ProfileModel {
  final int? id;
  final int? userId;
  final String? fullName;
  final String? phoneNumber;
  final String? profilePictureUrl;
  final String? address;
  final String? updatedAt;

  ProfileModel({
    this.id,
    this.userId,
    this.fullName,
    this.phoneNumber,
    this.profilePictureUrl,
    this.address,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      userId: json['user_id'],
      fullName: json['full_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      profilePictureUrl: json['profile_picture_url'] ?? '',
      address: json['address'] ?? '',
      updatedAt: json['updated_at']?.toString(),
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