import 'package:dio/dio.dart';
import '../domain/models/client.dart';
import '../domain/repositories/client_repository.dart';
import '../../../core/network/api_service.dart';
import '../../../core/constants/app_constants.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ApiService _apiService;

  ClientRepositoryImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<Client>> getClients({
    String? name,
    String? cnpj,
    String? cidade,
    String? conectar,
    ClientStatus? status,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (name != null && name.isNotEmpty) {
        queryParams['name'] = name;
      }
      if (cnpj != null && cnpj.isNotEmpty) {
        queryParams['cnpj'] = cnpj;
      }
      if (status != null) {
        String statusValue;
        switch (status) {
          case ClientStatus.ativo:
            statusValue = 'Ativo';
            break;
          case ClientStatus.inativo:
            statusValue = 'Inativo';
            break;
          case ClientStatus.pendente:
            statusValue = 'Pendente';
            break;
        }
        queryParams['status'] = statusValue;
      }
      if (cidade != null && cidade.isNotEmpty) {
        queryParams['city'] = cidade;
      }

      final response = await _apiService.get(
        AppConstants.clients,
        queryParameters: queryParams,
      );

      final List<dynamic> clientsData = response.data;
      final clients = clientsData.map((json) => Client.fromJson(json)).toList();

      return clients;
    } on DioException catch (e) {
      throw Exception('Erro ao buscar clientes: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }

  @override
  Future<Client> getClientById(int id) async {
    try {
      final response = await _apiService.get('${AppConstants.clients}/$id');
      return Client.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Cliente não encontrado');
      }
      throw Exception('Erro ao buscar cliente: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }

  @override
  Future<Client> createClient(Client client) async {
    try {
      final clientData = client.toJson(includeAutoFields: false);

      final response = await _apiService.post(
        AppConstants.clients,
        data: clientData,
      );

      final createdClient = Client.fromJson(response.data);

      return createdClient;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Dados inválidos para criação do cliente');
      }
      throw Exception('Erro ao criar cliente: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }

  @override
  Future<Client> updateClient(Client client) async {
    try {
      final clientData = client.toJson(includeAutoFields: false);

      final response = await _apiService.patch(
        '${AppConstants.clients}/${client.id}',
        data: clientData,
      );

      final updatedClient = Client.fromJson(response.data);

      return updatedClient;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Cliente não encontrado');
      }
      if (e.response?.statusCode == 400) {
        throw Exception('Dados inválidos para atualização do cliente');
      }
      throw Exception('Erro ao atualizar cliente: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }

  @override
  Future<void> deleteClient(int id) async {
    try {
      await _apiService.delete('${AppConstants.clients}/$id');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Cliente não encontrado');
      }
      throw Exception('Erro ao excluir cliente: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }
}
