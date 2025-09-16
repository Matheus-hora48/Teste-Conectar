import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:frontend/features/clients/data/client_repository_impl.dart';
import 'package:frontend/core/network/api_service.dart';
import 'package:frontend/features/clients/domain/models/client.dart';
import 'package:frontend/core/constants/app_constants.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late ClientRepositoryImpl clientRepository;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    clientRepository = ClientRepositoryImpl(apiService: mockApiService);
  });

  group('ClientRepositoryImpl Tests', () {
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

    final testClientJson = {
      'id': 1,
      'storeFrontName': 'Loja Teste',
      'cnpj': '12.345.678/0001-99',
      'companyName': 'Empresa Teste LTDA',
      'cep': '01000-000',
      'street': 'Rua Teste',
      'neighborhood': 'Centro',
      'city': 'São Paulo',
      'state': 'SP',
      'number': '123',
      'status': 'Ativo',
      'phone': '(11) 99999-9999',
      'email': 'teste@empresa.com',
      'contactPerson': 'João Silva',
      'assignedUserId': 1,
    };

    final testClientsJson = [
      testClientJson,
      {
        'id': 2,
        'storeFrontName': 'Loja Teste 2',
        'cnpj': '98.765.432/0001-11',
        'companyName': 'Empresa Teste 2 LTDA',
        'cep': '01000-001',
        'street': 'Rua Teste 2',
        'neighborhood': 'Centro',
        'city': 'Rio de Janeiro',
        'state': 'RJ',
        'number': '456',
        'status': 'Ativo',
        'phone': '(21) 88888-8888',
        'email': 'teste2@empresa.com',
        'contactPerson': 'Maria Santos',
        'assignedUserId': 2,
      },
    ];

    group('getClients', () {
      test('deve retornar lista de clientes sem filtros', () async {
        // Arrange
        when(
          () => mockApiService.get(AppConstants.clients, queryParameters: {}),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: testClientsJson,
            statusCode: 200,
          ),
        );

        // Act
        final result = await clientRepository.getClients();

        // Assert
        expect(result, hasLength(2));
        expect(result[0].storeFrontName, equals('Loja Teste'));
        expect(result[1].storeFrontName, equals('Loja Teste 2'));
        verify(
          () => mockApiService.get(AppConstants.clients, queryParameters: {}),
        ).called(1);
      });

      test('deve retornar lista de clientes com filtro de nome', () async {
        // Arrange
        when(
          () => mockApiService.get(
            AppConstants.clients,
            queryParameters: {'name': 'Loja Teste'},
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: [testClientJson],
            statusCode: 200,
          ),
        );

        // Act
        final result = await clientRepository.getClients(name: 'Loja Teste');

        // Assert
        expect(result, hasLength(1));
        expect(result[0].storeFrontName, equals('Loja Teste'));
        verify(
          () => mockApiService.get(
            AppConstants.clients,
            queryParameters: {'name': 'Loja Teste'},
          ),
        ).called(1);
      });

      test('deve retornar lista de clientes com filtro de CNPJ', () async {
        // Arrange
        when(
          () => mockApiService.get(
            AppConstants.clients,
            queryParameters: {'cnpj': '12.345.678/0001-99'},
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: [testClientJson],
            statusCode: 200,
          ),
        );

        // Act
        final result = await clientRepository.getClients(
          cnpj: '12.345.678/0001-99',
        );

        // Assert
        expect(result, hasLength(1));
        expect(result[0].cnpj, equals('12.345.678/0001-99'));
        verify(
          () => mockApiService.get(
            AppConstants.clients,
            queryParameters: {'cnpj': '12.345.678/0001-99'},
          ),
        ).called(1);
      });

      test(
        'deve retornar lista de clientes com filtro de status ativo',
        () async {
          // Arrange
          when(
            () => mockApiService.get(
              AppConstants.clients,
              queryParameters: {'status': 'Ativo'},
            ),
          ).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: ''),
              data: testClientsJson,
              statusCode: 200,
            ),
          );

          // Act
          final result = await clientRepository.getClients(
            status: ClientStatus.ativo,
          );

          // Assert
          expect(result, hasLength(2));
          result.forEach((client) {
            expect(client.status, equals(ClientStatus.ativo));
          });
          verify(
            () => mockApiService.get(
              AppConstants.clients,
              queryParameters: {'status': 'Ativo'},
            ),
          ).called(1);
        },
      );

      test(
        'deve retornar lista de clientes com filtro de status inativo',
        () async {
          // Arrange
          when(
            () => mockApiService.get(
              AppConstants.clients,
              queryParameters: {'status': 'Inativo'},
            ),
          ).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: ''),
              data: [],
              statusCode: 200,
            ),
          );

          // Act
          final result = await clientRepository.getClients(
            status: ClientStatus.inativo,
          );

          // Assert
          expect(result, isEmpty);
          verify(
            () => mockApiService.get(
              AppConstants.clients,
              queryParameters: {'status': 'Inativo'},
            ),
          ).called(1);
        },
      );

      test(
        'deve retornar lista de clientes com filtro de status pendente',
        () async {
          // Arrange
          when(
            () => mockApiService.get(
              AppConstants.clients,
              queryParameters: {'status': 'Pendente'},
            ),
          ).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: ''),
              data: [],
              statusCode: 200,
            ),
          );

          // Act
          final result = await clientRepository.getClients(
            status: ClientStatus.pendente,
          );

          // Assert
          expect(result, isEmpty);
          verify(
            () => mockApiService.get(
              AppConstants.clients,
              queryParameters: {'status': 'Pendente'},
            ),
          ).called(1);
        },
      );

      test('deve retornar lista de clientes com filtro de cidade', () async {
        // Arrange
        when(
          () => mockApiService.get(
            AppConstants.clients,
            queryParameters: {'city': 'São Paulo'},
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: [testClientJson],
            statusCode: 200,
          ),
        );

        // Act
        final result = await clientRepository.getClients(cidade: 'São Paulo');

        // Assert
        expect(result, hasLength(1));
        expect(result[0].city, equals('São Paulo'));
        verify(
          () => mockApiService.get(
            AppConstants.clients,
            queryParameters: {'city': 'São Paulo'},
          ),
        ).called(1);
      });

      test('deve retornar lista de clientes com múltiplos filtros', () async {
        // Arrange
        when(
          () => mockApiService.get(
            AppConstants.clients,
            queryParameters: {
              'name': 'Loja Teste',
              'cnpj': '12.345.678/0001-99',
              'status': 'Ativo',
              'city': 'São Paulo',
            },
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: [testClientJson],
            statusCode: 200,
          ),
        );

        // Act
        final result = await clientRepository.getClients(
          name: 'Loja Teste',
          cnpj: '12.345.678/0001-99',
          status: ClientStatus.ativo,
          cidade: 'São Paulo',
        );

        // Assert
        expect(result, hasLength(1));
        expect(result[0].storeFrontName, equals('Loja Teste'));
        expect(result[0].cnpj, equals('12.345.678/0001-99'));
        expect(result[0].status, equals(ClientStatus.ativo));
        expect(result[0].city, equals('São Paulo'));
        verify(
          () => mockApiService.get(
            AppConstants.clients,
            queryParameters: {
              'name': 'Loja Teste',
              'cnpj': '12.345.678/0001-99',
              'status': 'Ativo',
              'city': 'São Paulo',
            },
          ),
        ).called(1);
      });

      test('deve ignorar filtros vazios', () async {
        // Arrange
        when(
          () => mockApiService.get(
            AppConstants.clients,
            queryParameters: {'name': 'Teste'},
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: [testClientJson],
            statusCode: 200,
          ),
        );

        // Act
        final result = await clientRepository.getClients(
          name: 'Teste',
          cnpj: '', // Should be ignored
          cidade: '', // Should be ignored
        );

        // Assert
        expect(result, hasLength(1));
        verify(
          () => mockApiService.get(
            AppConstants.clients,
            queryParameters: {'name': 'Teste'},
          ),
        ).called(1);
      });

      test('deve lançar exceção DioException quando API falha', () async {
        // Arrange
        when(
          () => mockApiService.get(
            AppConstants.clients,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            message: 'Network error',
          ),
        );

        // Act & Assert
        expect(
          () => clientRepository.getClients(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Erro ao buscar clientes'),
            ),
          ),
        );
      });

      test('deve lançar exceção genérica quando erro inesperado', () async {
        // Arrange
        when(
          () => mockApiService.get(
            AppConstants.clients,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(Exception('Unexpected error'));

        // Act & Assert
        expect(
          () => clientRepository.getClients(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Erro inesperado'),
            ),
          ),
        );
      });
    });

    group('getClientById', () {
      test('deve retornar cliente por ID', () async {
        // Arrange
        when(() => mockApiService.get('${AppConstants.clients}/1')).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: testClientJson,
            statusCode: 200,
          ),
        );

        // Act
        final result = await clientRepository.getClientById(1);

        // Assert
        expect(result.id, equals(1));
        expect(result.storeFrontName, equals('Loja Teste'));
        expect(result.cnpj, equals('12.345.678/0001-99'));
        verify(() => mockApiService.get('${AppConstants.clients}/1')).called(1);
      });

      test('deve lançar exceção quando cliente não encontrado', () async {
        // Arrange
        when(() => mockApiService.get('${AppConstants.clients}/999')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 404,
            ),
          ),
        );

        // Act & Assert
        expect(
          () => clientRepository.getClientById(999),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Cliente não encontrado'),
            ),
          ),
        );
      });

      test('deve lançar exceção DioException para outros erros HTTP', () async {
        // Arrange
        when(() => mockApiService.get('${AppConstants.clients}/1')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            message: 'Server error',
          ),
        );

        // Act & Assert
        expect(
          () => clientRepository.getClientById(1),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Erro ao buscar cliente'),
            ),
          ),
        );
      });
    });

    group('createClient', () {
      test('deve criar cliente com sucesso', () async {
        // Arrange
        final clientToCreate = testClient.copyWith(id: null);
        when(
          () => mockApiService.post(
            AppConstants.clients,
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: testClientJson,
            statusCode: 201,
          ),
        );

        // Act
        final result = await clientRepository.createClient(clientToCreate);

        // Assert
        expect(result.id, equals(1));
        expect(result.storeFrontName, equals('Loja Teste'));
        expect(result.cnpj, equals('12.345.678/0001-99'));
        verify(
          () => mockApiService.post(
            AppConstants.clients,
            data: any(named: 'data'),
          ),
        ).called(1);
      });

      test('deve lançar exceção para dados inválidos', () async {
        // Arrange
        final clientToCreate = testClient.copyWith(id: null);
        when(
          () => mockApiService.post(
            AppConstants.clients,
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 400,
            ),
          ),
        );

        // Act & Assert
        expect(
          () => clientRepository.createClient(clientToCreate),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Dados inválidos para criação do cliente'),
            ),
          ),
        );
      });
    });

    group('updateClient', () {
      test('deve atualizar cliente com sucesso', () async {
        // Arrange
        final updatedClientJson = {
          ...testClientJson,
          'storeFrontName': 'Loja Atualizada',
        };
        final updatedClient = testClient.copyWith(
          storeFrontName: 'Loja Atualizada',
        );

        when(
          () => mockApiService.patch(
            '${AppConstants.clients}/1',
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: updatedClientJson,
            statusCode: 200,
          ),
        );

        // Act
        final result = await clientRepository.updateClient(updatedClient);

        // Assert
        expect(result.id, equals(1));
        expect(result.storeFrontName, equals('Loja Atualizada'));
        verify(
          () => mockApiService.patch(
            '${AppConstants.clients}/1',
            data: any(named: 'data'),
          ),
        ).called(1);
      });

      test('deve lançar exceção quando cliente não encontrado', () async {
        // Arrange
        when(
          () => mockApiService.patch(
            '${AppConstants.clients}/999',
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 404,
            ),
          ),
        );

        // Act & Assert
        expect(
          () => clientRepository.updateClient(testClient.copyWith(id: 999)),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Cliente não encontrado'),
            ),
          ),
        );
      });

      test('deve lançar exceção para dados inválidos', () async {
        // Arrange
        when(
          () => mockApiService.patch(
            '${AppConstants.clients}/1',
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 400,
            ),
          ),
        );

        // Act & Assert
        expect(
          () => clientRepository.updateClient(testClient),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Dados inválidos para atualização do cliente'),
            ),
          ),
        );
      });
    });

    group('deleteClient', () {
      test('deve deletar cliente com sucesso', () async {
        // Arrange
        when(
          () => mockApiService.delete('${AppConstants.clients}/1'),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 204,
          ),
        );

        // Act
        await clientRepository.deleteClient(1);

        // Assert
        verify(
          () => mockApiService.delete('${AppConstants.clients}/1'),
        ).called(1);
      });

      test('deve lançar exceção quando cliente não encontrado', () async {
        // Arrange
        when(
          () => mockApiService.delete('${AppConstants.clients}/999'),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 404,
            ),
          ),
        );

        // Act & Assert
        expect(
          () => clientRepository.deleteClient(999),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Cliente não encontrado'),
            ),
          ),
        );
      });

      test('deve lançar exceção DioException para outros erros', () async {
        // Arrange
        when(
          () => mockApiService.delete('${AppConstants.clients}/1'),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            message: 'Server error',
          ),
        );

        // Act & Assert
        expect(
          () => clientRepository.deleteClient(1),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Erro ao excluir cliente'),
            ),
          ),
        );
      });
    });
  });
}
