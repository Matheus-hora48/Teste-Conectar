import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class CreateUser {
  final UserRepository repository;

  CreateUser(this.repository);

  Future<UserModel> call(UserModel user) async {
    return await repository.createUser(user);
  }
}
