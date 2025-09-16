import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/users/domain/usecases/create_user.dart';
import 'package:frontend/features/users/domain/repositories/user_repository.dart';
import 'package:frontend/features/users/domain/models/user_model.dart';

class MockUserRepository extends Mock implements UserRepository {}

class FakeUserModel extends Fake implements UserModel {}

void main() {
  late CreateUser createUserUseCase;
  late MockUserRepository mockUserRepository;

  setUpAll(() {
    registerFallbackValue(FakeUserModel());
  });

  setUp(() {
    mockUserRepository = MockUserRepository();
    createUserUseCase = CreateUser(mockUserRepository);
  });

  group('CreateUser UseCase Tests', () {
    final testUser = UserModel(
      id: 1,
      name: 'New User',
      email: 'newuser@example.com',
      role: UserRole.user,
      status: UserStatus.ativo,
    );

    final userToCreate = UserModel(
      id: 0, // Typically ID would be 0 or null for new users
      name: 'New User',
      email: 'newuser@example.com',
      role: UserRole.user,
      status: UserStatus.ativo,
    );

    group('call', () {
      test('deve criar usuário com sucesso', () async {
        // Arrange
        when(
          () => mockUserRepository.createUser(any()),
        ).thenAnswer((_) async => testUser);

        // Act
        final result = await createUserUseCase.call(userToCreate);

        // Assert
        expect(result, equals(testUser));
        expect(result.id, equals(1));
        expect(result.name, equals('New User'));
        expect(result.email, equals('newuser@example.com'));
        expect(result.role, equals(UserRole.user));
        expect(result.status, equals(UserStatus.ativo));
        verify(() => mockUserRepository.createUser(userToCreate)).called(1);
      });

      test('deve criar usuário admin com sucesso', () async {
        // Arrange
        final adminUser = userToCreate.copyWith(role: UserRole.admin);
        final createdAdminUser = testUser.copyWith(role: UserRole.admin);

        when(
          () => mockUserRepository.createUser(any()),
        ).thenAnswer((_) async => createdAdminUser);

        // Act
        final result = await createUserUseCase.call(adminUser);

        // Assert
        expect(result, equals(createdAdminUser));
        expect(result.role, equals(UserRole.admin));
        verify(() => mockUserRepository.createUser(adminUser)).called(1);
      });

      test('deve criar usuário com status pendente', () async {
        // Arrange
        final pendingUser = userToCreate.copyWith(status: UserStatus.pendente);
        final createdPendingUser = testUser.copyWith(
          status: UserStatus.pendente,
        );

        when(
          () => mockUserRepository.createUser(any()),
        ).thenAnswer((_) async => createdPendingUser);

        // Act
        final result = await createUserUseCase.call(pendingUser);

        // Assert
        expect(result, equals(createdPendingUser));
        expect(result.status, equals(UserStatus.pendente));
        verify(() => mockUserRepository.createUser(pendingUser)).called(1);
      });

      test('deve criar usuário com campos opcionais', () async {
        // Arrange
        final userWithOptionals = userToCreate.copyWith(
          phone: '11999999999',
          department: 'IT',
        );
        final createdUserWithOptionals = testUser.copyWith(
          phone: '11999999999',
          department: 'IT',
        );

        when(
          () => mockUserRepository.createUser(any()),
        ).thenAnswer((_) async => createdUserWithOptionals);

        // Act
        final result = await createUserUseCase.call(userWithOptionals);

        // Assert
        expect(result, equals(createdUserWithOptionals));
        expect(result.phone, equals('11999999999'));
        expect(result.department, equals('IT'));
        verify(
          () => mockUserRepository.createUser(userWithOptionals),
        ).called(1);
      });

      test('deve propagar erro do repository para email duplicado', () async {
        // Arrange
        when(
          () => mockUserRepository.createUser(any()),
        ).thenThrow(Exception('Email já está em uso'));

        // Act & Assert
        expect(
          () => createUserUseCase.call(userToCreate),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Email já está em uso'),
            ),
          ),
        );
        verify(() => mockUserRepository.createUser(userToCreate)).called(1);
      });

      test(
        'deve propagar erro do repository para falha de validação',
        () async {
          // Arrange
          when(
            () => mockUserRepository.createUser(any()),
          ).thenThrow(Exception('Dados inválidos'));

          // Act & Assert
          expect(
            () => createUserUseCase.call(userToCreate),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Dados inválidos'),
              ),
            ),
          );
          verify(() => mockUserRepository.createUser(userToCreate)).called(1);
        },
      );

      test('deve propagar erro genérico do repository', () async {
        // Arrange
        when(
          () => mockUserRepository.createUser(any()),
        ).thenThrow(Exception('Erro interno do servidor'));

        // Act & Assert
        expect(
          () => createUserUseCase.call(userToCreate),
          throwsA(isA<Exception>()),
        );
        verify(() => mockUserRepository.createUser(userToCreate)).called(1);
      });
    });
  });
}
