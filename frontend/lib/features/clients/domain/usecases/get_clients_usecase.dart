import '../models/client.dart';
import '../repositories/client_repository.dart';

class GetClientsUseCase {
  final ClientRepository _repository;

  GetClientsUseCase(this._repository);

  Future<List<Client>> execute({
    String? name,
    String? cnpj,
    ClientStatus? status,
    String? cidade,
  }) async {
    return await _repository.getClients(
      name: name,
      cnpj: cnpj,
      status: status,
      cidade: cidade,
    );
  }
}
