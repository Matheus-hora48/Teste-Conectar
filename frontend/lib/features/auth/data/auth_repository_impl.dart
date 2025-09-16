import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/network/api_service.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/models/auth_response.dart';
import '../domain/models/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;

  AuthRepositoryImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        AppConstants.authLogin,
        data: {'email': email, 'password': password},
      );

      final authResponse = AuthResponse.fromJson(response.data);

      await _apiService.saveToken(authResponse.accessToken);
      await _apiService.saveUser(jsonEncode(authResponse.user.toJson()));

      return authResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Email ou senha incorretos');
      }
      throw Exception('Erro ao fazer login: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }

  @override
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        AppConstants.authRegister,
        data: {'name': name, 'email': email, 'password': password},
      );

      final authResponse = AuthResponse.fromJson(response.data);

      await _apiService.saveToken(authResponse.accessToken);
      await _apiService.saveUser(jsonEncode(authResponse.user.toJson()));

      return authResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Email já está em uso');
      }
      throw Exception('Erro ao criar conta: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }

  @override
  Future<void> logout() async {
    await _apiService.clearAuth();
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final userData = await _apiService.getUser();
      if (userData != null) {
        return User.fromJson(jsonDecode(userData));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _apiService.getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<User> updateProfile({
    required int userId,
    required String name,
    required String email,
  }) async {
    try {
      final response = await _apiService.patch(
        '${AppConstants.users}/$userId',
        data: {'name': name, 'email': email},
      );

      final user = User.fromJson(response.data);

      await _apiService.saveUser(jsonEncode(user.toJson()));

      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Email já está em uso');
      }
      throw Exception('Erro ao atualizar perfil: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }

  @override
  Future<void> updatePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _apiService.patch(
        '${AppConstants.users}/$userId/password',
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Senha atual incorreta');
      }
      throw Exception('Erro ao atualizar senha: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }
}
