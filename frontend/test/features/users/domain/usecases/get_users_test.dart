import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/users/domain/usecases/get_users.dart';
import 'package:frontend/features/users/domain/repositories/user_repository.dart';
import 'package:frontend/features/users/domain/models/user_model.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late GetUsers getUsersUseCase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    getUsersUseCase = GetUsers(mockUserRepository);
  });

  group('GetUsers UseCase Tests', () {
    final testUsers = [
      UserModel(
        id: 1,
        name: 'User 1',
        email: 'user1@example.com',
        role: UserRole.user,
        status: UserStatus.ativo,
      ),
      UserModel(
        id: 2,
        name: 'User 2',
        email: 'user2@example.com',
        role: UserRole.admin,
        status: UserStatus.ativo,
      ),
    ];

    group('call', () {
      test('deve retornar lista de usuários sem filtros', () async {
        // Arrange
        when(
          () => mockUserRepository.getUsers(
            name: null,
            email: null,
            status: null,
            role: null,
          ),
        ).thenAnswer((_) async => testUsers);

        // Act
        final result = await getUsersUseCase.call();

        // Assert
        expect(result, equals(testUsers));
        expect(result.length, equals(2));
        verify(
          () => mockUserRepository.getUsers(
            name: null,
            email: null,
            status: null,
            role: null,
          ),
        ).called(1);
      });

      test('deve retornar lista de usuários com filtro de nome', () async {
        // Arrange
        final filteredUsers = [testUsers[0]];
        when(
          () => mockUserRepository.getUsers(
            name: 'User 1',
            email: null,
            status: null,
            role: null,
          ),
        ).thenAnswer((_) async => filteredUsers);

        // Act
        final result = await getUsersUseCase.call(name: 'User 1');

        // Assert
        expect(result, equals(filteredUsers));
        expect(result.length, equals(1));
        expect(result[0].name, equals('User 1'));
        verify(
          () => mockUserRepository.getUsers(
            name: 'User 1',
            email: null,
            status: null,
            role: null,
          ),
        ).called(1);
      });

      test('deve retornar lista de usuários com filtro de email', () async {
        // Arrange
        final filteredUsers = [testUsers[1]];
        when(
          () => mockUserRepository.getUsers(
            name: null,
            email: 'user2@example.com',
            status: null,
            role: null,
          ),
        ).thenAnswer((_) async => filteredUsers);

        // Act
        final result = await getUsersUseCase.call(email: 'user2@example.com');

        // Assert
        expect(result, equals(filteredUsers));
        expect(result.length, equals(1));
        expect(result[0].email, equals('user2@example.com'));
        verify(
          () => mockUserRepository.getUsers(
            name: null,
            email: 'user2@example.com',
            status: null,
            role: null,
          ),
        ).called(1);
      });

      test('deve retornar lista de usuários com filtro de status', () async {
        // Arrange
        final activeUsers = testUsers
            .where((user) => user.status == UserStatus.ativo)
            .toList();
        when(
          () => mockUserRepository.getUsers(
            name: null,
            email: null,
            status: UserStatus.ativo,
            role: null,
          ),
        ).thenAnswer((_) async => activeUsers);

        // Act
        final result = await getUsersUseCase.call(status: UserStatus.ativo);

        // Assert
        expect(result, equals(activeUsers));
        result.forEach((user) {
          expect(user.status, equals(UserStatus.ativo));
        });
        verify(
          () => mockUserRepository.getUsers(
            name: null,
            email: null,
            status: UserStatus.ativo,
            role: null,
          ),
        ).called(1);
      });

      test('deve retornar lista de usuários com filtro de role', () async {
        // Arrange
        final adminUsers = testUsers
            .where((user) => user.role == UserRole.admin)
            .toList();
        when(
          () => mockUserRepository.getUsers(
            name: null,
            email: null,
            status: null,
            role: UserRole.admin,
          ),
        ).thenAnswer((_) async => adminUsers);

        // Act
        final result = await getUsersUseCase.call(role: UserRole.admin);

        // Assert
        expect(result, equals(adminUsers));
        result.forEach((user) {
          expect(user.role, equals(UserRole.admin));
        });
        verify(
          () => mockUserRepository.getUsers(
            name: null,
            email: null,
            status: null,
            role: UserRole.admin,
          ),
        ).called(1);
      });

      test('deve retornar lista de usuários com múltiplos filtros', () async {
        // Arrange
        final filteredUsers = [testUsers[1]];
        when(
          () => mockUserRepository.getUsers(
            name: 'User 2',
            email: 'user2@example.com',
            status: UserStatus.ativo,
            role: UserRole.admin,
          ),
        ).thenAnswer((_) async => filteredUsers);

        // Act
        final result = await getUsersUseCase.call(
          name: 'User 2',
          email: 'user2@example.com',
          status: UserStatus.ativo,
          role: UserRole.admin,
        );

        // Assert
        expect(result, equals(filteredUsers));
        expect(result.length, equals(1));
        verify(
          () => mockUserRepository.getUsers(
            name: 'User 2',
            email: 'user2@example.com',
            status: UserStatus.ativo,
            role: UserRole.admin,
          ),
        ).called(1);
      });

      test('deve retornar lista vazia quando não há usuários', () async {
        // Arrange
        when(
          () => mockUserRepository.getUsers(
            name: null,
            email: null,
            status: null,
            role: null,
          ),
        ).thenAnswer((_) async => []);

        // Act
        final result = await getUsersUseCase.call();

        // Assert
        expect(result, isEmpty);
        verify(
          () => mockUserRepository.getUsers(
            name: null,
            email: null,
            status: null,
            role: null,
          ),
        ).called(1);
      });

      test('deve propagar erro do repository', () async {
        // Arrange
        when(
          () => mockUserRepository.getUsers(
            name: null,
            email: null,
            status: null,
            role: null,
          ),
        ).thenThrow(Exception('Erro ao buscar usuários'));

        // Act & Assert
        expect(() => getUsersUseCase.call(), throwsA(isA<Exception>()));
        verify(
          () => mockUserRepository.getUsers(
            name: null,
            email: null,
            status: null,
            role: null,
          ),
        ).called(1);
      });
    });
  });
}
