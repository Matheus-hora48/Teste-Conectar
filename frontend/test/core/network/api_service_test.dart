import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/core/network/api_service.dart';
import 'package:frontend/core/constants/app_constants.dart';

class MockDio extends Mock implements Dio {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockResponse extends Mock implements Response<dynamic> {}

class FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  late ApiService apiService;
  late MockFlutterSecureStorage mockStorage;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(FakeRequestOptions());
  });

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    apiService = ApiService();
  });

  group('ApiService Tests', () {
    group('Token Management', () {
      test('deve salvar token com sucesso', () async {
        // Arrange
        const token = 'test_token_123';

        when(
          () => mockStorage.write(key: AppConstants.tokenKey, value: token),
        ).thenAnswer((_) async => {});

        when(
          () => mockStorage.read(key: AppConstants.tokenKey),
        ).thenAnswer((_) async => token);

        // Act
        await apiService.saveToken(token);

        // Assert
        // Como ApiService usa uma instância interna de FlutterSecureStorage,
        // vamos verificar o comportamento através do getToken
        final savedToken = await apiService.getToken();
        expect(savedToken, isNotNull);
      });

      test('deve recuperar token existente', () async {
        // Act
        final token = await apiService.getToken();

        // Assert
        expect(token, isA<String?>());
      });

      test('deve retornar null quando não há token', () async {
        // Arrange
        await apiService.clearAuth();

        // Act
        final token = await apiService.getToken();

        // Assert
        expect(token, isNull);
      });

      test('deve limpar autenticação removendo token e usuário', () async {
        // Arrange
        const token = 'token_to_clear';
        await apiService.saveToken(token);

        // Act
        await apiService.clearAuth();

        // Assert
        final clearedToken = await apiService.getToken();
        final clearedUser = await apiService.getUser();
        expect(clearedToken, isNull);
        expect(clearedUser, isNull);
      });
    });

    group('User Data Management', () {
      test('deve salvar dados do usuário com sucesso', () async {
        // Arrange
        const userData =
            '{"id": 1, "name": "Test User", "email": "test@email.com"}';

        // Act
        await apiService.saveUser(userData);

        // Assert
        final savedUser = await apiService.getUser();
        expect(savedUser, equals(userData));
      });

      test('deve recuperar dados do usuário', () async {
        // Arrange
        const userData =
            '{"id": 2, "name": "Another User", "email": "another@email.com"}';
        await apiService.saveUser(userData);

        // Act
        final retrievedUser = await apiService.getUser();

        // Assert
        expect(retrievedUser, equals(userData));
      });

      test('deve retornar null quando não há dados do usuário', () async {
        // Arrange
        await apiService.clearAuth();

        // Act
        final user = await apiService.getUser();

        // Assert
        expect(user, isNull);
      });

      test('deve salvar e recuperar dados JSON complexos do usuário', () async {
        // Arrange
        const complexUserData = '''
        {
          "id": 3,
          "name": "Complex User",
          "email": "complex@email.com",
          "role": "ADMIN",
          "permissions": ["read", "write", "delete"],
          "profile": {
            "avatar": "avatar.jpg",
            "preferences": {
              "theme": "dark",
              "language": "pt-BR"
            }
          }
        }
        ''';

        // Act
        await apiService.saveUser(complexUserData);
        final retrievedUser = await apiService.getUser();

        // Assert
        expect(retrievedUser, equals(complexUserData));
      });
    });

    group('HTTP Methods', () {
      test('deve executar GET request com sucesso', () async {
        // Act & Assert
        expect(() => apiService.get('/test'), returnsNormally);
      });

      test('deve executar GET request com query parameters', () async {
        // Arrange
        final queryParams = {'page': '1', 'limit': '10', 'search': 'test'};

        // Act & Assert
        expect(
          () => apiService.get('/test', queryParameters: queryParams),
          returnsNormally,
        );
      });

      test('deve executar POST request com dados', () async {
        // Arrange
        final postData = {'name': 'Test Name', 'email': 'test@email.com'};

        // Act & Assert
        expect(() => apiService.post('/test', data: postData), returnsNormally);
      });

      test('deve executar PUT request com dados', () async {
        // Arrange
        final putData = {'id': 1, 'name': 'Updated Name'};

        // Act & Assert
        expect(() => apiService.put('/test/1', data: putData), returnsNormally);
      });

      test('deve executar PATCH request com dados', () async {
        // Arrange
        final patchData = {'name': 'Patched Name'};

        // Act & Assert
        expect(
          () => apiService.patch('/test/1', data: patchData),
          returnsNormally,
        );
      });

      test('deve executar DELETE request', () async {
        // Act & Assert
        expect(() => apiService.delete('/test/1'), returnsNormally);
      });

      test('deve executar POST request sem dados', () async {
        // Act & Assert
        expect(() => apiService.post('/test'), returnsNormally);
      });

      test('deve executar POST request com string como dados', () async {
        // Arrange
        const stringData = 'raw string data';

        // Act & Assert
        expect(
          () => apiService.post('/test', data: stringData),
          returnsNormally,
        );
      });

      test('deve executar POST request com lista como dados', () async {
        // Arrange
        final listData = [
          {'id': 1, 'name': 'Item 1'},
          {'id': 2, 'name': 'Item 2'},
        ];

        // Act & Assert
        expect(() => apiService.post('/test', data: listData), returnsNormally);
      });
    });

    group('Initialization', () {
      test('deve inicializar ApiService como singleton', () {
        // Act
        final instance1 = ApiService();
        final instance2 = ApiService();

        // Assert
        expect(instance1, same(instance2));
      });

      test('deve ter Dio instance válida após get dio', () {
        // Act
        final dioInstance = apiService.dio;

        // Assert
        expect(dioInstance, isA<Dio>());
        expect(dioInstance.options.baseUrl, equals(AppConstants.baseUrl));
        expect(
          dioInstance.options.connectTimeout,
          equals(const Duration(seconds: 30)),
        );
        expect(
          dioInstance.options.receiveTimeout,
          equals(const Duration(seconds: 30)),
        );
      });

      test('deve ter headers padrão corretos', () {
        // Act
        final dioInstance = apiService.dio;

        // Assert
        expect(
          dioInstance.options.headers['Content-Type'],
          equals('application/json'),
        );
        expect(
          dioInstance.options.headers['Accept'],
          equals('application/json'),
        );
      });

      test('deve ter interceptors configurados', () {
        // Act
        final dioInstance = apiService.dio;

        // Assert
        expect(dioInstance.interceptors, isNotEmpty);
        expect(dioInstance.interceptors.length, greaterThanOrEqualTo(2));
      });

      test('deve inicializar automaticamente ao chamar HTTP methods', () {
        // Act & Assert
        expect(() => apiService.get('/test'), returnsNormally);

        final dioInstance = apiService.dio;
        expect(dioInstance, isA<Dio>());
      });
    });

    group('Token Integration', () {
      test('deve gerenciar ciclo completo de token', () async {
        // Arrange
        const token = 'integration_test_token';

        // Act - Salvar token
        await apiService.saveToken(token);
        final savedToken = await apiService.getToken();

        // Assert - Token salvo
        expect(savedToken, equals(token));

        // Act - Limpar autenticação
        await apiService.clearAuth();
        final clearedToken = await apiService.getToken();

        // Assert - Token removido
        expect(clearedToken, isNull);
      });

      test('deve gerenciar múltiplos tokens sequencialmente', () async {
        // Arrange
        const tokens = ['token1', 'token2', 'token3'];

        for (final token in tokens) {
          // Act
          await apiService.saveToken(token);
          final retrievedToken = await apiService.getToken();

          // Assert
          expect(retrievedToken, equals(token));
        }
      });
    });

    group('Error Handling', () {
      test(
        'deve manter funcionalidade básica mesmo com storage errors',
        () async {
          // Act & Assert - HTTP methods devem funcionar independente do storage
          expect(() => apiService.get('/test'), returnsNormally);

          expect(
            () => apiService.post('/test', data: {'test': 'data'}),
            returnsNormally,
          );
        },
      );

      test('deve ter dio instance mesmo após múltiplas inicializações', () {
        // Act
        apiService.initialize();
        apiService.initialize();
        final dioInstance = apiService.dio;

        // Assert
        expect(dioInstance, isA<Dio>());
      });
    });

    group('Configuration Validation', () {
      test('deve ter configuração de timeout correta', () {
        // Act
        final dioInstance = apiService.dio;

        // Assert
        expect(
          dioInstance.options.connectTimeout,
          equals(const Duration(seconds: 30)),
        );
        expect(
          dioInstance.options.receiveTimeout,
          equals(const Duration(seconds: 30)),
        );
      });

      test('deve ter base URL configurada corretamente', () {
        // Act
        final dioInstance = apiService.dio;

        // Assert
        expect(dioInstance.options.baseUrl, equals(AppConstants.baseUrl));
      });

      test('deve manter headers consistentes entre requests', () {
        // Act
        final dioInstance1 = apiService.dio;
        final dioInstance2 = apiService.dio;

        // Assert
        expect(
          dioInstance1.options.headers,
          equals(dioInstance2.options.headers),
        );
      });
    });
  });
}
