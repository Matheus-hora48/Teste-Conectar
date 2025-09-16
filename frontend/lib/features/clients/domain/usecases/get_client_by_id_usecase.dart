import '../models/client.dart';
import '../repositories/client_repository.dart';

class GetClientByIdUseCase {
  final ClientRepository _repository;

  GetClientByIdUseCase(this._repository);

  Future<Client> execute(int id) async {
    return await _repository.getClientById(id);
  }
}
