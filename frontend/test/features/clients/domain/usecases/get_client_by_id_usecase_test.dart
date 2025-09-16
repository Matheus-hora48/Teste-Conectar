import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/clients/domain/usecases/get_client_by_id_usecase.dart';
import 'package:frontend/features/clients/domain/repositories/client_repository.dart';
import 'package:frontend/features/clients/domain/models/client.dart';

class MockClientRepository extends Mock implements ClientRepository {}

void main() {
  late GetClientByIdUseCase getClientByIdUseCase;
  late MockClientRepository mockClientRepository;

  setUp(() {
    mockClientRepository = MockClientRepository();
    getClientByIdUseCase = GetClientByIdUseCase(mockClientRepository);
  });

  group('GetClientByIdUseCase Tests', () {
    final testClient = Client(
      id: 1,
      storeFrontName: 'Loja Teste',
      cnpj: '12.345.678/0001-99',
      companyName: 'Empresa Teste LTDA',
      cep: '01000-000',
      street: 'Rua Teste',
      neighborhood: 'Centro',
      city: 'São Paulo',
      state: 'SP',
      number: '123',
      status: ClientStatus.ativo,
      phone: '(11) 99999-9999',
      email: 'teste@empresa.com',
      contactPerson: 'João Silva',
      assignedUserId: 1,
    );

    group('execute', () {
      test('deve retornar cliente por ID com sucesso', () async {
        // Arrange
        const clientId = 1;
        when(
          () => mockClientRepository.getClientById(clientId),
        ).thenAnswer((_) async => testClient);

        // Act
        final result = await getClientByIdUseCase.execute(clientId);

        // Assert
        expect(result, equals(testClient));
        expect(result.id, equals(1));
        expect(result.storeFrontName, equals('Loja Teste'));
        expect(result.cnpj, equals('12.345.678/0001-99'));
        expect(result.companyName, equals('Empresa Teste LTDA'));
        expect(result.email, equals('teste@empresa.com'));
        verify(() => mockClientRepository.getClientById(clientId)).called(1);
      });

      test('deve retornar cliente diferente para ID diferente', () async {
        // Arrange
        const clientId = 2;
        final differentClient = testClient.copyWith(
          id: 2,
          storeFrontName: 'Loja Diferente',
          cnpj: '98.765.432/0001-11',
          email: 'diferente@empresa.com',
        );

        when(
          () => mockClientRepository.getClientById(clientId),
        ).thenAnswer((_) async => differentClient);

        // Act
        final result = await getClientByIdUseCase.execute(clientId);

        // Assert
        expect(result, equals(differentClient));
        expect(result.id, equals(2));
        expect(result.storeFrontName, equals('Loja Diferente'));
        expect(result.cnpj, equals('98.765.432/0001-11'));
        expect(result.email, equals('diferente@empresa.com'));
        verify(() => mockClientRepository.getClientById(clientId)).called(1);
      });

      test(
        'deve propagar erro do repository para cliente não encontrado',
        () async {
          // Arrange
          const clientId = 999;
          when(
            () => mockClientRepository.getClientById(clientId),
          ).thenThrow(Exception('Cliente não encontrado'));

          // Act & Assert
          expect(
            () => getClientByIdUseCase.execute(clientId),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Cliente não encontrado'),
              ),
            ),
          );
          verify(() => mockClientRepository.getClientById(clientId)).called(1);
        },
      );

      test('deve propagar erro do repository para falha de acesso', () async {
        // Arrange
        const clientId = 1;
        when(() => mockClientRepository.getClientById(clientId)).thenThrow(
          Exception('Você não tem permissão para acessar este cliente'),
        );

        // Act & Assert
        expect(
          () => getClientByIdUseCase.execute(clientId),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('não tem permissão'),
            ),
          ),
        );
        verify(() => mockClientRepository.getClientById(clientId)).called(1);
      });

      test('deve propagar erro de conectividade', () async {
        // Arrange
        const clientId = 1;
        when(
          () => mockClientRepository.getClientById(clientId),
        ).thenThrow(Exception('Falha na conexão com o servidor'));

        // Act & Assert
        expect(
          () => getClientByIdUseCase.execute(clientId),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Falha na conexão'),
            ),
          ),
        );
        verify(() => mockClientRepository.getClientById(clientId)).called(1);
      });

      test('deve propagar erro genérico do repository', () async {
        // Arrange
        const clientId = 1;
        when(
          () => mockClientRepository.getClientById(clientId),
        ).thenThrow(Exception('Erro interno do servidor'));

        // Act & Assert
        expect(
          () => getClientByIdUseCase.execute(clientId),
          throwsA(isA<Exception>()),
        );
        verify(() => mockClientRepository.getClientById(clientId)).called(1);
      });

      test('deve buscar múltiplos clientes por diferentes IDs', () async {
        // Arrange
        final clients = [
          testClient,
          testClient.copyWith(id: 2, storeFrontName: 'Loja 2'),
          testClient.copyWith(id: 3, storeFrontName: 'Loja 3'),
        ];

        for (final client in clients) {
          when(
            () => mockClientRepository.getClientById(client.id!),
          ).thenAnswer((_) async => client);
        }

        // Act & Assert
        for (final expectedClient in clients) {
          final result = await getClientByIdUseCase.execute(expectedClient.id!);
          expect(result, equals(expectedClient));
          expect(result.id, equals(expectedClient.id));
          expect(result.storeFrontName, equals(expectedClient.storeFrontName));
        }

        // Verify all calls were made
        for (final client in clients) {
          verify(
            () => mockClientRepository.getClientById(client.id!),
          ).called(1);
        }
      });
    });
  });
}
