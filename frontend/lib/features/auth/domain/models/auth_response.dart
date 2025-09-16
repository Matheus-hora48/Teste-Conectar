import 'package:equatable/equatable.dart';
import 'user.dart';

class AuthResponse extends Equatable {
  final String accessToken;
  final User user;

  const AuthResponse({required this.accessToken, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'access_token': accessToken, 'user': user.toJson()};
  }

  @override
  List<Object> get props => [accessToken, user];
}
