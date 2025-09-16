import 'package:frontend/core/network/api_service.dart';
import 'package:frontend/features/clients/data/client_repository_impl.dart';
import 'package:frontend/features/clients/domain/repositories/client_repository.dart';
import 'package:frontend/features/clients/presentation/controllers/clients_controller.dart';
import 'package:get/get.dart';
import 'package:frontend/features/clients/domain/usecases/get_clients_usecase.dart';
import 'package:frontend/features/clients/domain/usecases/get_client_by_id_usecase.dart';
import 'package:frontend/features/clients/domain/usecases/create_client_usecase.dart';
import 'package:frontend/features/clients/domain/usecases/update_client_usecase.dart';

class ClientsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClientRepository>(
      () => ClientRepositoryImpl(apiService: Get.find<ApiService>()),
    );

    Get.lazyPut<GetClientsUseCase>(() => GetClientsUseCase(Get.find()));
    Get.lazyPut<GetClientByIdUseCase>(() => GetClientByIdUseCase(Get.find()));
    Get.lazyPut<CreateClientUseCase>(() => CreateClientUseCase(Get.find()));
    Get.lazyPut<UpdateClientUseCase>(() => UpdateClientUseCase(Get.find()));

    Get.lazyPut<ClientsController>(
      () => ClientsController(
        getClientsUseCase: Get.find(),
        getClientByIdUseCase: Get.find(),
        createClientUseCase: Get.find(),
        updateClientUseCase: Get.find(),
      ),
    );
  }
}
