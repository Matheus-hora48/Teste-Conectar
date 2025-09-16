import '../models/client.dart';
import '../repositories/client_repository.dart';

class UpdateClientUseCase {
  final ClientRepository _repository;

  UpdateClientUseCase(this._repository);

  Future<Client> execute(Client client) async {
    return await _repository.updateClient(client);
  }
}
