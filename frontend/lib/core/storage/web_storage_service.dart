import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../constants/app_constants.dart';
import '../../features/auth/domain/models/user.dart';

class WebStorageService {
  static WebStorageService? _instance;
  static WebStorageService get instance {
    _instance ??= WebStorageService._();
    return _instance!;
  }

  WebStorageService._();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> saveToken(String token) async {
    await init();
    await _prefs!.setString(AppConstants.tokenKey, token);

    _prefs!.getString(AppConstants.tokenKey);
  }

  Future<String?> getToken() async {
    await init();
    final token = _prefs!.getString(AppConstants.tokenKey);
    return token;
  }

  Future<void> saveUser(User user) async {
    await init();
    final userData = json.encode(user.toJson());
    await _prefs!.setString(AppConstants.userKey, userData);
  }

  Future<User?> getUser() async {
    await init();
    final userData = _prefs!.getString(AppConstants.userKey);
    if (userData != null) {
      try {
        final userMap = json.decode(userData);
        return User.fromJson(userMap);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> setLoggedIn(bool value) async {
    await init();
    await _prefs!.setBool('is_logged_in', value);
  }

  Future<bool> isLoggedIn() async {
    await init();
    return _prefs!.getBool('is_logged_in') ?? false;
  }

  Future<void> clearAll() async {
    await init();
    await _prefs!.remove(AppConstants.tokenKey);
    await _prefs!.remove(AppConstants.userKey);
    await _prefs!.remove('is_logged_in');
  }

  Future<Map<String, String>> getAllData() async {
    await init();
    final keys = _prefs!.getKeys();
    final data = <String, String>{};
    for (final key in keys) {
      final value = _prefs!.get(key);
      data[key] = value?.toString() ?? 'null';
    }
    return data;
  }
}
