import 'package:get/get.dart';
import '../../../../core/network/api_service.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/update_password_usecase.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepositoryImpl(Get.find<ApiService>()),
    );

    Get.lazyPut<GetUserProfileUseCase>(
      () => GetUserProfileUseCase(Get.find<ProfileRepository>()),
    );
    Get.lazyPut<UpdateUserProfileUseCase>(
      () => UpdateUserProfileUseCase(Get.find<ProfileRepository>()),
    );
    Get.lazyPut<UpdateUserPasswordUseCase>(
      () => UpdateUserPasswordUseCase(Get.find<ProfileRepository>()),
    );

    Get.lazyPut<ProfileController>(
      () => ProfileController(
        Get.find<GetUserProfileUseCase>(),
        Get.find<UpdateUserProfileUseCase>(),
        Get.find<UpdateUserPasswordUseCase>(),
      ),
    );
  }
}
