import 'package:get/get.dart';
import '../../../../core/network/api_service.dart';
import '../../domain/models/user_model.dart';
import '../../domain/dtos/create_user_dto.dart';
import '../../domain/usecases/get_users.dart';
import '../../domain/usecases/create_user.dart';
import '../../domain/usecases/update_user.dart';
import '../../domain/usecases/delete_user.dart';
import '../../data/user_repository_impl.dart';

class UsersController extends GetxController {
  final GetUsers _getUsers;
  final CreateUser _createUser;
  final UpdateUser _updateUser;
  final DeleteUser _deleteUser;
  final ApiService _apiService;

  UsersController(
    this._getUsers,
    this._createUser,
    this._updateUser,
    this._deleteUser,
    this._apiService,
  );

  final RxList<UserModel> _users = <UserModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  final RxString _nameFilter = ''.obs;
  final RxString _emailFilter = ''.obs;
  final Rx<UserStatus?> _statusFilter = Rx<UserStatus?>(null);
  final Rx<UserRole?> _roleFilter = Rx<UserRole?>(null);

  final RxString selectedRole = ''.obs;
  final RxString selectedStatus = ''.obs;

  List<UserModel> get users => _users;
  List<UserModel> get filteredUsers => _users;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  String get nameFilter => _nameFilter.value;
  String get emailFilter => _emailFilter.value;
  UserStatus? get statusFilter => _statusFilter.value;
  UserRole? get roleFilter => _roleFilter.value;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final users = await _getUsers(
        name: _nameFilter.value.isEmpty ? null : _nameFilter.value,
        email: _emailFilter.value.isEmpty ? null : _emailFilter.value,
        status: _statusFilter.value,
        role: _roleFilter.value,
      );

      _users.assignAll(users);
    } catch (e) {
      _errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Erro ao carregar usuários: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      _isLoading.value = true;
      await _createUser(user);
      await loadUsers();
      Get.snackbar(
        'Sucesso',
        'Usuário criado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao criar usuário: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> createUserWithParams({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    UserStatus? status,
    String? phone,
    String? department,
  }) async {
    try {
      _isLoading.value = true;

      final dto = CreateUserDto(
        name: name,
        email: email,
        password: password,
        role: role,
      );

      final repository = Get.find<UserRepositoryImpl>();
      await repository.createUserWithPassword(dto);
      await loadUsers();

      Get.snackbar(
        'Sucesso',
        'Usuário criado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao criar usuário: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<UserModel> getUserById(int id) async {
    try {
      final userInList = _users.firstWhereOrNull((user) => user.id == id);
      if (userInList != null) {
        return userInList;
      }

      final response = await _apiService.get('/users/$id');
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao buscar usuário: $e');
    }
  }

  Future<void> updateUserWithParams({
    required int id,
    required String name,
    required String email,
    required UserRole role,
    UserStatus? status,
    String? phone,
    String? department,
  }) async {
    final currentUser = await getUserById(id);

    final updatedUser = UserModel(
      id: id,
      name: name,
      email: email,
      role: role,
      status: status ?? currentUser.status,
      phone: phone,
      department: department,
      createdAt: currentUser.createdAt,
      lastLoginAt: currentUser.lastLoginAt,
    );

    await updateUser(updatedUser);
  }

  Future<void> updateUser(UserModel user) async {
    try {
      _isLoading.value = true;
      await _updateUser(user);
      await loadUsers();
      Get.snackbar(
        'Sucesso',
        'Usuário atualizado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao atualizar usuário: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      _isLoading.value = true;
      await _deleteUser(id);
      await loadUsers();
      Get.snackbar(
        'Sucesso',
        'Usuário excluído com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao excluir usuário: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void setNameFilter(String name) {
    _nameFilter.value = name;
  }

  void setEmailFilter(String email) {
    _emailFilter.value = email;
  }

  void setStatusFilter(UserStatus? status) {
    _statusFilter.value = status;
  }

  void setRoleFilter(UserRole? role) {
    _roleFilter.value = role;
  }

  void applyFilters() {
    loadUsers();
  }

  void clearFilters() {
    _nameFilter.value = '';
    _emailFilter.value = '';
    _statusFilter.value = null;
    _roleFilter.value = null;
    loadUsers();
  }
}
