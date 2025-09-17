import 'package:get/get.dart';
import '../../../users/domain/usecases/get_inactive_users.dart';
import '../../../users/domain/repositories/user_repository.dart';
import '../../../users/data/user_repository_impl.dart';
import '../../../../core/network/api_service.dart';
import '../controllers/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    // Register dependencies if not already registered
    if (!Get.isRegistered<ApiService>()) {
      Get.lazyPut<ApiService>(() => ApiService());
    }

    if (!Get.isRegistered<UserRepository>()) {
      Get.lazyPut<UserRepository>(() => UserRepositoryImpl(Get.find()));
    }

    // Register use case
    Get.lazyPut<GetInactiveUsersUseCase>(
      () => GetInactiveUsersUseCase(Get.find<UserRepository>()),
    );

    // Register controller
    Get.lazyPut<NotificationController>(
      () => NotificationController(
        getInactiveUsersUseCase: Get.find<GetInactiveUsersUseCase>(),
      ),
    );
  }
}
