import '../../../core/network/api_service.dart';
import '../domain/models/user_model.dart';
import '../domain/dtos/create_user_dto.dart';
import '../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiService _apiService;

  UserRepositoryImpl(this._apiService);

  @override
  Future<List<UserModel>> getUsers({
    String? name,
    String? email,
    UserStatus? status,
    UserRole? role,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (name != null && name.isNotEmpty) {
        queryParams['name'] = name;
      }
      if (email != null && email.isNotEmpty) {
        queryParams['email'] = email;
      }
      if (status != null) {
        queryParams['status'] = status.name;
      }
      if (role != null) {
        queryParams['role'] = role.name;
      }

      final response = await _apiService.get(
        '/users',
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data;
      return data.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar usuários: $e');
    }
  }

  @override
  Future<UserModel> getUserById(int id) async {
    try {
      final response = await _apiService.get('/users/$id');
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao buscar usuário: $e');
    }
  }

  @override
  Future<UserModel> createUser(UserModel user) async {
    try {
      final response = await _apiService.post('/users', data: user.toJson());
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao criar usuário: $e');
    }
  }

  Future<UserModel> createUserWithPassword(CreateUserDto dto) async {
    try {
      final response = await _apiService.post('/users', data: dto.toJson());
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao criar usuário: $e');
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    try {
      final response = await _apiService.put(
        '/users/${user.id}',
        data: user.toJson(),
      );
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao atualizar usuário: $e');
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    try {
      await _apiService.delete('/users/$id');
    } catch (e) {
      throw Exception('Erro ao excluir usuário: $e');
    }
  }
}
