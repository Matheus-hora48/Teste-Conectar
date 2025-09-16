import '../entities/profile_user.dart';
import '../repositories/profile_repository.dart';

class UpdateUserProfileUseCase {
  final ProfileRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<ProfileUser> call(UpdateProfileRequest request) async {
    return await repository.updateProfile(request);
  }
}
