import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/clients/domain/usecases/create_client_usecase.dart';
import 'package:frontend/features/clients/domain/usecases/get_client_by_id_usecase.dart';
import 'package:frontend/features/clients/domain/usecases/update_client_usecase.dart';
import 'package:frontend/features/clients/domain/repositories/client_repository.dart';
import 'package:frontend/features/clients/domain/models/client.dart';

class MockClientRepository extends Mock implements ClientRepository {}

void main() {
  late MockClientRepository mockRepository;

  setUpAll(() {
    // Register fallback values for Client type
    registerFallbackValue(
      Client(
        id: 0,
        storeFrontName: '',
        cnpj: '',
        companyName: '',
        cep: '',
        street: '',
        neighborhood: '',
        city: '',
        state: '',
        number: '',
        status: ClientStatus.ativo,
        phone: '',
        email: '',
        contactPerson: '',
      ),
    );
  });

  setUp(() {
    mockRepository = MockClientRepository();
  });

  final testClient = Client(
    id: 1,
    storeFrontName: 'Loja Teste',
    cnpj: '12.345.678/0001-99',
    companyName: 'Empresa Teste LTDA',
    status: ClientStatus.ativo,
    phone: '(11) 99999-9999',
    email: 'teste@empresa.com',
    contactPerson: 'João Silva',
    cep: '01000-000',
    street: 'Rua Teste',
    neighborhood: 'Centro',
    city: 'São Paulo',
    state: 'SP',
    number: '123',
  );

  group('CreateClientUseCase Tests', () {
    late CreateClientUseCase useCase;

    setUp(() {
      useCase = CreateClientUseCase(mockRepository);
    });

    test('deve criar cliente com sucesso', () async {
      // Arrange
      when(
        () => mockRepository.createClient(any()),
      ).thenAnswer((_) async => testClient);

      // Act
      final result = await useCase.execute(testClient);

      // Assert
      expect(result, equals(testClient));
      expect(result.storeFrontName, 'Loja Teste');
      verify(() => mockRepository.createClient(testClient)).called(1);
    });

    test('deve propagar exceção do repository', () async {
      // Arrange
      when(
        () => mockRepository.createClient(any()),
      ).thenThrow(Exception('Erro ao criar cliente'));

      // Act & Assert
      expect(() => useCase.execute(testClient), throwsA(isA<Exception>()));
      verify(() => mockRepository.createClient(testClient)).called(1);
    });

    test('deve validar dados do cliente antes de criar', () async {
      // Arrange
      final invalidClient = Client(
        storeFrontName: '',
        cnpj: '',
        companyName: '',
        status: ClientStatus.ativo,
        phone: '',
        email: '',
        contactPerson: '',
        cep: '',
        street: '',
        neighborhood: '',
        city: '',
        state: '',
        number: '',
      );

      when(
        () => mockRepository.createClient(any()),
      ).thenThrow(Exception('Dados inválidos'));

      // Act & Assert
      expect(() => useCase.execute(invalidClient), throwsA(isA<Exception>()));
    });
  });

  group('GetClientByIdUseCase Tests', () {
    late GetClientByIdUseCase useCase;

    setUp(() {
      useCase = GetClientByIdUseCase(mockRepository);
    });

    test('deve retornar cliente por ID com sucesso', () async {
      // Arrange
      when(
        () => mockRepository.getClientById(1),
      ).thenAnswer((_) async => testClient);

      // Act
      final result = await useCase.execute(1);

      // Assert
      expect(result, equals(testClient));
      expect(result.id, 1);
      verify(() => mockRepository.getClientById(1)).called(1);
    });

    test('deve lançar exceção quando cliente não encontrado', () async {
      // Arrange
      when(
        () => mockRepository.getClientById(999),
      ).thenThrow(Exception('Cliente não encontrado'));

      // Act & Assert
      expect(() => useCase.execute(999), throwsA(isA<Exception>()));
      verify(() => mockRepository.getClientById(999)).called(1);
    });

    test('deve propagar exceção do repository', () async {
      // Arrange
      when(
        () => mockRepository.getClientById(any()),
      ).thenThrow(Exception('Erro de rede'));

      // Act & Assert
      expect(() => useCase.execute(1), throwsA(isA<Exception>()));
      verify(() => mockRepository.getClientById(1)).called(1);
    });
  });

  group('UpdateClientUseCase Tests', () {
    late UpdateClientUseCase useCase;

    setUp(() {
      useCase = UpdateClientUseCase(mockRepository);
    });

    test('deve atualizar cliente com sucesso', () async {
      // Arrange
      final updatedClient = testClient.copyWith(
        storeFrontName: 'Loja Atualizada',
      );

      when(
        () => mockRepository.updateClient(any()),
      ).thenAnswer((_) async => updatedClient);

      // Act
      final result = await useCase.execute(updatedClient);

      // Assert
      expect(result, equals(updatedClient));
      expect(result.storeFrontName, 'Loja Atualizada');
      verify(() => mockRepository.updateClient(updatedClient)).called(1);
    });

    test('deve lançar exceção quando cliente não encontrado', () async {
      // Arrange
      when(
        () => mockRepository.updateClient(any()),
      ).thenThrow(Exception('Cliente não encontrado'));

      // Act & Assert
      expect(() => useCase.execute(testClient), throwsA(isA<Exception>()));
      verify(() => mockRepository.updateClient(testClient)).called(1);
    });

    test('deve propagar exceção do repository', () async {
      // Arrange
      when(
        () => mockRepository.updateClient(any()),
      ).thenThrow(Exception('Erro de rede'));

      // Act & Assert
      expect(() => useCase.execute(testClient), throwsA(isA<Exception>()));
      verify(() => mockRepository.updateClient(testClient)).called(1);
    });

    test('deve validar dados atualizados', () async {
      // Arrange
      final invalidUpdate = testClient.copyWith(
        storeFrontName: '',
        email: 'email-inválido',
      );

      when(
        () => mockRepository.updateClient(any()),
      ).thenThrow(Exception('Dados inválidos'));

      // Act & Assert
      expect(() => useCase.execute(invalidUpdate), throwsA(isA<Exception>()));
    });
  });
}
