enum UserRole { influencer, brand }

class User {
  final String id;
  final String name;
  final String email;
  final String profileImage;
  final UserRole role;
  final String bio;
  final Map<String, int> socialFollowing;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.role,
    required this.bio,
    this.socialFollowing = const {},
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profileImage: json['profileImage'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
        orElse: () => UserRole.influencer,
      ),
      bio: json['bio'] as String,
      socialFollowing:
          (json['socialFollowing'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as int),
          ) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'role': role.toString().split('.').last,
      'bio': bio,
      'socialFollowing': socialFollowing,
    };
  }
}
