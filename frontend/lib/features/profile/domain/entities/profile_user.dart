class ProfileUser {
  final int id;
  final String name;
  final String email;
  final String role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProfileUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  ProfileUser copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UpdateProfileRequest {
  final String name;
  final String email;

  UpdateProfileRequest({required this.name, required this.email});

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email};
  }
}

class UpdatePasswordRequest {
  final String currentPassword;
  final String newPassword;

  UpdatePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {'currentPassword': currentPassword, 'newPassword': newPassword};
  }
}
