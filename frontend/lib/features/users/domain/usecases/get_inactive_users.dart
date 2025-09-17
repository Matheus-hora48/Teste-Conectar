import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class GetInactiveUsersUseCase {
  final UserRepository _repository;

  GetInactiveUsersUseCase(this._repository);

  Future<List<UserModel>> execute() async {
    return await _repository.getUsers(status: UserStatus.inativo);
  }
}
