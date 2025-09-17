import 'package:get/get.dart';
import '../../../users/domain/models/user_model.dart';
import '../../../users/domain/usecases/get_inactive_users.dart';

class NotificationController extends GetxController {
  final GetInactiveUsersUseCase _getInactiveUsersUseCase;

  final RxList<UserModel> _inactiveUsers = <UserModel>[].obs;
  final RxBool _isLoading = false.obs;

  NotificationController({
    required GetInactiveUsersUseCase getInactiveUsersUseCase,
  }) : _getInactiveUsersUseCase = getInactiveUsersUseCase;

  List<UserModel> get inactiveUsers => _inactiveUsers;
  bool get isLoading => _isLoading.value;
  int get inactiveUsersCount => _inactiveUsers.length;

  @override
  void onInit() {
    super.onInit();
    loadInactiveUsers();
  }

  Future<void> loadInactiveUsers() async {
    try {
      _isLoading.value = true;
      final users = await _getInactiveUsersUseCase.execute();
      _inactiveUsers.assignAll(users);
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao carregar usuários inativos: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshInactiveUsers() async {
    await loadInactiveUsers();
  }
}
