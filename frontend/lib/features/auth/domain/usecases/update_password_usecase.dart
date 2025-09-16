import '../../domain/repositories/auth_repository.dart';

class UpdatePasswordUseCase {
  final AuthRepository _authRepository;

  UpdatePasswordUseCase(this._authRepository);

  Future<void> execute({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    if (currentPassword.isEmpty || newPassword.isEmpty) {
      throw Exception('Senha atual e nova senha são obrigatórias');
    }

    if (newPassword.length < 6) {
      throw Exception('Nova senha deve ter pelo menos 6 caracteres');
    }

    if (currentPassword == newPassword) {
      throw Exception('A nova senha deve ser diferente da atual');
    }

    return await _authRepository.updatePassword(
      userId: userId,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
