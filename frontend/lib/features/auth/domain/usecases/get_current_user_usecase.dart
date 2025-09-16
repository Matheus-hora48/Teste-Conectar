import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository _authRepository;

  GetCurrentUserUseCase(this._authRepository);

  Future<User?> execute() async {
    return await _authRepository.getCurrentUser();
  }
}
