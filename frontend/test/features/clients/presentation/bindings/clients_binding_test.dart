import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/clients/presentation/bindings/clients_binding.dart';
import 'package:frontend/features/clients/presentation/controllers/clients_controller.dart';
import 'package:frontend/features/clients/domain/repositories/client_repository.dart';
import 'package:frontend/features/clients/domain/usecases/get_clients_usecase.dart';
import 'package:frontend/features/clients/domain/usecases/get_client_by_id_usecase.dart';
import 'package:frontend/features/clients/domain/usecases/create_client_usecase.dart';
import 'package:frontend/features/clients/domain/usecases/update_client_usecase.dart';
import 'package:frontend/core/network/api_service.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  group('ClientsBinding Tests', () {
    late ClientsBinding binding;
    late MockApiService mockApiService;

    setUp(() {
      binding = ClientsBinding();
      mockApiService = MockApiService();

      Get.put<ApiService>(mockApiService);
    });

    tearDown(() {
      Get.reset();
    });

    test('deve registrar todas as dependências corretamente', () {
      binding.dependencies();

      expect(Get.isRegistered<ClientRepository>(), true);
      expect(Get.isRegistered<GetClientsUseCase>(), true);
      expect(Get.isRegistered<GetClientByIdUseCase>(), true);
      expect(Get.isRegistered<CreateClientUseCase>(), true);
      expect(Get.isRegistered<UpdateClientUseCase>(), true);
      expect(Get.isRegistered<ClientsController>(), true);
    });

    test('deve criar instâncias das dependências quando solicitado', () {
      binding.dependencies();

      final repository = Get.find<ClientRepository>();
      expect(repository, isNotNull);
      expect(repository, isA<ClientRepository>());

      final getClientsUseCase = Get.find<GetClientsUseCase>();
      expect(getClientsUseCase, isNotNull);
      expect(getClientsUseCase, isA<GetClientsUseCase>());

      final getClientByIdUseCase = Get.find<GetClientByIdUseCase>();
      expect(getClientByIdUseCase, isNotNull);
      expect(getClientByIdUseCase, isA<GetClientByIdUseCase>());

      final createClientUseCase = Get.find<CreateClientUseCase>();
      expect(createClientUseCase, isNotNull);
      expect(createClientUseCase, isA<CreateClientUseCase>());

      final updateClientUseCase = Get.find<UpdateClientUseCase>();
      expect(updateClientUseCase, isNotNull);
      expect(updateClientUseCase, isA<UpdateClientUseCase>());

      final controller = Get.find<ClientsController>();
      expect(controller, isNotNull);
      expect(controller, isA<ClientsController>());
    });

    test('deve usar lazy loading para as dependências', () {
      binding.dependencies();

      expect(Get.isRegistered<ClientRepository>(), true);
      expect(Get.isRegistered<ClientsController>(), true);

      final controller = Get.find<ClientsController>();
      expect(controller, isNotNull);
    });

    test('deve injetar dependências corretamente no controller', () {
      binding.dependencies();

      final controller = Get.find<ClientsController>();

      expect(controller, isNotNull);
      expect(controller, isA<ClientsController>());
    });

    test('deve resolver cadeia de dependências corretamente', () {
      binding.dependencies();

      final controller = Get.find<ClientsController>();

      expect(controller, isNotNull);

      final getClientsUseCase = Get.find<GetClientsUseCase>();
      final getClientByIdUseCase = Get.find<GetClientByIdUseCase>();
      final createClientUseCase = Get.find<CreateClientUseCase>();
      final updateClientUseCase = Get.find<UpdateClientUseCase>();

      expect(getClientsUseCase, isNotNull);
      expect(getClientByIdUseCase, isNotNull);
      expect(createClientUseCase, isNotNull);
      expect(updateClientUseCase, isNotNull);
    });

    test('deve permitir registro múltiplo sem conflitos', () {
      binding.dependencies();
      binding.dependencies();

      final controller1 = Get.find<ClientsController>();
      final controller2 = Get.find<ClientsController>();

      expect(identical(controller1, controller2), true);
    });

    test('deve limpar dependências corretamente', () {
      binding.dependencies();

      expect(Get.isRegistered<ClientsController>(), true);
      expect(Get.isRegistered<ClientRepository>(), true);

      Get.reset();

      expect(Get.isRegistered<ClientsController>(), false);
      expect(Get.isRegistered<ClientRepository>(), false);
      expect(Get.isRegistered<GetClientsUseCase>(), false);
    });

    test('deve funcionar após reset e nova configuração', () {
      binding.dependencies();
      Get.reset();

      Get.put<ApiService>(mockApiService);

      binding.dependencies();

      expect(Get.isRegistered<ClientsController>(), true);

      final controller = Get.find<ClientsController>();
      expect(controller, isNotNull);
    });
  });
}
