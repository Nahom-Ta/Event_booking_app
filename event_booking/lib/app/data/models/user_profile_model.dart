class UserProfile {
  final String fullname;
  final String email;
  final String? bio; // New
  final String? profilePicture; // New

  UserProfile({
    required this.fullname, 
    required this.email, 
    this.bio, 
    this.profilePicture
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      fullname: json['full_name'] ?? '',
      email: json['email'] ?? '',
      bio: json['bio'] ?? '',
      // Backend returns a full URL or relative path for images
      profilePicture: json['profile_picture'], 
    );
  }
}