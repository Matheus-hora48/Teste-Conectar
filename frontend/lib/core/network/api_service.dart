import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Dio? _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: "conectar_db",
      publicKey: "conectar_public_key",
    ),
  );
  final bool _isInitialized = false;

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio!.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final token = await _storage.read(key: AppConstants.tokenKey);

            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            } else {
              try {
                final allKeys = await _storage.readAll();
                allKeys.forEach((key, value) {
                  value.length > 20 ? '${value.substring(0, 20)}...' : value;
                });
              } catch (e, s) {
                log(
                  '🔐 [DEBUG] Erro ao ler storage: $e',
                  error: e,
                  stackTrace: s,
                );
              }
            }
          } catch (e, s) {
            log('🔐 [ERROR] Erro no interceptor: $e', error: e, stackTrace: s);
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await _storage.delete(key: AppConstants.tokenKey);
            await _storage.delete(key: AppConstants.userKey);
          }
          handler.next(error);
        },
      ),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: true,
      ),
    ]);
  }

  Dio get dio {
    if (_dio == null) initialize();
    return _dio!;
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: AppConstants.tokenKey, value: token);
    await _storage.read(key: AppConstants.tokenKey);
  }

  Future<String?> getToken() async {
    final token = await _storage.read(key: AppConstants.tokenKey);

    return token;
  }

  Future<void> clearAuth() async {
    await _storage.delete(key: AppConstants.tokenKey);
    await _storage.delete(key: AppConstants.userKey);
  }

  Future<void> saveUser(String userData) async {
    await _storage.write(key: AppConstants.userKey, value: userData);
  }

  Future<String?> getUser() async {
    return await _storage.read(key: AppConstants.userKey);
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    if (!_isInitialized) {
      initialize();
    }
    return _dio!.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) {
    if (!_isInitialized) initialize();
    return _dio!.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) {
    if (!_isInitialized) initialize();
    return _dio!.put(path, data: data);
  }

  Future<Response> patch(String path, {dynamic data}) {
    if (!_isInitialized) initialize();
    return _dio!.patch(path, data: data);
  }

  Future<Response> delete(String path) {
    if (!_isInitialized) initialize();
    return _dio!.delete(path);
  }
}
