import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/clients/domain/models/client.dart';
import 'package:frontend/features/clients/domain/usecases/get_clients_usecase.dart';
import 'package:frontend/features/clients/domain/usecases/get_client_by_id_usecase.dart';
import 'package:frontend/features/clients/domain/usecases/create_client_usecase.dart';
import 'package:frontend/features/clients/domain/usecases/update_client_usecase.dart';
import 'package:frontend/features/clients/presentation/controllers/clients_controller.dart';

class MockGetClientsUseCase extends Mock implements GetClientsUseCase {}

class MockGetClientByIdUseCase extends Mock implements GetClientByIdUseCase {}

class MockCreateClientUseCase extends Mock implements CreateClientUseCase {}

class MockUpdateClientUseCase extends Mock implements UpdateClientUseCase {}

void main() {
  late ClientsController controller;
  late MockGetClientsUseCase mockGetClientsUseCase;
  late MockGetClientByIdUseCase mockGetClientByIdUseCase;
  late MockCreateClientUseCase mockCreateClientUseCase;
  late MockUpdateClientUseCase mockUpdateClientUseCase;

  final testClients = [
    const Client(
      id: 1,
      storeFrontName: 'Loja ABC',
      cnpj: '11.222.333/0001-81',
      companyName: 'ABC Comércio LTDA',
      cep: '01234-567',
      street: 'Rua ABC',
      neighborhood: 'Centro',
      city: 'São Paulo',
      state: 'SP',
      number: '100',
      status: ClientStatus.ativo,
    ),
  ];

  final testClient = testClients.first;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(
      const Client(
        id: 0,
        storeFrontName: 'Fallback',
        cnpj: '00.000.000/0000-00',
        companyName: 'Fallback Company',
        cep: '00000-000',
        street: 'Fallback Street',
        neighborhood: 'Fallback',
        city: 'Fallback',
        state: 'SP',
        number: '0',
        status: ClientStatus.ativo,
      ),
    );
  });

  setUp(() {
    mockGetClientsUseCase = MockGetClientsUseCase();
    mockGetClientByIdUseCase = MockGetClientByIdUseCase();
    mockCreateClientUseCase = MockCreateClientUseCase();
    mockUpdateClientUseCase = MockUpdateClientUseCase();

    controller = ClientsController(
      getClientsUseCase: mockGetClientsUseCase,
      getClientByIdUseCase: mockGetClientByIdUseCase,
      createClientUseCase: mockCreateClientUseCase,
      updateClientUseCase: mockUpdateClientUseCase,
    );
  });

  tearDown(() {
    controller.dispose();
  });

  group('ClientsController Tests', () {
    test('deve carregar clientes com sucesso', () async {
      when(
        () => mockGetClientsUseCase.execute(
          name: any(named: 'name'),
          cnpj: any(named: 'cnpj'),
          status: any(named: 'status'),
          cidade: any(named: 'cidade'),
        ),
      ).thenAnswer((_) async => testClients);

      await controller.loadClients();

      expect(controller.clients, equals(testClients));
      expect(controller.isLoading, isFalse);
    });

    test('deve aplicar filtros', () {
      controller.setNameFilter('ABC');
      controller.setCnpjFilter('11.222.333/0001-81');
      controller.setStatusFilter(ClientStatus.ativo);
      controller.setCidadeFilter('São Paulo');

      expect(controller.nameFilter, equals('ABC'));
      expect(controller.cnpjFilter, equals('11.222.333/0001-81'));
      expect(controller.statusFilter, equals(ClientStatus.ativo));
      expect(controller.cidadeFilter, equals('São Paulo'));
    });

    test('deve limpar filtros', () {
      controller.setNameFilter('ABC');
      controller.setCnpjFilter('11.222.333/0001-81');
      controller.setStatusFilter(ClientStatus.ativo);

      controller.clearFilters();

      expect(controller.nameFilter, isEmpty);
      expect(controller.cnpjFilter, isEmpty);
      expect(controller.statusFilter, isNull);
      expect(controller.cidadeFilter, isEmpty);
    });

    test('deve carregar cliente por ID com sucesso', () async {
      when(
        () => mockGetClientByIdUseCase.execute(any()),
      ).thenAnswer((_) async => testClient);

      await controller.loadClientById(1);

      expect(controller.selectedClient, equals(testClient));
    });

    test('deve criar cliente com sucesso', () async {
      when(
        () => mockCreateClientUseCase.execute(any()),
      ).thenAnswer((_) async => testClient);

      final result = await controller.createClient(testClient);

      expect(result, isTrue);
      verify(() => mockCreateClientUseCase.execute(testClient)).called(1);
    });

    test('deve retornar false quando criação falha', () async {
      when(
        () => mockCreateClientUseCase.execute(any()),
      ).thenThrow(Exception('Erro'));

      final result = await controller.createClient(testClient);

      expect(result, isFalse);
    });

    test('deve atualizar cliente com sucesso', () async {
      when(
        () => mockUpdateClientUseCase.execute(any()),
      ).thenAnswer((_) async => testClient);

      final result = await controller.updateClient(testClient);

      expect(result, isTrue);
      verify(() => mockUpdateClientUseCase.execute(testClient)).called(1);
    });

    test('deve retornar false quando atualização falha', () async {
      when(
        () => mockUpdateClientUseCase.execute(any()),
      ).thenThrow(Exception('Erro'));

      final result = await controller.updateClient(testClient);

      expect(result, isFalse);
    });

    test('deve limpar cliente selecionado', () {
      controller.loadClientById(1);

      controller.clearSelectedClient();

      expect(controller.selectedClient, isNull);
    });
  });
}
