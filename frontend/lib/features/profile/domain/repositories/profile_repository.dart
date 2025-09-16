import '../entities/profile_user.dart';

abstract class ProfileRepository {
  Future<ProfileUser> getProfile();
  Future<ProfileUser> updateProfile(UpdateProfileRequest request);
  Future<void> updatePassword(UpdatePasswordRequest request);
}
