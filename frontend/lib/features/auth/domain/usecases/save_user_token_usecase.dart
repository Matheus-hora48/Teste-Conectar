import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'dart:convert';
import '../models/user.dart';

class SaveUserTokenUseCase {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: "conectar_db",
      publicKey: "conectar_public_key",
    ),
  );

  Future<void> execute({required String token, required User user}) async {
    try {
      await _storage.write(key: AppConstants.tokenKey, value: token);

      await _storage.read(key: AppConstants.tokenKey);

      await _storage.write(
        key: AppConstants.userKey,
        value: json.encode(user.toJson()),
      );
    } catch (e) {
      throw Exception('Erro ao salvar dados do usuário: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: AppConstants.tokenKey);
    } catch (e) {
      return null;
    }
  }

  Future<User?> getUser() async {
    try {
      final userData = await _storage.read(key: AppConstants.userKey);
      if (userData != null) {
        final userMap = json.decode(userData);
        return User.fromJson(userMap);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final isLoggedIn = await _storage.read(key: AppConstants.isLoggedInKey);
      return isLoggedIn == 'true';
    } catch (e) {
      return false;
    }
  }

  Future<void> clearUserData() async {
    try {
      await _storage.delete(key: AppConstants.tokenKey);
      await _storage.delete(key: AppConstants.userKey);
      await _storage.delete(key: AppConstants.isLoggedInKey);
    } catch (e) {
      throw Exception('Erro ao limpar dados do usuário: $e');
    }
  }
}
