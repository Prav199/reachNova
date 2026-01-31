enum UserRole { influencer, brand }

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final UserRole role;
  final String bio;
  final Map<String, int> socialFollowing;
  final Map<String, String> socialHandles;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.role,
    required this.bio,
    this.socialFollowing = const {},
    this.socialHandles = const {},
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String? ?? '',
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
      socialHandles:
          (json['socialHandles'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as String),
          ) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'role': role.toString().split('.').last,
      'bio': bio,
      'socialFollowing': socialFollowing,
      'socialHandles': socialHandles,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    UserRole? role,
    String? bio,
    Map<String, int>? socialFollowing,
    Map<String, String>? socialHandles,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      bio: bio ?? this.bio,
      socialFollowing: socialFollowing ?? this.socialFollowing,
      socialHandles: socialHandles ?? this.socialHandles,
    );
  }
}
