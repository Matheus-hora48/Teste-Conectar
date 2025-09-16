import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/auth/domain/usecases/login_usecase.dart';
import 'package:frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frontend/features/auth/domain/models/auth_response.dart';
import 'package:frontend/features/auth/domain/models/user.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  group('LoginUseCase Tests', () {
    final testUser = User(
      id: 1,
      name: 'Test User',
      email: 'test@example.com',
      role: UserRole.user,
    );

    final testAuthResponse = AuthResponse(
      accessToken: 'test_token_123',
      user: testUser,
    );

    group('execute', () {
      test('deve fazer login com sucesso', () async {
        // Arrange
        when(
          () => mockAuthRepository.login('test@example.com', 'password123'),
        ).thenAnswer((_) async => testAuthResponse);

        // Act
        final result = await loginUseCase.execute(
          'test@example.com',
          'password123',
        );

        // Assert
        expect(result.accessToken, 'test_token_123');
        expect(result.user.email, 'test@example.com');
        verify(
          () => mockAuthRepository.login('test@example.com', 'password123'),
        ).called(1);
      });

      test('deve lançar exceção quando email está vazio', () async {
        // Act & Assert
        expect(
          () => loginUseCase.execute('', 'password123'),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Email e senha são obrigatórios'),
            ),
          ),
        );

        verifyNever(() => mockAuthRepository.login(any(), any()));
      });

      test('deve lançar exceção quando senha está vazia', () async {
        // Act & Assert
        expect(
          () => loginUseCase.execute('test@example.com', ''),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Email e senha são obrigatórios'),
            ),
          ),
        );

        verifyNever(() => mockAuthRepository.login(any(), any()));
      });

      test('deve lançar exceção para email inválido', () async {
        // Act & Assert
        expect(
          () => loginUseCase.execute('invalid-email', 'password123'),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Email inválido'),
            ),
          ),
        );

        verifyNever(() => mockAuthRepository.login(any(), any()));
      });

      test('deve lançar exceção para senha muito curta', () async {
        // Act & Assert
        expect(
          () => loginUseCase.execute('test@example.com', '123'),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Senha deve ter pelo menos 6 caracteres'),
            ),
          ),
        );

        verifyNever(() => mockAuthRepository.login(any(), any()));
      });

      test('deve propagar exceção do repository', () async {
        // Arrange
        when(
          () => mockAuthRepository.login('test@example.com', 'wrongpassword'),
        ).thenThrow(Exception('Credenciais inválidas'));

        // Act & Assert
        expect(
          () => loginUseCase.execute('test@example.com', 'wrongpassword'),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Credenciais inválidas'),
            ),
          ),
        );

        verify(
          () => mockAuthRepository.login('test@example.com', 'wrongpassword'),
        ).called(1);
      });

      group('Email validation', () {
        test('deve aceitar emails válidos', () async {
          // Arrange
          final validEmails = [
            'test@example.com',
            'user.name@domain.co.uk',
            'test123@test-domain.org',
            'a@b.co',
          ];

          when(
            () => mockAuthRepository.login(any(), any()),
          ).thenAnswer((_) async => testAuthResponse);

          // Act & Assert
          for (final email in validEmails) {
            await loginUseCase.execute(email, 'password123');
            verify(
              () => mockAuthRepository.login(email, 'password123'),
            ).called(1);
          }
        });

        test('deve rejeitar emails inválidos', () async {
          // Arrange
          final invalidEmails = [
            'invalid-email',
            '@domain.com',
            'test@',
            'test..test@domain.com',
            'test@domain',
            '',
          ];

          // Act & Assert
          for (final email in invalidEmails) {
            expect(
              () => loginUseCase.execute(email, 'password123'),
              throwsA(isA<Exception>()),
            );
          }

          verifyNever(() => mockAuthRepository.login(any(), any()));
        });
      });
    });
  });
}
