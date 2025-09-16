import 'package:equatable/equatable.dart';

enum UserRole { admin, user }

enum UserStatus { ativo, inativo, pendente }

class UserModel extends Equatable {
  final int id;
  final String name;
  final String email;
  final UserRole role;
  final UserStatus status;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;
  final String? phone;
  final String? department;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    this.createdAt,
    this.lastLoginAt,
    this.phone,
    this.department,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] == 'admin' ? UserRole.admin : UserRole.user,
      status: _statusFromString(json['status'] as String?),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      phone: json['phone'] as String?,
      department: json['department'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'status': status.name,
      'createdAt': createdAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'phone': phone,
      'department': department,
    };
  }

  static UserStatus _statusFromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'ativo':
        return UserStatus.ativo;
      case 'inativo':
        return UserStatus.inativo;
      case 'pendente':
        return UserStatus.pendente;
      default:
        return UserStatus.ativo;
    }
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    UserRole? role,
    UserStatus? status,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? phone,
    String? department,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      phone: phone ?? this.phone,
      department: department ?? this.department,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    role,
    status,
    createdAt,
    lastLoginAt,
    phone,
    department,
  ];
}
