import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UpdateUser {
  final UserRepository repository;

  UpdateUser(this.repository);

  Future<UserModel> call(UserModel user) async {
    return await repository.updateUser(user);
  }
}
