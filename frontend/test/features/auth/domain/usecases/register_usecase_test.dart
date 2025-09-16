import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/auth/domain/usecases/register_usecase.dart';
import 'package:frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frontend/features/auth/domain/models/auth_response.dart';
import 'package:frontend/features/auth/domain/models/user.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late RegisterUseCase registerUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    registerUseCase = RegisterUseCase(mockAuthRepository);
  });

  group('RegisterUseCase Tests', () {
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
      test('deve registrar usuário com sucesso', () async {
        // Arrange
        when(
          () => mockAuthRepository.register(
            name: 'Test User',
            email: 'test@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => testAuthResponse);

        // Act
        final result = await registerUseCase.execute(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        expect(result.accessToken, 'test_token_123');
        expect(result.user.name, 'Test User');
        expect(result.user.email, 'test@example.com');
        verify(
          () => mockAuthRepository.register(
            name: 'Test User',
            email: 'test@example.com',
            password: 'password123',
          ),
        ).called(1);
      });

      test('deve lançar exceção quando nome está vazio', () async {
        // Act & Assert
        expect(
          () => registerUseCase.execute(
            name: '',
            email: 'test@example.com',
            password: 'password123',
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Todos os campos são obrigatórios'),
            ),
          ),
        );

        verifyNever(
          () => mockAuthRepository.register(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        );
      });

      test('deve lançar exceção quando email está vazio', () async {
        // Act & Assert
        expect(
          () => registerUseCase.execute(
            name: 'Test User',
            email: '',
            password: 'password123',
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Todos os campos são obrigatórios'),
            ),
          ),
        );

        verifyNever(
          () => mockAuthRepository.register(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        );
      });

      test('deve lançar exceção quando senha está vazia', () async {
        // Act & Assert
        expect(
          () => registerUseCase.execute(
            name: 'Test User',
            email: 'test@example.com',
            password: '',
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Todos os campos são obrigatórios'),
            ),
          ),
        );

        verifyNever(
          () => mockAuthRepository.register(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        );
      });

      test('deve lançar exceção para nome muito curto', () async {
        // Act & Assert
        expect(
          () => registerUseCase.execute(
            name: 'A',
            email: 'test@example.com',
            password: 'password123',
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
          () => mockAuthRepository.register(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        );
      });

      test('deve lançar exceção para email inválido', () async {
        // Act & Assert
        expect(
          () => registerUseCase.execute(
            name: 'Test User',
            email: 'invalid-email',
            password: 'password123',
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
          () => mockAuthRepository.register(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        );
      });

      test('deve lançar exceção para senha muito curta', () async {
        // Act & Assert
        expect(
          () => registerUseCase.execute(
            name: 'Test User',
            email: 'test@example.com',
            password: '123',
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Senha deve ter pelo menos 6 caracteres'),
            ),
          ),
        );

        verifyNever(
          () => mockAuthRepository.register(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        );
      });

      test('deve propagar exceção do repository', () async {
        // Arrange
        when(
          () => mockAuthRepository.register(
            name: 'Test User',
            email: 'existing@example.com',
            password: 'password123',
          ),
        ).thenThrow(Exception('Email já está em uso'));

        // Act & Assert
        expect(
          () => registerUseCase.execute(
            name: 'Test User',
            email: 'existing@example.com',
            password: 'password123',
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Email já está em uso'),
            ),
          ),
        );

        verify(
          () => mockAuthRepository.register(
            name: 'Test User',
            email: 'existing@example.com',
            password: 'password123',
          ),
        ).called(1);
      });

      group('Validation edge cases', () {
        test('deve aceitar nome com 2 caracteres', () async {
          // Arrange
          when(
            () => mockAuthRepository.register(
              name: 'Ab',
              email: 'test@example.com',
              password: 'password123',
            ),
          ).thenAnswer((_) async => testAuthResponse);

          // Act
          await registerUseCase.execute(
            name: 'Ab',
            email: 'test@example.com',
            password: 'password123',
          );

          // Assert
          verify(
            () => mockAuthRepository.register(
              name: 'Ab',
              email: 'test@example.com',
              password: 'password123',
            ),
          ).called(1);
        });

        test('deve aceitar senha com 6 caracteres', () async {
          // Arrange
          when(
            () => mockAuthRepository.register(
              name: 'Test User',
              email: 'test@example.com',
              password: '123456',
            ),
          ).thenAnswer((_) async => testAuthResponse);

          // Act
          await registerUseCase.execute(
            name: 'Test User',
            email: 'test@example.com',
            password: '123456',
          );

          // Assert
          verify(
            () => mockAuthRepository.register(
              name: 'Test User',
              email: 'test@example.com',
              password: '123456',
            ),
          ).called(1);
        });

        test('deve aceitar nomes com caracteres especiais', () async {
          // Arrange
          when(
            () => mockAuthRepository.register(
              name: 'José da Silva',
              email: 'test@example.com',
              password: 'password123',
            ),
          ).thenAnswer((_) async => testAuthResponse);

          // Act
          await registerUseCase.execute(
            name: 'José da Silva',
            email: 'test@example.com',
            password: 'password123',
          );

          // Assert
          verify(
            () => mockAuthRepository.register(
              name: 'José da Silva',
              email: 'test@example.com',
              password: 'password123',
            ),
          ).called(1);
        });
      });
    });
  });
}
