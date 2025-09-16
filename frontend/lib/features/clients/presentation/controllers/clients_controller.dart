import 'package:get/get.dart';
import '../../domain/models/client.dart';
import '../../domain/usecases/get_clients_usecase.dart';
import '../../domain/usecases/get_client_by_id_usecase.dart';
import '../../domain/usecases/create_client_usecase.dart';
import '../../domain/usecases/update_client_usecase.dart';

class ClientsController extends GetxController {
  final GetClientsUseCase _getClientsUseCase;
  final GetClientByIdUseCase _getClientByIdUseCase;
  final CreateClientUseCase _createClientUseCase;
  final UpdateClientUseCase _updateClientUseCase;

  final RxList<Client> _clients = <Client>[].obs;
  final Rx<Client?> _selectedClient = Rx<Client?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _isLoadingForm = false.obs;

  final RxString _nameFilter = ''.obs;
  final RxString _cnpjFilter = ''.obs;
  final Rx<ClientStatus?> _statusFilter = Rx<ClientStatus?>(null);
  final RxString _cidadeFilter = ''.obs;

  ClientsController({
    required GetClientsUseCase getClientsUseCase,
    required GetClientByIdUseCase getClientByIdUseCase,
    required CreateClientUseCase createClientUseCase,
    required UpdateClientUseCase updateClientUseCase,
  }) : _getClientsUseCase = getClientsUseCase,
       _getClientByIdUseCase = getClientByIdUseCase,
       _createClientUseCase = createClientUseCase,
       _updateClientUseCase = updateClientUseCase;

  List<Client> get clients => _clients;
  Client? get selectedClient => _selectedClient.value;
  bool get isLoading => _isLoading.value;
  bool get isLoadingForm => _isLoadingForm.value;
  String get nameFilter => _nameFilter.value;
  String get cnpjFilter => _cnpjFilter.value;
  ClientStatus? get statusFilter => _statusFilter.value;
  String get cidadeFilter => _cidadeFilter.value;

  set isLoadingForm(bool value) => _isLoadingForm.value = value;

  @override
  void onInit() {
    super.onInit();
    loadClients();
  }

  Future<void> loadClients() async {
    try {
      _isLoading.value = true;

      final clients = await _getClientsUseCase.execute(
        name: _nameFilter.value.isEmpty ? null : _nameFilter.value,
        cnpj: _cnpjFilter.value.isEmpty ? null : _cnpjFilter.value,
        status: _statusFilter.value,
        cidade: _cidadeFilter.value.isEmpty ? null : _cidadeFilter.value,
      );

      _clients.assignAll(clients);
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadClientById(int id) async {
    try {
      _isLoadingForm.value = true;

      final client = await _getClientByIdUseCase.execute(id);
      _selectedClient.value = client;
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      _isLoadingForm.value = false;
    }
  }

  Future<bool> createClient(Client client) async {
    try {
      _isLoadingForm.value = true;
      final newClient = await _createClientUseCase.execute(client);

      _clients.add(newClient);

      Get.snackbar(
        'Sucesso',
        'Cliente criado com sucesso!',
        snackPosition: SnackPosition.TOP,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      _isLoadingForm.value = false;
    }
  }

  Future<bool> updateClient(Client client) async {
    try {
      _isLoadingForm.value = true;

      final updatedClient = await _updateClientUseCase.execute(client);

      final index = _clients.indexWhere((c) => c.id == updatedClient.id);
      if (index != -1) {
        _clients[index] = updatedClient;
      }

      _selectedClient.value = updatedClient;

      Get.snackbar(
        'Sucesso',
        'Cliente atualizado com sucesso!',
        snackPosition: SnackPosition.TOP,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      _isLoadingForm.value = false;
    }
  }

  void setNameFilter(String name) {
    _nameFilter.value = name;
  }

  void setCnpjFilter(String cnpj) {
    _cnpjFilter.value = cnpj;
  }

  void setStatusFilter(ClientStatus? status) {
    _statusFilter.value = status;
  }

  void setCidadeFilter(String cidade) {
    _cidadeFilter.value = cidade;
  }

  void clearFilters() {
    _nameFilter.value = '';
    _cnpjFilter.value = '';
    _statusFilter.value = null;
    _cidadeFilter.value = '';
  }

  void applyFilters() {
    loadClients();
  }

  void clearSelectedClient() {
    _selectedClient.value = null;
  }
}
