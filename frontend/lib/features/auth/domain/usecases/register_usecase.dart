import '../../domain/models/auth_response.dart';
import '../../domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<AuthResponse> execute({
    required String name,
    required String email,
    required String password,
  }) async {
    // Validations
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      throw Exception('Todos os campos são obrigatórios');
    }

    if (name.length < 2) {
      throw Exception('Nome deve ter pelo menos 2 caracteres');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Email inválido');
    }

    if (password.length < 6) {
      throw Exception('Senha deve ter pelo menos 6 caracteres');
    }

    return await _authRepository.register(
      name: name,
      email: email,
      password: password,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
