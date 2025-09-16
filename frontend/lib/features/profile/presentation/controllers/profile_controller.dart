import 'package:get/get.dart';
import '../../domain/entities/profile_user.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/update_password_usecase.dart';

class ProfileController extends GetxController {
  final GetUserProfileUseCase _getProfileUseCase;
  final UpdateUserProfileUseCase _updateProfileUseCase;
  final UpdateUserPasswordUseCase _updatePasswordUseCase;

  ProfileController(
    this._getProfileUseCase,
    this._updateProfileUseCase,
    this._updatePasswordUseCase,
  );

  final _profileUser = Rxn<ProfileUser>();
  final _isLoading = false.obs;
  final _isUpdatingProfile = false.obs;
  final _isUpdatingPassword = false.obs;

  ProfileUser? get profileUser => _profileUser.value;
  bool get isLoading => _isLoading.value;
  bool get isUpdatingProfile => _isUpdatingProfile.value;
  bool get isUpdatingPassword => _isUpdatingPassword.value;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      _isLoading.value = true;
      final profile = await _getProfileUseCase();
      _profileUser.value = profile;
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao carregar perfil: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
  }) async {
    try {
      _isUpdatingProfile.value = true;

      final request = UpdateProfileRequest(name: name, email: email);

      final updatedProfile = await _updateProfileUseCase(request);
      _profileUser.value = updatedProfile;

      Get.snackbar(
        'Sucesso',
        'Perfil atualizado com sucesso!',
        snackPosition: SnackPosition.TOP,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao atualizar perfil: $e',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      _isUpdatingProfile.value = false;
    }
  }

  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _isUpdatingPassword.value = true;

      final request = UpdatePasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      await _updatePasswordUseCase(request);

      Get.snackbar(
        'Sucesso',
        'Senha alterada com sucesso!',
        snackPosition: SnackPosition.TOP,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao alterar senha: $e',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      _isUpdatingPassword.value = false;
    }
  }

  @override
  void refresh() {
    loadProfile();
  }
}
