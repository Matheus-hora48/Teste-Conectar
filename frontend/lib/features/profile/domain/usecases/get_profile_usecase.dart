import '../entities/profile_user.dart';
import '../repositories/profile_repository.dart';

class GetUserProfileUseCase {
  final ProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<ProfileUser> call() async {
    return await repository.getProfile();
  }
}
