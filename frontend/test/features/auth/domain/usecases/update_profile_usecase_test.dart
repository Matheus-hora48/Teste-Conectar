import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frontend/features/auth/domain/models/user.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late UpdateProfileUseCase updateProfileUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    updateProfileUseCase = UpdateProfileUseCase(mockAuthRepository);
  });

  group('UpdateProfileUseCase Tests', () {
    final testUser = User(
      id: 1,
      name: 'Updated User',
      email: 'updated@example.com',
      role: UserRole.user,
    );

    group('execute', () {
      test('deve atualizar perfil com sucesso', () async {
        // Arrange
        when(
          () => mockAuthRepository.updateProfile(
            userId: 1,
            name: 'Updated User',
            email: 'updated@example.com',
          ),
        ).thenAnswer((_) async => testUser);

        // Act
        final result = await updateProfileUseCase.execute(
          userId: 1,
          name: 'Updated User',
          email: 'updated@example.com',
        );

        // Assert
        expect(result, equals(testUser));
        expect(result.name, equals('Updated User'));
        expect(result.email, equals('updated@example.com'));
        verify(
          () => mockAuthRepository.updateProfile(
            userId: 1,
            name: 'Updated User',
            email: 'updated@example.com',
          ),
        ).called(1);
      });

      test('deve lançar exceção quando nome está vazio', () async {
        // Act & Assert
        expect(
          () => updateProfileUseCase.execute(
            userId: 1,
            name: '',
            email: 'updated@example.com',
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Nome e email são obrigatórios'),
            ),
          ),
        );
        verifyNever(
          () => mockAuthRepository.updateProfile(
            userId: any(named: 'userId'),
            name: any(named: 'name'),
            email: any(named: 'email'),
          ),
        );
      });

      test('deve lançar exceção quando email está vazio', () async {
        // Act & Assert
        expect(
          () => updateProfileUseCase.execute(
            userId: 1,
            name: 'Updated User',
            email: '',
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Nome e email são obrigatórios'),
            ),
          ),
        );
        verifyNever(
          () => mockAuthRepository.updateProfile(
            userId: any(named: 'userId'),
            name: any(named: 'name'),
            email: any(named: 'email'),
          ),
        );
      });

      test(
        'deve lançar exceção quando nome tem menos de 2 caracteres',
        () async {
          // Act & Assert
          expect(
            () => updateProfileUseCase.execute(
              userId: 1,
              name: 'A',
              email: 'updated@example.com',
            ),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Nome deve ter pelo menos 2 caracteres'),
              ),
            ),
          );
          verifyNever(
            () => mockAuthRepository.updateProfile(
              userId: any(named: 'userId'),
              name: any(named: 'name'),
              email: any(named: 'email'),
            ),
          );
        },
      );

      test('deve lançar exceção quando email é inválido', () async {
        // Act & Assert
        expect(
          () => updateProfileUseCase.execute(
            userId: 1,
            name: 'Updated User',
            email: 'invalid-email',
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Email inválido'),
            ),
          ),
        );
        verifyNever(
          () => mockAuthRepository.updateProfile(
            userId: any(named: 'userId'),
            name: any(named: 'name'),
            email: any(named: 'email'),
          ),
        );
      });

      test('deve aceitar emails válidos', () async {
        // Arrange
        final validEmails = [
          'test@example.com',
          'user.name@domain.co.uk',
          'test+tag@example.org',
          'user123@test-domain.com',
        ];

        for (final email in validEmails) {
          when(
            () => mockAuthRepository.updateProfile(
              userId: 1,
              name: 'Test User',
              email: email,
            ),
          ).thenAnswer((_) async => testUser.copyWith(email: email));

          // Act
          final result = await updateProfileUseCase.execute(
            userId: 1,
            name: 'Test User',
            email: email,
          );

          // Assert
          expect(result.email, equals(email));
        }
      });

      test('deve propagar erro do repository', () async {
        // Arrange
        when(
          () => mockAuthRepository.updateProfile(
            userId: 1,
            name: 'Updated User',
            email: 'updated@example.com',
          ),
        ).thenThrow(Exception('Erro ao atualizar perfil'));

        // Act & Assert
        expect(
          () => updateProfileUseCase.execute(
            userId: 1,
            name: 'Updated User',
            email: 'updated@example.com',
          ),
          throwsA(isA<Exception>()),
        );
        verify(
          () => mockAuthRepository.updateProfile(
            userId: 1,
            name: 'Updated User',
            email: 'updated@example.com',
          ),
        ).called(1);
      });
    });
  });
}
