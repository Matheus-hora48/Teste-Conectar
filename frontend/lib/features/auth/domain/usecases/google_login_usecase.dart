import 'package:url_launcher/url_launcher.dart';
import '../repositories/auth_repository.dart';
import '../models/auth_response.dart';

class GoogleLoginUseCase {
  final AuthRepository _repository;

  GoogleLoginUseCase(this._repository);

  Future<void> initiateGoogleLogin() async {
    try {
      await openGoogleAuth();
    } catch (e) {
      throw Exception('Erro ao iniciar login com Google: $e');
    }
  }

  Future<AuthResponse> processCallback(String token) async {
    try {
      return await _repository.processGoogleCallback(token);
    } catch (e) {
      throw Exception('Erro ao processar callback do Google: $e');
    }
  }

  Future<void> openGoogleAuth() async {
    const url = 'http://localhost:3010/auth/google';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Não foi possível abrir o navegador para autenticação');
    }
  }
}
