import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/users/domain/usecases/update_user.dart';
import 'package:frontend/features/users/domain/repositories/user_repository.dart';
import 'package:frontend/features/users/domain/models/user_model.dart';

class MockUserRepository extends Mock implements UserRepository {}

class FakeUserModel extends Fake implements UserModel {}

void main() {
  late UpdateUser updateUserUseCase;
  late MockUserRepository mockUserRepository;

  setUpAll(() {
    registerFallbackValue(FakeUserModel());
  });

  setUp(() {
    mockUserRepository = MockUserRepository();
    updateUserUseCase = UpdateUser(mockUserRepository);
  });

  group('UpdateUser UseCase Tests', () {
    final originalUser = UserModel(
      id: 1,
      name: 'Original User',
      email: 'original@example.com',
      role: UserRole.user,
      status: UserStatus.ativo,
      phone: '11999999999',
      department: 'HR',
    );

    final updatedUser = UserModel(
      id: 1,
      name: 'Updated User',
      email: 'updated@example.com',
      role: UserRole.admin,
      status: UserStatus.ativo,
      phone: '11888888888',
      department: 'IT',
    );

    group('call', () {
      test('deve atualizar usuário com sucesso', () async {
        // Arrange
        when(
          () => mockUserRepository.updateUser(any()),
        ).thenAnswer((_) async => updatedUser);

        // Act
        final result = await updateUserUseCase.call(updatedUser);

        // Assert
        expect(result, equals(updatedUser));
        expect(result.id, equals(1));
        expect(result.name, equals('Updated User'));
        expect(result.email, equals('updated@example.com'));
        expect(result.role, equals(UserRole.admin));
        expect(result.phone, equals('11888888888'));
        expect(result.department, equals('IT'));
        verify(() => mockUserRepository.updateUser(updatedUser)).called(1);
      });

      test('deve atualizar apenas o nome do usuário', () async {
        // Arrange
        final userWithUpdatedName = originalUser.copyWith(name: 'New Name');

        when(
          () => mockUserRepository.updateUser(any()),
        ).thenAnswer((_) async => userWithUpdatedName);

        // Act
        final result = await updateUserUseCase.call(userWithUpdatedName);

        // Assert
        expect(result.id, equals(originalUser.id));
        expect(result.name, equals('New Name'));
        expect(result.email, equals(originalUser.email));
        expect(result.role, equals(originalUser.role));
        verify(
          () => mockUserRepository.updateUser(userWithUpdatedName),
        ).called(1);
      });

      test('deve atualizar apenas o email do usuário', () async {
        // Arrange
        final userWithUpdatedEmail = originalUser.copyWith(
          email: 'newemail@example.com',
        );

        when(
          () => mockUserRepository.updateUser(any()),
        ).thenAnswer((_) async => userWithUpdatedEmail);

        // Act
        final result = await updateUserUseCase.call(userWithUpdatedEmail);

        // Assert
        expect(result.id, equals(originalUser.id));
        expect(result.name, equals(originalUser.name));
        expect(result.email, equals('newemail@example.com'));
        expect(result.role, equals(originalUser.role));
        verify(
          () => mockUserRepository.updateUser(userWithUpdatedEmail),
        ).called(1);
      });

      test('deve atualizar o role do usuário para admin', () async {
        // Arrange
        final userWithAdminRole = originalUser.copyWith(role: UserRole.admin);

        when(
          () => mockUserRepository.updateUser(any()),
        ).thenAnswer((_) async => userWithAdminRole);

        // Act
        final result = await updateUserUseCase.call(userWithAdminRole);

        // Assert
        expect(result.role, equals(UserRole.admin));
        verify(
          () => mockUserRepository.updateUser(userWithAdminRole),
        ).called(1);
      });

      test('deve atualizar o status do usuário', () async {
        // Arrange
        final userWithInactiveStatus = originalUser.copyWith(
          status: UserStatus.inativo,
        );

        when(
          () => mockUserRepository.updateUser(any()),
        ).thenAnswer((_) async => userWithInactiveStatus);

        // Act
        final result = await updateUserUseCase.call(userWithInactiveStatus);

        // Assert
        expect(result.status, equals(UserStatus.inativo));
        verify(
          () => mockUserRepository.updateUser(userWithInactiveStatus),
        ).called(1);
      });

      test('deve atualizar campos opcionais do usuário', () async {
        // Arrange
        final userWithUpdatedOptionals = originalUser.copyWith(
          phone: '11777777777',
          department: 'Marketing',
        );

        when(
          () => mockUserRepository.updateUser(any()),
        ).thenAnswer((_) async => userWithUpdatedOptionals);

        // Act
        final result = await updateUserUseCase.call(userWithUpdatedOptionals);

        // Assert
        expect(result.phone, equals('11777777777'));
        expect(result.department, equals('Marketing'));
        verify(
          () => mockUserRepository.updateUser(userWithUpdatedOptionals),
        ).called(1);
      });

      test(
        'deve propagar erro do repository para usuário não encontrado',
        () async {
          // Arrange
          when(
            () => mockUserRepository.updateUser(any()),
          ).thenThrow(Exception('Usuário não encontrado'));

          // Act & Assert
          expect(
            () => updateUserUseCase.call(updatedUser),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Usuário não encontrado'),
              ),
            ),
          );
          verify(() => mockUserRepository.updateUser(updatedUser)).called(1);
        },
      );

      test('deve propagar erro do repository para email duplicado', () async {
        // Arrange
        when(
          () => mockUserRepository.updateUser(any()),
        ).thenThrow(Exception('Email já está em uso por outro usuário'));

        // Act & Assert
        expect(
          () => updateUserUseCase.call(updatedUser),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Email já está em uso'),
            ),
          ),
        );
        verify(() => mockUserRepository.updateUser(updatedUser)).called(1);
      });

      test('deve propagar erro do repository para dados inválidos', () async {
        // Arrange
        when(
          () => mockUserRepository.updateUser(any()),
        ).thenThrow(Exception('Dados de atualização inválidos'));

        // Act & Assert
        expect(
          () => updateUserUseCase.call(updatedUser),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Dados de atualização inválidos'),
            ),
          ),
        );
        verify(() => mockUserRepository.updateUser(updatedUser)).called(1);
      });

      test('deve propagar erro genérico do repository', () async {
        // Arrange
        when(
          () => mockUserRepository.updateUser(any()),
        ).thenThrow(Exception('Erro interno do servidor'));

        // Act & Assert
        expect(
          () => updateUserUseCase.call(updatedUser),
          throwsA(isA<Exception>()),
        );
        verify(() => mockUserRepository.updateUser(updatedUser)).called(1);
      });
    });
  });
}
