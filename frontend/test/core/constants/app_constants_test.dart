import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/constants/app_constants.dart';

void main() {
  group('AppConstants Tests', () {
    group('Application Constants', () {
      test('deve ter nome da aplicação correto', () {
        // Assert
        expect(AppConstants.appName, equals('Conéctar'));
        expect(AppConstants.appName, isNotEmpty);
        expect(AppConstants.appName, isA<String>());
      });

      test('deve ter base URL configurada', () {
        // Assert
        expect(AppConstants.baseUrl, equals('http://localhost:3010'));
        expect(AppConstants.baseUrl, isNotEmpty);
        expect(AppConstants.baseUrl, startsWith('http'));
      });

      test('deve ter base URL no formato correto', () {
        // Assert
        final uri = Uri.tryParse(AppConstants.baseUrl);
        expect(uri, isNotNull);
        expect(uri!.isAbsolute, isTrue);
        expect(uri.host, equals('localhost'));
        expect(uri.port, equals(3010));
      });
    });

    group('API Endpoints', () {
      test('deve ter endpoints de autenticação definidos', () {
        // Assert
        expect(AppConstants.authLogin, equals('/auth/login'));
        expect(AppConstants.authRegister, equals('/auth/register'));
        expect(AppConstants.authLogin, startsWith('/'));
        expect(AppConstants.authRegister, startsWith('/'));
      });

      test('deve ter endpoints de recursos definidos', () {
        // Assert
        expect(AppConstants.users, equals('/users'));
        expect(AppConstants.clients, equals('/clients'));
        expect(AppConstants.users, startsWith('/'));
        expect(AppConstants.clients, startsWith('/'));
      });

      test('deve ter endpoints consistentes com padrão REST', () {
        // Assert
        final endpoints = [
          AppConstants.authLogin,
          AppConstants.authRegister,
          AppConstants.users,
          AppConstants.clients,
        ];

        for (final endpoint in endpoints) {
          expect(endpoint, startsWith('/'));
          expect(endpoint, isNotEmpty);
          expect(endpoint.contains(' '), isFalse);
        }
      });

      test('deve ter endpoints únicos', () {
        // Arrange
        final endpoints = [
          AppConstants.authLogin,
          AppConstants.authRegister,
          AppConstants.users,
          AppConstants.clients,
        ];

        // Assert
        final uniqueEndpoints = endpoints.toSet();
        expect(uniqueEndpoints.length, equals(endpoints.length));
      });
    });

    group('Storage Keys', () {
      test('deve ter chaves de storage definidas', () {
        // Assert
        expect(AppConstants.tokenKey, equals('auth_token'));
        expect(AppConstants.userKey, equals('user_data'));
        expect(AppConstants.isLoggedInKey, equals('is_logged_in_key'));
      });

      test('deve ter chaves de storage não vazias', () {
        // Assert
        expect(AppConstants.tokenKey, isNotEmpty);
        expect(AppConstants.userKey, isNotEmpty);
        expect(AppConstants.isLoggedInKey, isNotEmpty);
      });

      test('deve ter chaves de storage únicas', () {
        // Arrange
        final keys = [
          AppConstants.tokenKey,
          AppConstants.userKey,
          AppConstants.isLoggedInKey,
        ];

        // Assert
        final uniqueKeys = keys.toSet();
        expect(uniqueKeys.length, equals(keys.length));
      });

      test('deve ter chaves de storage seguindo convenção', () {
        // Assert
        expect(AppConstants.tokenKey, contains('token'));
        expect(AppConstants.userKey, contains('user'));
        expect(AppConstants.isLoggedInKey, contains('logged_in'));

        // Verificar formato snake_case
        expect(AppConstants.tokenKey.contains(' '), isFalse);
        expect(AppConstants.userKey.contains(' '), isFalse);
        expect(AppConstants.isLoggedInKey.contains(' '), isFalse);
      });
    });

    group('Route Constants', () {
      test('deve ter rotas principais definidas', () {
        // Assert
        expect(AppConstants.loginRoute, equals('/login'));
        expect(AppConstants.registerRoute, equals('/register'));
        expect(AppConstants.homeRoute, equals('/home'));
        expect(AppConstants.profileRoute, equals('/profile'));
      });

      test('deve ter rotas de clientes definidas', () {
        // Assert
        expect(AppConstants.clientsRoute, equals('/clients'));
        expect(AppConstants.clientFormRoute, equals('/clients/form'));
      });

      test('deve ter todas as rotas começando com /', () {
        // Arrange
        final routes = [
          AppConstants.loginRoute,
          AppConstants.registerRoute,
          AppConstants.homeRoute,
          AppConstants.clientsRoute,
          AppConstants.clientFormRoute,
          AppConstants.profileRoute,
        ];

        // Assert
        for (final route in routes) {
          expect(route, startsWith('/'));
          expect(route, isNotEmpty);
        }
      });

      test('deve ter rotas únicas', () {
        // Arrange
        final routes = [
          AppConstants.loginRoute,
          AppConstants.registerRoute,
          AppConstants.homeRoute,
          AppConstants.clientsRoute,
          AppConstants.clientFormRoute,
          AppConstants.profileRoute,
        ];

        // Assert
        final uniqueRoutes = routes.toSet();
        expect(uniqueRoutes.length, equals(routes.length));
      });

      test('deve ter rotas seguindo padrão hierárquico', () {
        // Assert
        expect(
          AppConstants.clientFormRoute,
          startsWith(AppConstants.clientsRoute),
        );
        expect(AppConstants.clientFormRoute, contains('/form'));
      });

      test('deve ter rotas sem espaços ou caracteres especiais', () {
        // Arrange
        final routes = [
          AppConstants.loginRoute,
          AppConstants.registerRoute,
          AppConstants.homeRoute,
          AppConstants.clientsRoute,
          AppConstants.clientFormRoute,
          AppConstants.profileRoute,
        ];

        // Assert
        for (final route in routes) {
          expect(route.contains(' '), isFalse);
          expect(route.contains('?'), isFalse);
          expect(route.contains('#'), isFalse);
          expect(route.contains('&'), isFalse);
        }
      });
    });

    group('Constants Integrity', () {
      test('deve ter todos os valores como String', () {
        // Assert
        expect(AppConstants.appName, isA<String>());
        expect(AppConstants.baseUrl, isA<String>());
        expect(AppConstants.authLogin, isA<String>());
        expect(AppConstants.authRegister, isA<String>());
        expect(AppConstants.users, isA<String>());
        expect(AppConstants.clients, isA<String>());
        expect(AppConstants.tokenKey, isA<String>());
        expect(AppConstants.userKey, isA<String>());
        expect(AppConstants.isLoggedInKey, isA<String>());
        expect(AppConstants.loginRoute, isA<String>());
        expect(AppConstants.registerRoute, isA<String>());
        expect(AppConstants.homeRoute, isA<String>());
        expect(AppConstants.clientsRoute, isA<String>());
        expect(AppConstants.clientFormRoute, isA<String>());
        expect(AppConstants.profileRoute, isA<String>());
      });

      test('deve ter valores const imutáveis', () {
        // Arrange & Act
        final originalAppName = AppConstants.appName;
        final originalBaseUrl = AppConstants.baseUrl;

        // Assert - Valores devem permanecer os mesmos
        expect(AppConstants.appName, equals(originalAppName));
        expect(AppConstants.baseUrl, equals(originalBaseUrl));
      });

      test('deve ter nenhuma propriedade nula', () {
        // Assert
        expect(AppConstants.appName, isNotNull);
        expect(AppConstants.baseUrl, isNotNull);
        expect(AppConstants.authLogin, isNotNull);
        expect(AppConstants.authRegister, isNotNull);
        expect(AppConstants.users, isNotNull);
        expect(AppConstants.clients, isNotNull);
        expect(AppConstants.tokenKey, isNotNull);
        expect(AppConstants.userKey, isNotNull);
        expect(AppConstants.isLoggedInKey, isNotNull);
        expect(AppConstants.loginRoute, isNotNull);
        expect(AppConstants.registerRoute, isNotNull);
        expect(AppConstants.homeRoute, isNotNull);
        expect(AppConstants.clientsRoute, isNotNull);
        expect(AppConstants.clientFormRoute, isNotNull);
        expect(AppConstants.profileRoute, isNotNull);
      });

      test('deve manter consistência entre endpoints relacionados', () {
        // Assert
        expect(AppConstants.authLogin, contains('auth'));
        expect(AppConstants.authRegister, contains('auth'));
        expect(AppConstants.clientsRoute, contains('clients'));
        expect(AppConstants.clientFormRoute, contains('clients'));
      });
    });

    group('URL Construction', () {
      test('deve permitir construção correta de URLs completas', () {
        // Act
        final loginUrl = AppConstants.baseUrl + AppConstants.authLogin;
        final registerUrl = AppConstants.baseUrl + AppConstants.authRegister;
        final usersUrl = AppConstants.baseUrl + AppConstants.users;
        final clientsUrl = AppConstants.baseUrl + AppConstants.clients;

        // Assert
        expect(loginUrl, equals('http://localhost:3010/auth/login'));
        expect(registerUrl, equals('http://localhost:3010/auth/register'));
        expect(usersUrl, equals('http://localhost:3010/users'));
        expect(clientsUrl, equals('http://localhost:3010/clients'));

        // Verificar se são URLs válidas
        expect(Uri.tryParse(loginUrl), isNotNull);
        expect(Uri.tryParse(registerUrl), isNotNull);
        expect(Uri.tryParse(usersUrl), isNotNull);
        expect(Uri.tryParse(clientsUrl), isNotNull);
      });

      test('deve gerar URLs sem duplas barras', () {
        // Act
        final urls = [
          AppConstants.baseUrl + AppConstants.authLogin,
          AppConstants.baseUrl + AppConstants.authRegister,
          AppConstants.baseUrl + AppConstants.users,
          AppConstants.baseUrl + AppConstants.clients,
        ];

        // Assert
        for (final url in urls) {
          expect(url.contains('://'), isTrue); // Protocolo
          expect(url.contains('//'), isTrue); // Apenas no protocolo
          expect(
            url.indexOf('//'),
            equals(url.lastIndexOf('//')),
          ); // Apenas uma ocorrência
        }
      });
    });
  });
}
