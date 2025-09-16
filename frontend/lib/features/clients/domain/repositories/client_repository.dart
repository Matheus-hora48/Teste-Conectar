import '../models/client.dart';

abstract class ClientRepository {
  Future<List<Client>> getClients({
    String? name,
    String? cnpj,
    String? cidade,
    String? conectar,
    ClientStatus? status,
    int? page,
    int? limit,
  });

  Future<Client> getClientById(int id);

  Future<Client> createClient(Client client);

  Future<Client> updateClient(Client client);

  Future<void> deleteClient(int id);
}
