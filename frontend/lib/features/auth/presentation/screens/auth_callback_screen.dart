import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:get/get.dart';
import 'dart:html' as html;
import '../controllers/auth_controller.dart';

class AuthCallbackScreen extends StatefulWidget {
  const AuthCallbackScreen({super.key});

  @override
  State<AuthCallbackScreen> createState() => _AuthCallbackScreenState();
}

class _AuthCallbackScreenState extends State<AuthCallbackScreen> {
  final AuthController _authController = Get.find<AuthController>();
  bool _isProcessing = true;
  String _message = 'Processando login...';

  @override
  void initState() {
    super.initState();

    final currentUrl = html.window.location.href;

    if (currentUrl.contains('token=')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _processCallback();
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/login');
      });
    }
  }

  String? _getTokenFromUrl() {
    try {
      final currentUrl = html.window.location.href;

      final cleanUrl = currentUrl.split('#')[0];

      final uri = Uri.parse(cleanUrl);
      final token = uri.queryParameters['token'];

      if (token == null || token.isEmpty) {
        final tokenMatch = RegExp(r'token=([^&#+]+)').firstMatch(currentUrl);
        if (tokenMatch != null) {
          final extractedToken = tokenMatch.group(1);
          return extractedToken;
        }
      }

      return token;
    } catch (e, s) {
      log('Erro ao obter token da URL', error: e, stackTrace: s);
      return null;
    }
  }

  Future<void> _processCallback() async {
    try {
      setState(() {
        _message = 'Obtendo token de autenticação...';
      });

      await Future.delayed(const Duration(milliseconds: 500));

      String? token = Get.parameters['token'];

      if (token == null || token.isEmpty) {
        token = _getTokenFromUrl();
      }

      if (token != null && token.isNotEmpty) {
        setState(() {
          _message = 'Autenticando usuário...';
        });

        final success = await _authController.processGoogleCallback(token);

        print('Resultado do callback: $success');

        if (success && mounted) {
          setState(() {
            _message =
                'Login realizado com sucesso! Redirecionando para profile...';
          });

          await Future.delayed(const Duration(milliseconds: 1500));

          print('Executando Get.offAllNamed("/profile")');
          Get.offAllNamed('/profile');
        } else {
          setState(() {
            _message = 'Erro na autenticação. Redirecionando para login...';
            _isProcessing = false;
          });

          await Future.delayed(const Duration(milliseconds: 2000));
          Get.offAllNamed('/login');
        }
      } else {
        setState(() {
          _message =
              'Token de autenticação não encontrado. Redirecionando para login...';
          _isProcessing = false;
        });

        await Future.delayed(const Duration(milliseconds: 2000));
        Get.offAllNamed('/login');
      }
    } catch (e) {
      setState(() {
        _message =
            'Erro ao processar autenticação. Redirecionando para login...';
        _isProcessing = false;
      });

      await Future.delayed(const Duration(milliseconds: 2000));
      Get.offAllNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isProcessing) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
            ],
            Text(
              _message,
              style: TextStyle(fontSize: 16, color: AppColors.primaryColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
