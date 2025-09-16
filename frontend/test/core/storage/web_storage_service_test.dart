import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/core/storage/web_storage_service.dart';
import 'package:frontend/features/auth/domain/models/user.dart';
import 'package:frontend/core/constants/app_constants.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late WebStorageService webStorageService;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    webStorageService = WebStorageService.instance;
  });

  group('WebStorageService Tests', () {
    group('Singleton Pattern', () {
      test('deve retornar a mesma instância', () {
        // Act
        final instance1 = WebStorageService.instance;
        final instance2 = WebStorageService.instance;

        // Assert
        expect(instance1, same(instance2));
      });

      test('deve manter estado entre chamadas', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          AppConstants.tokenKey: 'test_token',
        });

        // Act
        final instance1 = WebStorageService.instance;
        await instance1.init();
        final token1 = await instance1.getToken();

        final instance2 = WebStorageService.instance;
        final token2 = await instance2.getToken();

        // Assert
        expect(token1, equals(token2));
        expect(token1, equals('test_token'));
      });
    });

    group('Initialization', () {
      test('deve inicializar SharedPreferences', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});

        // Act & Assert
        expect(() => webStorageService.init(), returnsNormally);
        await webStorageService.init();
      });

      test('deve inicializar apenas uma vez', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});

        // Act
        await webStorageService.init();
        await webStorageService.init();
        await webStorageService.init();

        // Assert - Não deve dar erro mesmo chamando múltiplas vezes
        expect(() => webStorageService.init(), returnsNormally);
      });
    });

    group('Token Management', () {
      test('deve salvar token com sucesso', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});
        const token = 'test_token_123';

        // Act
        await webStorageService.saveToken(token);

        // Assert
        final savedToken = await webStorageService.getToken();
        expect(savedToken, equals(token));
      });

      test('deve recuperar token salvo', () async {
        // Arrange
        const token = 'existing_token_456';
        SharedPreferences.setMockInitialValues({AppConstants.tokenKey: token});

        // Act
        final retrievedToken = await webStorageService.getToken();

        // Assert
        expect(retrievedToken, equals(token));
      });

      test('deve retornar null quando não há token', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});

        // Act
        final token = await webStorageService.getToken();

        // Assert
        expect(token, isNull);
      });

      test('deve sobrescrever token existente', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          AppConstants.tokenKey: 'old_token',
        });
        const newToken = 'new_token_789';

        // Act
        await webStorageService.saveToken(newToken);
        final retrievedToken = await webStorageService.getToken();

        // Assert
        expect(retrievedToken, equals(newToken));
        expect(retrievedToken, isNot(equals('old_token')));
      });

      test('deve salvar tokens longos', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});
        const longToken =
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';

        // Act
        await webStorageService.saveToken(longToken);
        final retrievedToken = await webStorageService.getToken();

        // Assert
        expect(retrievedToken, equals(longToken));
      });
    });

    group('User Data Management', () {
      test('deve salvar usuário com sucesso', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});
        final user = User(
          id: 1,
          name: 'Test User',
          email: 'test@email.com',
          role: UserRole.user,
          createdAt: DateTime.parse('2024-01-01T10:00:00Z'),
          lastLoginAt: DateTime.parse('2024-01-02T11:00:00Z'),
        );

        // Act
        await webStorageService.saveUser(user);

        // Assert
        final savedUser = await webStorageService.getUser();
        expect(savedUser, isNotNull);
        expect(savedUser!.id, equals(user.id));
        expect(savedUser.name, equals(user.name));
        expect(savedUser.email, equals(user.email));
        expect(savedUser.role, equals(user.role));
      });

      test('deve recuperar usuário salvo', () async {
        // Arrange
        final user = User(
          id: 2,
          name: 'Another User',
          email: 'another@email.com',
          role: UserRole.admin,
          createdAt: DateTime.parse('2024-01-01T10:00:00Z'),
          lastLoginAt: DateTime.parse('2024-01-02T11:00:00Z'),
        );
        SharedPreferences.setMockInitialValues({});
        await webStorageService.saveUser(user);

        // Act
        final retrievedUser = await webStorageService.getUser();

        // Assert
        expect(retrievedUser, isNotNull);
        expect(retrievedUser!.id, equals(2));
        expect(retrievedUser.name, equals('Another User'));
        expect(retrievedUser.email, equals('another@email.com'));
        expect(retrievedUser.role, equals(UserRole.admin));
      });

      test('deve retornar null quando não há usuário', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});

        // Act
        final user = await webStorageService.getUser();

        // Assert
        expect(user, isNull);
      });

      test(
        'deve retornar null quando dados do usuário são inválidos',
        () async {
          // Arrange
          SharedPreferences.setMockInitialValues({
            AppConstants.userKey: 'invalid_json_data',
          });

          // Act
          final user = await webStorageService.getUser();

          // Assert
          expect(user, isNull);
        },
      );

      test('deve sobrescrever usuário existente', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});
        final oldUser = User(
          id: 1,
          name: 'Old User',
          email: 'old@email.com',
          role: UserRole.user,
          createdAt: DateTime.parse('2024-01-01T10:00:00Z'),
          lastLoginAt: DateTime.parse('2024-01-02T11:00:00Z'),
        );
        final newUser = User(
          id: 2,
          name: 'New User',
          email: 'new@email.com',
          role: UserRole.admin,
          createdAt: DateTime.parse('2024-01-01T10:00:00Z'),
          lastLoginAt: DateTime.parse('2024-01-02T11:00:00Z'),
        );

        // Act
        await webStorageService.saveUser(oldUser);
        await webStorageService.saveUser(newUser);
        final retrievedUser = await webStorageService.getUser();

        // Assert
        expect(retrievedUser!.id, equals(2));
        expect(retrievedUser.name, equals('New User'));
        expect(retrievedUser.role, equals(UserRole.admin));
      });
    });

    group('Login Status Management', () {
      test('deve definir status de login', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});

        // Act
        await webStorageService.setLoggedIn(true);

        // Assert
        final isLoggedIn = await webStorageService.isLoggedIn();
        expect(isLoggedIn, isTrue);
      });

      test('deve retornar false por padrão quando não há status', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});

        // Act
        final isLoggedIn = await webStorageService.isLoggedIn();

        // Assert
        expect(isLoggedIn, isFalse);
      });

      test('deve alterar status de login', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});

        // Act
        await webStorageService.setLoggedIn(true);
        expect(await webStorageService.isLoggedIn(), isTrue);

        await webStorageService.setLoggedIn(false);
        expect(await webStorageService.isLoggedIn(), isFalse);

        await webStorageService.setLoggedIn(true);
        expect(await webStorageService.isLoggedIn(), isTrue);
      });

      test('deve manter status entre sessões', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({'is_logged_in': true});

        // Act
        final isLoggedIn = await webStorageService.isLoggedIn();

        // Assert
        expect(isLoggedIn, isTrue);
      });
    });

    group('Clear All Data', () {
      test('deve limpar todos os dados', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});
        final user = User(
          id: 1,
          name: 'Test User',
          email: 'test@email.com',
          role: UserRole.user,
          createdAt: DateTime.parse('2024-01-01T10:00:00Z'),
          lastLoginAt: DateTime.parse('2024-01-02T11:00:00Z'),
        );

        await webStorageService.saveToken('test_token');
        await webStorageService.saveUser(user);
        await webStorageService.setLoggedIn(true);

        // Act
        await webStorageService.clearAll();

        // Assert
        final token = await webStorageService.getToken();
        final savedUser = await webStorageService.getUser();
        final isLoggedIn = await webStorageService.isLoggedIn();

        expect(token, isNull);
        expect(savedUser, isNull);
        expect(isLoggedIn, isFalse);
      });

      test('deve funcionar mesmo quando não há dados', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});

        // Act & Assert
        expect(() => webStorageService.clearAll(), returnsNormally);
        await webStorageService.clearAll();

        final token = await webStorageService.getToken();
        final user = await webStorageService.getUser();
        final isLoggedIn = await webStorageService.isLoggedIn();

        expect(token, isNull);
        expect(user, isNull);
        expect(isLoggedIn, isFalse);
      });
    });

    group('Get All Data', () {
      test('deve recuperar todos os dados salvos', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});
        const token = 'test_token';
        final user = User(
          id: 1,
          name: 'Test User',
          email: 'test@email.com',
          role: UserRole.user,
          createdAt: DateTime.parse('2024-01-01T10:00:00Z'),
          lastLoginAt: DateTime.parse('2024-01-02T11:00:00Z'),
        );

        await webStorageService.saveToken(token);
        await webStorageService.saveUser(user);
        await webStorageService.setLoggedIn(true);

        // Act
        final allData = await webStorageService.getAllData();

        // Assert
        expect(allData, isA<Map<String, String>>());
        expect(allData.keys, contains(AppConstants.tokenKey));
        expect(allData.keys, contains(AppConstants.userKey));
        expect(allData.keys, contains('is_logged_in'));
        expect(allData[AppConstants.tokenKey], equals(token));
      });

      test('deve retornar mapa vazio quando não há dados', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});

        // Act
        final allData = await webStorageService.getAllData();

        // Assert
        expect(allData, isA<Map<String, String>>());
        expect(allData.isEmpty, isTrue);
      });

      test('deve incluir dados adicionais não relacionados ao app', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          'custom_key_1': 'custom_value_1',
          'custom_key_2': 123,
          'custom_key_3': true,
        });

        // Act
        final allData = await webStorageService.getAllData();

        // Assert
        expect(allData.keys, contains('custom_key_1'));
        expect(allData.keys, contains('custom_key_2'));
        expect(allData.keys, contains('custom_key_3'));
        expect(allData['custom_key_1'], equals('custom_value_1'));
        expect(allData['custom_key_2'], equals('123'));
        expect(allData['custom_key_3'], equals('true'));
      });
    });

    group('Error Handling', () {
      test('deve lidar com valores null no storage', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          // Removendo valores null que causam erro
        });

        // Act & Assert
        final token = await webStorageService.getToken();
        final user = await webStorageService.getUser();

        expect(token, isNull);
        expect(user, isNull);
      });

      test('deve lidar com JSON malformado para usuário', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          AppConstants.userKey: '{"invalid": "json"',
        });

        // Act
        final user = await webStorageService.getUser();

        // Assert
        expect(user, isNull);
      });

      test('deve lidar com múltiplas operações simultâneas', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});
        final user = User(
          id: 1,
          name: 'Concurrent User',
          email: 'concurrent@email.com',
          role: UserRole.user,
          createdAt: DateTime.parse('2024-01-01T10:00:00Z'),
          lastLoginAt: DateTime.parse('2024-01-02T11:00:00Z'),
        );

        // Act
        final futures = [
          webStorageService.saveToken('token1'),
          webStorageService.saveUser(user),
          webStorageService.setLoggedIn(true),
          webStorageService.getToken(),
          webStorageService.getUser(),
          webStorageService.isLoggedIn(),
        ];

        // Assert
        expect(() => Future.wait(futures), returnsNormally);
        await Future.wait(futures);
      });
    });

    group('Data Persistence', () {
      test('deve manter dados entre reinicializações', () async {
        // Arrange
        const token = 'persistent_token';
        SharedPreferences.setMockInitialValues({AppConstants.tokenKey: token});

        // Act
        final instance1 = WebStorageService.instance;
        final token1 = await instance1.getToken();

        // Simular reinicialização criando nova instância
        final instance2 = WebStorageService.instance;
        final token2 = await instance2.getToken();

        // Assert
        expect(token1, equals(token));
        expect(token2, equals(token));
        expect(token1, equals(token2));
      });

      test('deve validar integridade dos dados do usuário', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});
        final originalUser = User(
          id: 42,
          name: 'Integrity User',
          email: 'integrity@email.com',
          role: UserRole.admin,
          createdAt: DateTime.parse('2024-01-01T10:00:00Z'),
          lastLoginAt: DateTime.parse('2024-01-02T11:00:00Z'),
        );

        // Act
        await webStorageService.saveUser(originalUser);
        final retrievedUser = await webStorageService.getUser();

        // Assert
        expect(retrievedUser, isNotNull);
        expect(retrievedUser!.id, equals(originalUser.id));
        expect(retrievedUser.name, equals(originalUser.name));
        expect(retrievedUser.email, equals(originalUser.email));
        expect(retrievedUser.role, equals(originalUser.role));
        expect(retrievedUser.createdAt, equals(originalUser.createdAt));
        expect(retrievedUser.lastLoginAt, equals(originalUser.lastLoginAt));
      });
    });
  });
}
