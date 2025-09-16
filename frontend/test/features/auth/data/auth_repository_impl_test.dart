import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:frontend/features/auth/data/auth_repository_impl.dart';
import 'package:frontend/features/auth/domain/models/auth_response.dart';
import 'package:frontend/features/auth/domain/models/user.dart';
import 'package:frontend/core/network/api_service.dart';
import 'package:frontend/core/constants/app_constants.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late AuthRepositoryImpl authRepository;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    authRepository = AuthRepositoryImpl(apiService: mockApiService);
  });

  group('AuthRepositoryImpl Tests', () {
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

    group('login', () {
      test('deve fazer login com sucesso', () async {
        // Arrange
        when(
          () => mockApiService.post(
            AppConstants.authLogin,
            data: {'email': 'test@example.com', 'password': 'password123'},
          ),
        ).thenAnswer(
          (_) async => Response(
            data: testAuthResponse.toJson(),
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        when(() => mockApiService.saveToken(any())).thenAnswer((_) async {});
        when(() => mockApiService.saveUser(any())).thenAnswer((_) async {});

        // Act
        final result = await authRepository.login(
          'test@example.com',
          'password123',
        );

        // Assert
        expect(result.accessToken, 'test_token_123');
        expect(result.user.email, 'test@example.com');
        verify(() => mockApiService.saveToken('test_token_123')).called(1);
        verify(() => mockApiService.saveUser(any())).called(1);
      });

      test('deve lançar exceção para credenciais inválidas', () async {
        // Arrange
        when(
          () => mockApiService.post(
            AppConstants.authLogin,
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            response: Response(
              statusCode: 401,
              requestOptions: RequestOptions(path: ''),
            ),
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act & Assert
        expect(
          () => authRepository.login('test@example.com', 'wrong_password'),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Email ou senha incorretos'),
            ),
          ),
        );
      });

      test('deve lançar exceção para erro de rede', () async {
        // Arrange
        when(
          () => mockApiService.post(
            AppConstants.authLogin,
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            message: 'Network error',
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act & Assert
        expect(
          () => authRepository.login('test@example.com', 'password123'),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Erro ao fazer login'),
            ),
          ),
        );
      });

      test('deve lançar exceção para erro inesperado', () async {
        // Arrange
        when(
          () => mockApiService.post(
            AppConstants.authLogin,
            data: any(named: 'data'),
          ),
        ).thenThrow(Exception('Unexpected error'));

        // Act & Assert
        expect(
          () => authRepository.login('test@example.com', 'password123'),
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

    group('register', () {
      test('deve registrar usuário com sucesso', () async {
        // Arrange
        when(
          () => mockApiService.post(
            AppConstants.authRegister,
            data: {
              'name': 'Test User',
              'email': 'test@example.com',
              'password': 'password123',
            },
          ),
        ).thenAnswer(
          (_) async => Response(
            data: testAuthResponse.toJson(),
            statusCode: 201,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        when(() => mockApiService.saveToken(any())).thenAnswer((_) async {});
        when(() => mockApiService.saveUser(any())).thenAnswer((_) async {});

        // Act
        final result = await authRepository.register(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        expect(result.accessToken, 'test_token_123');
        expect(result.user.name, 'Test User');
        verify(() => mockApiService.saveToken('test_token_123')).called(1);
        verify(() => mockApiService.saveUser(any())).called(1);
      });

      test('deve lançar exceção para email já em uso', () async {
        // Arrange
        when(
          () => mockApiService.post(
            AppConstants.authRegister,
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            response: Response(
              statusCode: 400,
              requestOptions: RequestOptions(path: ''),
            ),
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act & Assert
        expect(
          () => authRepository.register(
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
      });
    });

    group('logout', () {
      test('deve fazer logout com sucesso', () async {
        // Arrange
        when(() => mockApiService.clearAuth()).thenAnswer((_) async {});

        // Act
        await authRepository.logout();

        // Assert
        verify(() => mockApiService.clearAuth()).called(1);
      });
    });

    group('getCurrentUser', () {
      test('deve retornar usuário atual quando existe', () async {
        // Arrange
        when(() => mockApiService.getUser()).thenAnswer(
          (_) async =>
              '{"id": 1, "name": "Test User", "email": "test@example.com", "role": "user"}',
        );

        // Act
        final result = await authRepository.getCurrentUser();

        // Assert
        expect(result, isNotNull);
        expect(result!.id, 1);
        expect(result.name, 'Test User');
        expect(result.email, 'test@example.com');
        expect(result.role, UserRole.user);
      });

      test('deve retornar null quando não há usuário', () async {
        // Arrange
        when(() => mockApiService.getUser()).thenAnswer((_) async => null);

        // Act
        final result = await authRepository.getCurrentUser();

        // Assert
        expect(result, isNull);
      });

      test('deve retornar null em caso de erro', () async {
        // Arrange
        when(() => mockApiService.getUser()).thenThrow(Exception('Error'));

        // Act
        final result = await authRepository.getCurrentUser();

        // Assert
        expect(result, isNull);
      });
    });

    group('isLoggedIn', () {
      test('deve retornar true quando há token válido', () async {
        // Arrange
        when(
          () => mockApiService.getToken(),
        ).thenAnswer((_) async => 'valid_token');

        // Act
        final result = await authRepository.isLoggedIn();

        // Assert
        expect(result, isTrue);
      });

      test('deve retornar false quando token é null', () async {
        // Arrange
        when(() => mockApiService.getToken()).thenAnswer((_) async => null);

        // Act
        final result = await authRepository.isLoggedIn();

        // Assert
        expect(result, isFalse);
      });

      test('deve retornar false quando token está vazio', () async {
        // Arrange
        when(() => mockApiService.getToken()).thenAnswer((_) async => '');

        // Act
        final result = await authRepository.isLoggedIn();

        // Assert
        expect(result, isFalse);
      });
    });

    group('updateProfile', () {
      test('deve atualizar perfil com sucesso', () async {
        // Arrange
        final updatedUser = testUser.copyWith(name: 'Updated Name');
        when(
          () => mockApiService.patch(
            '${AppConstants.users}/1',
            data: {'name': 'Updated Name', 'email': 'test@example.com'},
          ),
        ).thenAnswer(
          (_) async => Response(
            data: updatedUser.toJson(),
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        when(() => mockApiService.saveUser(any())).thenAnswer((_) async {});

        // Act
        final result = await authRepository.updateProfile(
          userId: 1,
          name: 'Updated Name',
          email: 'test@example.com',
        );

        // Assert
        expect(result.name, 'Updated Name');
        verify(() => mockApiService.saveUser(any())).called(1);
      });

      test('deve lançar exceção para email já em uso na atualização', () async {
        // Arrange
        when(
          () => mockApiService.patch(
            '${AppConstants.users}/1',
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            response: Response(
              statusCode: 400,
              requestOptions: RequestOptions(path: ''),
            ),
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act & Assert
        expect(
          () => authRepository.updateProfile(
            userId: 1,
            name: 'Test User',
            email: 'existing@example.com',
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Email já está em uso'),
            ),
          ),
        );
      });
    });

    group('updatePassword', () {
      test('deve atualizar senha com sucesso', () async {
        // Arrange
        when(
          () => mockApiService.patch(
            '${AppConstants.users}/1/password',
            data: {'currentPassword': 'current123', 'newPassword': 'new123'},
          ),
        ).thenAnswer(
          (_) async => Response(
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        await authRepository.updatePassword(
          userId: 1,
          currentPassword: 'current123',
          newPassword: 'new123',
        );

        // Assert
        verify(
          () => mockApiService.patch(
            '${AppConstants.users}/1/password',
            data: {'currentPassword': 'current123', 'newPassword': 'new123'},
          ),
        ).called(1);
      });

      test('deve lançar exceção para senha atual incorreta', () async {
        // Arrange
        when(
          () => mockApiService.patch(
            '${AppConstants.users}/1/password',
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            response: Response(
              statusCode: 400,
              requestOptions: RequestOptions(path: ''),
            ),
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act & Assert
        expect(
          () => authRepository.updatePassword(
            userId: 1,
            currentPassword: 'wrong_password',
            newPassword: 'new123',
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Senha atual incorreta'),
            ),
          ),
        );
      });
    });
  });
}
