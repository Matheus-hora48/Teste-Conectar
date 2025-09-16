import '../models/client.dart';
import '../repositories/client_repository.dart';

class CreateClientUseCase {
  final ClientRepository _repository;

  CreateClientUseCase(this._repository);

  Future<Client> execute(Client client) async {
    return await _repository.createClient(client);
  }
}
