import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:get/get.dart';
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

    // Verifica se tem token nos parâmetros da rota
    final routeToken = Get.parameters['token'];

    if (routeToken != null && routeToken.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _processCallback();
      });
    } else {
      // Redireciona para login se não há token nos parâmetros
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/login');
      });
    }
  }

  Future<void> _processCallback() async {
    try {
      setState(() {
        _message = 'Obtendo token de autenticação...';
      });

      await Future.delayed(const Duration(milliseconds: 500));

      // Obtém token apenas dos parâmetros da rota
      String? token = Get.parameters['token'];

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
      log('Erro ao processar callback: $e');
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
