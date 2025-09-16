import '../models/user_model.dart';

abstract class UserRepository {
  Future<List<UserModel>> getUsers({
    String? name,
    String? email,
    UserStatus? status,
    UserRole? role,
  });

  Future<UserModel> getUserById(int id);
  Future<UserModel> createUser(UserModel user);
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(int id);
}
