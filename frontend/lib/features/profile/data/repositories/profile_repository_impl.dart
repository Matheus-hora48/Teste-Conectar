import '../../domain/entities/profile_user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../../../core/network/api_service.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiService _apiService;

  ProfileRepositoryImpl(this._apiService);

  @override
  Future<ProfileUser> getProfile() async {
    try {
      final response = await _apiService.get('/users/profile/me');
      return ProfileUser.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao carregar perfil: $e');
    }
  }

  @override
  Future<ProfileUser> updateProfile(UpdateProfileRequest request) async {
    try {
      final response = await _apiService.patch(
        '/users/profile/me',
        data: request.toJson(),
      );
      return ProfileUser.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao atualizar perfil: $e');
    }
  }

  @override
  Future<void> updatePassword(UpdatePasswordRequest request) async {
    try {
      await _apiService.patch(
        '/users/profile/me/password',
        data: request.toJson(),
      );
    } catch (e) {
      throw Exception('Erro ao alterar senha: $e');
    }
  }
}
