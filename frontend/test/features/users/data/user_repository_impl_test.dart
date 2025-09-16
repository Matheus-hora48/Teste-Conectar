import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:frontend/features/users/data/user_repository_impl.dart';
import 'package:frontend/core/network/api_service.dart';
import 'package:frontend/features/users/domain/models/user_model.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late UserRepositoryImpl userRepository;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    userRepository = UserRepositoryImpl(mockApiService);
  });

  group('UserRepositoryImpl Tests', () {
    final testUser = UserModel(
      id: 1,
      name: 'Test User',
      email: 'test@example.com',
      role: UserRole.user,
      status: UserStatus.ativo,
      phone: '11999999999',
      department: 'IT',
    );

    final testUserJson = {
      'id': 1,
      'name': 'Test User',
      'email': 'test@example.com',
      'role': 'user',
      'status': 'ativo',
      'phone': '11999999999',
      'department': 'IT',
    };

    final testUsersJson = [
      testUserJson,
      {
        'id': 2,
        'name': 'Test User 2',
        'email': 'test2@example.com',
        'role': 'admin',
        'status': 'ativo',
      },
    ];

    group('getUsers', () {
      test('deve retornar lista de usuários sem filtros', () async {
        when(
          () => mockApiService.get('/users', queryParameters: {}),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: testUsersJson,
            statusCode: 200,
          ),
        );

        final result = await userRepository.getUsers();

        expect(result, hasLength(2));
        expect(result[0].name, equals('Test User'));
        expect(result[1].name, equals('Test User 2'));
        verify(
          () => mockApiService.get('/users', queryParameters: {}),
        ).called(1);
      });

      test('deve retornar lista de usuários com filtro de nome', () async {
        when(
          () => mockApiService.get(
            '/users',
            queryParameters: {'name': 'Test User'},
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: [testUserJson],
            statusCode: 200,
          ),
        );

        final result = await userRepository.getUsers(name: 'Test User');

        expect(result, hasLength(1));
        expect(result[0].name, equals('Test User'));
        verify(
          () => mockApiService.get(
            '/users',
            queryParameters: {'name': 'Test User'},
          ),
        ).called(1);
      });

      test('deve retornar lista de usuários com filtro de email', () async {
        when(
          () => mockApiService.get(
            '/users',
            queryParameters: {'email': 'test@example.com'},
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: [testUserJson],
            statusCode: 200,
          ),
        );

        final result = await userRepository.getUsers(email: 'test@example.com');

        expect(result, hasLength(1));
        expect(result[0].email, equals('test@example.com'));
        verify(
          () => mockApiService.get(
            '/users',
            queryParameters: {'email': 'test@example.com'},
          ),
        ).called(1);
      });

      test('deve retornar lista de usuários com filtro de status', () async {
        when(
          () => mockApiService.get(
            '/users',
            queryParameters: {'status': 'ativo'},
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: testUsersJson,
            statusCode: 200,
          ),
        );

        final result = await userRepository.getUsers(status: UserStatus.ativo);

        expect(result, hasLength(2));
        result.forEach((user) {
          expect(user.status, equals(UserStatus.ativo));
        });
        verify(
          () => mockApiService.get(
            '/users',
            queryParameters: {'status': 'ativo'},
          ),
        ).called(1);
      });

      test('deve retornar lista de usuários com filtro de role', () async {
        when(
          () =>
              mockApiService.get('/users', queryParameters: {'role': 'admin'}),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: [testUsersJson[1]],
            statusCode: 200,
          ),
        );

        final result = await userRepository.getUsers(role: UserRole.admin);

        expect(result, hasLength(1));
        expect(result[0].role, equals(UserRole.admin));
        verify(
          () =>
              mockApiService.get('/users', queryParameters: {'role': 'admin'}),
        ).called(1);
      });

      test('deve retornar lista de usuários com múltiplos filtros', () async {
        when(
          () => mockApiService.get(
            '/users',
            queryParameters: {
              'name': 'Test User',
              'email': 'test@example.com',
              'status': 'ativo',
              'role': 'user',
            },
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: [testUserJson],
            statusCode: 200,
          ),
        );

        final result = await userRepository.getUsers(
          name: 'Test User',
          email: 'test@example.com',
          status: UserStatus.ativo,
          role: UserRole.user,
        );

        expect(result, hasLength(1));
        expect(result[0].name, equals('Test User'));
        expect(result[0].email, equals('test@example.com'));
        expect(result[0].status, equals(UserStatus.ativo));
        expect(result[0].role, equals(UserRole.user));
        verify(
          () => mockApiService.get(
            '/users',
            queryParameters: {
              'name': 'Test User',
              'email': 'test@example.com',
              'status': 'ativo',
              'role': 'user',
            },
          ),
        ).called(1);
      });

      test('deve ignorar filtros vazios', () async {
        when(
          () => mockApiService.get('/users', queryParameters: {'name': 'Test'}),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: [testUserJson],
            statusCode: 200,
          ),
        );

        final result = await userRepository.getUsers(name: 'Test', email: '');

        expect(result, hasLength(1));
        verify(
          () => mockApiService.get('/users', queryParameters: {'name': 'Test'}),
        ).called(1);
      });

      test('deve lançar exceção quando API falha', () async {
        when(
          () => mockApiService.get(
            '/users',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(Exception('Network error'));

        expect(
          () => userRepository.getUsers(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Erro ao buscar usuários'),
            ),
          ),
        );
      });
    });

    group('getUserById', () {
      test('deve retornar usuário por ID', () async {
        when(() => mockApiService.get('/users/1')).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: testUserJson,
            statusCode: 200,
          ),
        );

        final result = await userRepository.getUserById(1);

        expect(result.id, equals(1));
        expect(result.name, equals('Test User'));
        expect(result.email, equals('test@example.com'));
        verify(() => mockApiService.get('/users/1')).called(1);
      });

      test('deve lançar exceção quando usuário não encontrado', () async {
        when(
          () => mockApiService.get('/users/999'),
        ).thenThrow(Exception('User not found'));

        expect(
          () => userRepository.getUserById(999),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Erro ao buscar usuário'),
            ),
          ),
        );
      });
    });

    group('createUser', () {
      test('deve criar usuário com sucesso', () async {
        final userToCreate = testUser.copyWith(id: 0);
        when(
          () => mockApiService.post('/users', data: any(named: 'data')),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: testUserJson,
            statusCode: 201,
          ),
        );

        final result = await userRepository.createUser(userToCreate);

        expect(result.id, equals(1));
        expect(result.name, equals('Test User'));
        expect(result.email, equals('test@example.com'));
        verify(
          () => mockApiService.post('/users', data: any(named: 'data')),
        ).called(1);
      });

      test('deve lançar exceção quando criação falha', () async {
        final userToCreate = testUser.copyWith(id: 0);
        when(
          () => mockApiService.post('/users', data: any(named: 'data')),
        ).thenThrow(Exception('Email already exists'));

        expect(
          () => userRepository.createUser(userToCreate),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Erro ao criar usuário'),
            ),
          ),
        );
      });
    });

    group('updateUser', () {
      test('deve atualizar usuário com sucesso', () async {
        final updatedUserJson = {
          ...testUserJson,
          'name': 'Updated User',
          'email': 'updated@example.com',
        };
        final updatedUser = testUser.copyWith(
          name: 'Updated User',
          email: 'updated@example.com',
        );

        when(
          () => mockApiService.put('/users/1', data: any(named: 'data')),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: updatedUserJson,
            statusCode: 200,
          ),
        );

        final result = await userRepository.updateUser(updatedUser);

        expect(result.id, equals(1));
        expect(result.name, equals('Updated User'));
        expect(result.email, equals('updated@example.com'));
        verify(
          () => mockApiService.put('/users/1', data: any(named: 'data')),
        ).called(1);
      });

      test('deve lançar exceção quando atualização falha', () async {
        when(
          () => mockApiService.put('/users/1', data: any(named: 'data')),
        ).thenThrow(Exception('User not found'));

        expect(
          () => userRepository.updateUser(testUser),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Erro ao atualizar usuário'),
            ),
          ),
        );
      });
    });

    group('deleteUser', () {
      test('deve deletar usuário com sucesso', () async {
        when(() => mockApiService.delete('/users/1')).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 204,
          ),
        );

        await userRepository.deleteUser(1);

        verify(() => mockApiService.delete('/users/1')).called(1);
      });

      test('deve lançar exceção quando deleção falha', () async {
        when(
          () => mockApiService.delete('/users/1'),
        ).thenThrow(Exception('User not found'));

        expect(
          () => userRepository.deleteUser(1),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Erro ao excluir usuário'),
            ),
          ),
        );
      });
    });
  });
}
