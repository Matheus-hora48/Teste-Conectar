import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository _authRepository;

  UpdateProfileUseCase(this._authRepository);

  Future<User> execute({
    required int userId,
    required String name,
    required String email,
  }) async {
    if (name.isEmpty || email.isEmpty) {
      throw Exception('Nome e email são obrigatórios');
    }

    if (name.length < 2) {
      throw Exception('Nome deve ter pelo menos 2 caracteres');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Email inválido');
    }

    return await _authRepository.updateProfile(
      userId: userId,
      name: name,
      email: email,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
