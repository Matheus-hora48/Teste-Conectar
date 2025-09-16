import 'package:get/get.dart';
import '../../domain/models/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/update_password_usecase.dart';
import '../../domain/usecases/google_login_usecase.dart';

class AuthController extends GetxController {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final UpdatePasswordUseCase _updatePasswordUseCase;
  final GoogleLoginUseCase _googleLoginUseCase;

  final Rx<User?> _currentUser = Rx<User?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _isLoggedIn = false.obs;
  final RxBool _obscurePassword = true.obs;
  final RxBool _isAdmin = false.obs;

  AuthController({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required UpdatePasswordUseCase updatePasswordUseCase,
    required GoogleLoginUseCase googleLoginUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _checkAuthStatusUseCase = checkAuthStatusUseCase,
       _updateProfileUseCase = updateProfileUseCase,
       _updatePasswordUseCase = updatePasswordUseCase,
       _googleLoginUseCase = googleLoginUseCase;

  User? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;
  bool get isLoggedIn => _isLoggedIn.value;
  bool get obscurePassword => _obscurePassword.value;
  bool get isAdmin => _isAdmin.value;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      _isLoading.value = true;

      final isAuthenticated = await _checkAuthStatusUseCase.execute();
      _isLoggedIn.value = isAuthenticated;

      if (isAuthenticated) {
        final user = await _getCurrentUserUseCase.execute();
        _currentUser.value = user;
        _isAdmin.value = user?.role == UserRole.admin;
      } else {
        _currentUser.value = null;
        _isAdmin.value = false;
      }
    } catch (e) {
      _isLoggedIn.value = false;
      _currentUser.value = null;
      _isAdmin.value = false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading.value = true;

      final authResponse = await _loginUseCase.execute(email, password);
      _currentUser.value = authResponse.user;
      _isLoggedIn.value = true;
      _isAdmin.value = authResponse.user.role == UserRole.admin;

      Get.snackbar(
        'Sucesso',
        'Login realizado com sucesso!',
        snackPosition: SnackPosition.TOP,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _isLoading.value = true;

      final authResponse = await _registerUseCase.execute(
        name: name,
        email: email,
        password: password,
      );

      _currentUser.value = authResponse.user;
      _isLoggedIn.value = true;
      _isAdmin.value = authResponse.user.role == UserRole.admin;

      Get.snackbar(
        'Sucesso',
        'Conta criada com sucesso!',
        snackPosition: SnackPosition.TOP,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _logoutUseCase.execute();
      _currentUser.value = null;
      _isLoggedIn.value = false;
      _isAdmin.value = false;

      Get.snackbar(
        'Sucesso',
        'Logout realizado com sucesso!',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao fazer logout',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
  }) async {
    if (_currentUser.value == null) return false;

    try {
      _isLoading.value = true;

      final updatedUser = await _updateProfileUseCase.execute(
        userId: _currentUser.value!.id,
        name: name,
        email: email,
      );

      _currentUser.value = updatedUser;
      _isAdmin.value = updatedUser.role == UserRole.admin;

      Get.snackbar(
        'Sucesso',
        'Perfil atualizado com sucesso!',
        snackPosition: SnackPosition.TOP,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_currentUser.value == null) return false;

    try {
      _isLoading.value = true;

      await _updatePasswordUseCase.execute(
        userId: _currentUser.value!.id,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      Get.snackbar(
        'Sucesso',
        'Senha atualizada com sucesso!',
        snackPosition: SnackPosition.TOP,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      _isLoading.value = true;
      await _googleLoginUseCase.initiateGoogleLogin();
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> processGoogleCallback(String token) async {
    try {
      _isLoading.value = true;

      final authResponse = await _googleLoginUseCase.processCallback(token);
      _currentUser.value = authResponse.user;
      _isLoggedIn.value = true;
      _isAdmin.value = authResponse.user.role == UserRole.admin;

      Get.snackbar(
        'Sucesso',
        'Login com Google realizado com sucesso!',
        snackPosition: SnackPosition.TOP,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    _obscurePassword.value = !_obscurePassword.value;
  }
}
