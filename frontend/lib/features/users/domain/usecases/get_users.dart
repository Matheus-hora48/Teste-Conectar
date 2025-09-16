import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class GetUsers {
  final UserRepository repository;

  GetUsers(this.repository);

  Future<List<UserModel>> call({
    String? name,
    String? email,
    UserStatus? status,
    UserRole? role,
  }) async {
    return await repository.getUsers(
      name: name,
      email: email,
      status: status,
      role: role,
    );
  }
}
