import '../entities/profile_user.dart';
import '../repositories/profile_repository.dart';

class UpdateUserPasswordUseCase {
  final ProfileRepository repository;

  UpdateUserPasswordUseCase(this.repository);

  Future<void> call(UpdatePasswordRequest request) async {
    return await repository.updatePassword(request);
  }
}
