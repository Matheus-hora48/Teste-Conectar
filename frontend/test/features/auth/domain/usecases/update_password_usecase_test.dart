import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/auth/domain/usecases/update_password_usecase.dart';
import 'package:frontend/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late UpdatePasswordUseCase updatePasswordUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    updatePasswordUseCase = UpdatePasswordUseCase(mockAuthRepository);
  });

  group('UpdatePasswordUseCase Tests', () {
    group('execute', () {
      test('deve atualizar senha com sucesso', () async {
        // Arrange
        when(
          () => mockAuthRepository.updatePassword(
            userId: 1,
            currentPassword: 'oldPassword123',
            newPassword: 'newPassword456',
          ),
        ).thenAnswer((_) async => {});

        // Act
        await updatePasswordUseCase.execute(
          userId: 1,
          currentPassword: 'oldPassword123',
          newPassword: 'newPassword456',
        );

        // Assert
        verify(
          () => mockAuthRepository.updatePassword(
            userId: 1,
            currentPassword: 'oldPassword123',
            newPassword: 'newPassword456',
          ),
        ).called(1);
      });

      test('deve lançar exceção quando senha atual está vazia', () async {
        // Act & Assert
        expect(
          () => updatePasswordUseCase.execute(
            userId: 1,
            currentPassword: '',
            newPassword: 'newPassword456',
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Senha atual e nova senha são obrigatórias'),
            ),
          ),
        );
        verifyNever(
          () => mockAuthRepository.updatePassword(
            userId: any(named: 'userId'),
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
          ),
        );
      });

      test('deve lançar exceção quando nova senha está vazia', () async {
        // Act & Assert
        expect(
          () => updatePasswordUseCase.execute(
            userId: 1,
            currentPassword: 'oldPassword123',
            newPassword: '',
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Senha atual e nova senha são obrigatórias'),
            ),
          ),
        );
        verifyNever(
          () => mockAuthRepository.updatePassword(
            userId: any(named: 'userId'),
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
          ),
        );
      });

      test(
        'deve lançar exceção quando nova senha tem menos de 6 caracteres',
        () async {
          // Act & Assert
          expect(
            () => updatePasswordUseCase.execute(
              userId: 1,
              currentPassword: 'oldPassword123',
              newPassword: '12345',
            ),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Nova senha deve ter pelo menos 6 caracteres'),
              ),
            ),
          );
          verifyNever(
            () => mockAuthRepository.updatePassword(
              userId: any(named: 'userId'),
              currentPassword: any(named: 'currentPassword'),
              newPassword: any(named: 'newPassword'),
            ),
          );
        },
      );

      test('deve lançar exceção quando nova senha é igual à atual', () async {
        // Act & Assert
        expect(
          () => updatePasswordUseCase.execute(
            userId: 1,
            currentPassword: 'samePassword123',
            newPassword: 'samePassword123',
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('A nova senha deve ser diferente da atual'),
            ),
          ),
        );
        verifyNever(
          () => mockAuthRepository.updatePassword(
            userId: any(named: 'userId'),
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
          ),
        );
      });

      test('deve propagar erro do repository', () async {
        // Arrange
        when(
          () => mockAuthRepository.updatePassword(
            userId: 1,
            currentPassword: 'oldPassword123',
            newPassword: 'newPassword456',
          ),
        ).thenThrow(Exception('Erro ao atualizar senha'));

        // Act & Assert
        expect(
          () => updatePasswordUseCase.execute(
            userId: 1,
            currentPassword: 'oldPassword123',
            newPassword: 'newPassword456',
          ),
          throwsA(isA<Exception>()),
        );
        verify(
          () => mockAuthRepository.updatePassword(
            userId: 1,
            currentPassword: 'oldPassword123',
            newPassword: 'newPassword456',
          ),
        ).called(1);
      });
    });
  });
}
