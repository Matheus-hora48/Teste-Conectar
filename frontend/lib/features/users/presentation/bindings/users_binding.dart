import 'package:get/get.dart';
import '../../../../core/network/api_service.dart';
import '../../data/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_users.dart';
import '../../domain/usecases/create_user.dart';
import '../../domain/usecases/update_user.dart';
import '../../domain/usecases/delete_user.dart';
import '../controllers/users_controller.dart';

class UsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRepository>(
      () => UserRepositoryImpl(Get.find<ApiService>()),
    );

    Get.lazyPut<UserRepositoryImpl>(
      () => UserRepositoryImpl(Get.find<ApiService>()),
    );

    Get.lazyPut(() => GetUsers(Get.find<UserRepository>()));
    Get.lazyPut(() => CreateUser(Get.find<UserRepository>()));
    Get.lazyPut(() => UpdateUser(Get.find<UserRepository>()));
    Get.lazyPut(() => DeleteUser(Get.find<UserRepository>()));

    Get.lazyPut(
      () => UsersController(
        Get.find<GetUsers>(),
        Get.find<CreateUser>(),
        Get.find<UpdateUser>(),
        Get.find<DeleteUser>(),
        Get.find<ApiService>(),
      ),
    );
  }
}
