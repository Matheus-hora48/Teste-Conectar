import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/clients/domain/usecases/get_clients_usecase.dart';
import 'package:frontend/features/clients/domain/repositories/client_repository.dart';
import 'package:frontend/features/clients/domain/models/client.dart';

class MockClientRepository extends Mock implements ClientRepository {}

void main() {
  late GetClientsUseCase useCase;
  late MockClientRepository mockRepository;

  setUp(() {
    mockRepository = MockClientRepository();
    useCase = GetClientsUseCase(mockRepository);
  });

  group('GetClientsUseCase Tests', () {
    final testClients = [
      Client(
        id: 1,
        storeFrontName: 'Loja Teste 1',
        cnpj: '12.345.678/0001-99',
        companyName: 'Empresa Teste 1 LTDA',
        status: ClientStatus.ativo,
        phone: '(11) 99999-9999',
        email: 'teste1@empresa.com',
        contactPerson: 'João Silva',
        cep: '01000-000',
        street: 'Rua Teste',
        neighborhood: 'Centro',
        city: 'São Paulo',
        state: 'SP',
        number: '123',
      ),
      Client(
        id: 2,
        storeFrontName: 'Loja Teste 2',
        cnpj: '98.765.432/0001-11',
        companyName: 'Empresa Teste 2 LTDA',
        status: ClientStatus.inativo,
        phone: '(21) 88888-8888',
        email: 'teste2@empresa.com',
        contactPerson: 'Maria Santos',
        cep: '20000-000',
        street: 'Rua Exemplo',
        neighborhood: 'Copacabana',
        city: 'Rio de Janeiro',
        state: 'RJ',
        number: '456',
      ),
    ];

    test('deve retornar lista de clientes sem filtros', () async {
      // Arrange
      when(
        () => mockRepository.getClients(),
      ).thenAnswer((_) async => testClients);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, equals(testClients));
      expect(result.length, 2);
      verify(() => mockRepository.getClients()).called(1);
    });

    test('deve retornar lista de clientes com filtro de nome', () async {
      // Arrange
      final filteredClients = [testClients.first];
      when(
        () => mockRepository.getClients(name: 'Loja Teste 1'),
      ).thenAnswer((_) async => filteredClients);

      // Act
      final result = await useCase.execute(name: 'Loja Teste 1');

      // Assert
      expect(result, equals(filteredClients));
      expect(result.length, 1);
      expect(result.first.storeFrontName, 'Loja Teste 1');
      verify(() => mockRepository.getClients(name: 'Loja Teste 1')).called(1);
    });

    test('deve retornar lista de clientes com filtro de CNPJ', () async {
      // Arrange
      final filteredClients = [testClients.first];
      when(
        () => mockRepository.getClients(cnpj: '12.345.678/0001-99'),
      ).thenAnswer((_) async => filteredClients);

      // Act
      final result = await useCase.execute(cnpj: '12.345.678/0001-99');

      // Assert
      expect(result, equals(filteredClients));
      expect(result.length, 1);
      expect(result.first.cnpj, '12.345.678/0001-99');
      verify(
        () => mockRepository.getClients(cnpj: '12.345.678/0001-99'),
      ).called(1);
    });

    test('deve retornar lista de clientes com filtro de status', () async {
      // Arrange
      final activeClients = [testClients.first];
      when(
        () => mockRepository.getClients(status: ClientStatus.ativo),
      ).thenAnswer((_) async => activeClients);

      // Act
      final result = await useCase.execute(status: ClientStatus.ativo);

      // Assert
      expect(result, equals(activeClients));
      expect(result.length, 1);
      expect(result.first.status, ClientStatus.ativo);
      verify(
        () => mockRepository.getClients(status: ClientStatus.ativo),
      ).called(1);
    });

    test('deve retornar lista de clientes com filtro de cidade', () async {
      // Arrange
      final spClients = [testClients.first];
      when(
        () => mockRepository.getClients(cidade: 'São Paulo'),
      ).thenAnswer((_) async => spClients);

      // Act
      final result = await useCase.execute(cidade: 'São Paulo');

      // Assert
      expect(result, equals(spClients));
      expect(result.length, 1);
      expect(result.first.city, 'São Paulo');
      verify(() => mockRepository.getClients(cidade: 'São Paulo')).called(1);
    });

    test('deve retornar lista de clientes com múltiplos filtros', () async {
      // Arrange
      final filteredClients = [testClients.first];
      when(
        () => mockRepository.getClients(
          name: 'Loja Teste 1',
          cnpj: '12.345.678/0001-99',
          status: ClientStatus.ativo,
          cidade: 'São Paulo',
        ),
      ).thenAnswer((_) async => filteredClients);

      // Act
      final result = await useCase.execute(
        name: 'Loja Teste 1',
        cnpj: '12.345.678/0001-99',
        status: ClientStatus.ativo,
        cidade: 'São Paulo',
      );

      // Assert
      expect(result, equals(filteredClients));
      expect(result.length, 1);
      verify(
        () => mockRepository.getClients(
          name: 'Loja Teste 1',
          cnpj: '12.345.678/0001-99',
          status: ClientStatus.ativo,
          cidade: 'São Paulo',
        ),
      ).called(1);
    });

    test('deve retornar lista vazia quando não há clientes', () async {
      // Arrange
      when(() => mockRepository.getClients()).thenAnswer((_) async => []);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getClients()).called(1);
    });

    test('deve propagar exceção do repository', () async {
      // Arrange
      when(
        () => mockRepository.getClients(),
      ).thenThrow(Exception('Erro de rede'));

      // Act & Assert
      expect(() => useCase.execute(), throwsA(isA<Exception>()));
      verify(() => mockRepository.getClients()).called(1);
    });
  });
}
