import '../models/auth_response.dart';
import '../models/user.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(String email, String password);
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
  });
  Future<AuthResponse?> loginWithGoogle();
  Future<AuthResponse> processGoogleCallback(String token);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<User?> getCurrentUser();
  Future<User> updateProfile({
    required int userId,
    required String name,
    required String email,
  });
  Future<void> updatePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  });
}
