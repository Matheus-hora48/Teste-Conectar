import 'package:get/get.dart';
import '../../data/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/update_password_usecase.dart';
import '../../domain/usecases/google_login_usecase.dart';
import '../controllers/auth_controller.dart';
import '../../../../core/network/api_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(apiService: Get.find<ApiService>()),
    );

    Get.lazyPut<LoginUseCase>(() => LoginUseCase(Get.find<AuthRepository>()));

    Get.lazyPut<RegisterUseCase>(
      () => RegisterUseCase(Get.find<AuthRepository>()),
    );

    Get.lazyPut<LogoutUseCase>(() => LogoutUseCase(Get.find<AuthRepository>()));

    Get.lazyPut<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(Get.find<AuthRepository>()),
    );

    Get.lazyPut<CheckAuthStatusUseCase>(
      () => CheckAuthStatusUseCase(Get.find<AuthRepository>()),
    );

    Get.lazyPut<UpdateProfileUseCase>(
      () => UpdateProfileUseCase(Get.find<AuthRepository>()),
    );

    Get.lazyPut<UpdatePasswordUseCase>(
      () => UpdatePasswordUseCase(Get.find<AuthRepository>()),
    );

    Get.lazyPut<GoogleLoginUseCase>(
      () => GoogleLoginUseCase(Get.find<AuthRepository>()),
    );

    Get.lazyPut<AuthController>(
      () => AuthController(
        loginUseCase: Get.find<LoginUseCase>(),
        registerUseCase: Get.find<RegisterUseCase>(),
        logoutUseCase: Get.find<LogoutUseCase>(),
        getCurrentUserUseCase: Get.find<GetCurrentUserUseCase>(),
        checkAuthStatusUseCase: Get.find<CheckAuthStatusUseCase>(),
        updateProfileUseCase: Get.find<UpdateProfileUseCase>(),
        updatePasswordUseCase: Get.find<UpdatePasswordUseCase>(),
        googleLoginUseCase: Get.find<GoogleLoginUseCase>(),
      ),
    );
  }
}
