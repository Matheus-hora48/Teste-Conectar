import '../../domain/repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository _authRepository;

  CheckAuthStatusUseCase(this._authRepository);

  Future<bool> execute() async {
    return await _authRepository.isLoggedIn();
  }
}
