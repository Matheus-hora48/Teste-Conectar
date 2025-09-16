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
    const Client(
      id: 2,
      storeFrontName: 'Loja XYZ',
      cnpj: '44.555.666/0001-99',
      companyName: 'XYZ Empresas SA',
      cep: '98765-432',
      street: 'Av XYZ',
      neighborhood: 'Industrial',
      city: 'Rio de Janeiro',
      state: 'RJ',
      number: '200',
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
    group('loadClients', () {
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
        verify(
          () => mockGetClientsUseCase.execute(
            name: null,
            cnpj: null,
            status: null,
            cidade: null,
          ),
        ).called(1);
      });

      test('deve aplicar filtros ao carregar clientes', () async {
        const cnpjFilter = '11.222.333/0001-81';
        const nameFilter = 'ABC';
        const statusFilter = ClientStatus.ativo;

        controller.setCnpjFilter(cnpjFilter);
        controller.setNameFilter(nameFilter);
        controller.setStatusFilter(statusFilter);

        when(
          () => mockGetClientsUseCase.execute(
            cnpj: any(named: 'cnpj'),
            name: any(named: 'name'),
            status: any(named: 'status'),
            cidade: any(named: 'cidade'),
          ),
        ).thenAnswer((_) async => [testClient]);

        await controller.loadClients();

        verify(
          () => mockGetClientsUseCase.execute(
            cnpj: cnpjFilter,
            name: nameFilter,
            status: statusFilter,
            cidade: null,
          ),
        ).called(1);
      });

      test('deve lidar com erro ao carregar clientes', () async {
        when(
          () => mockGetClientsUseCase.execute(
            cnpj: any(named: 'cnpj'),
            name: any(named: 'name'),
            status: any(named: 'status'),
            cidade: any(named: 'cidade'),
          ),
        ).thenThrow(Exception('Erro ao buscar clientes'));

        await controller.loadClients();

        expect(controller.clients, isEmpty);
        expect(controller.isLoading, isFalse);
      });
    });

    group('loadClientById', () {
      test('deve carregar cliente por ID com sucesso', () async {
        when(
          () => mockGetClientByIdUseCase.execute(any()),
        ).thenAnswer((_) async => testClient);

        await controller.loadClientById(1);

        expect(controller.selectedClient, equals(testClient));
        verify(() => mockGetClientByIdUseCase.execute(1)).called(1);
      });

      test('deve lidar com erro ao carregar cliente por ID', () async {
        when(
          () => mockGetClientByIdUseCase.execute(any()),
        ).thenThrow(Exception('Cliente não encontrado'));

        await controller.loadClientById(1);

        expect(controller.selectedClient, isNull);
        expect(controller.isLoadingForm, isFalse);
      });
    });

    group('createClient', () {
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
        ).thenThrow(Exception('Erro ao criar cliente'));

        final result = await controller.createClient(testClient);

        expect(result, isFalse);
        verify(() => mockCreateClientUseCase.execute(testClient)).called(1);
      });
    });

    group('updateClient', () {
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
        ).thenThrow(Exception('Erro ao atualizar cliente'));

        final result = await controller.updateClient(testClient);

        expect(result, isFalse);
        verify(() => mockUpdateClientUseCase.execute(testClient)).called(1);
      });
    });

    group('Filter Management', () {
      test('deve aplicar filtro de CNPJ', () {
        controller.setCnpjFilter('11.222.333/0001-81');

        expect(controller.cnpjFilter, equals('11.222.333/0001-81'));
      });

      test('deve aplicar filtro de nome', () {
        controller.setNameFilter('ABC');

        expect(controller.nameFilter, equals('ABC'));
      });

      test('deve aplicar filtro de status', () {
        controller.setStatusFilter(ClientStatus.ativo);

        expect(controller.statusFilter, equals(ClientStatus.ativo));
      });

      test('deve aplicar filtro de cidade', () {
        controller.setCidadeFilter('São Paulo');

        expect(controller.cidadeFilter, equals('São Paulo'));
      });

      test('deve limpar todos os filtros', () {
        controller.setCnpjFilter('11.222.333/0001-81');
        controller.setNameFilter('ABC');
        controller.setStatusFilter(ClientStatus.ativo);
        controller.setCidadeFilter('São Paulo');

        controller.clearFilters();

        expect(controller.cnpjFilter, isEmpty);
        expect(controller.nameFilter, isEmpty);
        expect(controller.statusFilter, isNull);
        expect(controller.cidadeFilter, isEmpty);
      });
    });

    group('Loading State', () {
      test('deve definir loading como true durante loadClients', () async {
        when(
          () => mockGetClientsUseCase.execute(
            cnpj: any(named: 'cnpj'),
            name: any(named: 'name'),
            status: any(named: 'status'),
            cidade: any(named: 'cidade'),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 10));
          return testClients;
        });

        final future = controller.loadClients();
        expect(controller.isLoading, isTrue);
        await future;

        expect(controller.isLoading, isFalse);
      });

      test(
        'deve definir isLoadingForm como true durante createClient',
        () async {
          when(() => mockCreateClientUseCase.execute(any())).thenAnswer((
            _,
          ) async {
            await Future.delayed(const Duration(milliseconds: 10));
            return testClient;
          });

          final future = controller.createClient(testClient);
          expect(controller.isLoadingForm, isTrue);
          await future;

          expect(controller.isLoadingForm, isFalse);
        },
      );

      test(
        'deve definir isLoadingForm como true durante updateClient',
        () async {
          when(() => mockUpdateClientUseCase.execute(any())).thenAnswer((
            _,
          ) async {
            await Future.delayed(const Duration(milliseconds: 10));
            return testClient;
          });

          final future = controller.updateClient(testClient);
          expect(controller.isLoadingForm, isTrue);
          await future;

          expect(controller.isLoadingForm, isFalse);
        },
      );

      test(
        'deve definir isLoadingForm como true durante loadClientById',
        () async {
          when(() => mockGetClientByIdUseCase.execute(any())).thenAnswer((
            _,
          ) async {
            await Future.delayed(const Duration(milliseconds: 10));
            return testClient;
          });

          final future = controller.loadClientById(1);
          expect(controller.isLoadingForm, isTrue);
          await future;

          expect(controller.isLoadingForm, isFalse);
        },
      );
    });

    group('Client Management', () {
      test('deve limpar cliente selecionado', () {
        controller.loadClientById(1);

        controller.clearSelectedClient();

        expect(controller.selectedClient, isNull);
      });

      test('deve aplicar filtros e recarregar clientes', () async {
        when(
          () => mockGetClientsUseCase.execute(
            name: any(named: 'name'),
            cnpj: any(named: 'cnpj'),
            status: any(named: 'status'),
            cidade: any(named: 'cidade'),
          ),
        ).thenAnswer((_) async => testClients);

        controller.setNameFilter('ABC');

        controller.applyFilters();
        await Future.delayed(const Duration(milliseconds: 50));

        verify(
          () => mockGetClientsUseCase.execute(
            name: 'ABC',
            cnpj: null,
            status: null,
            cidade: null,
          ),
        ).called(1);
      });
    });
  });
}
