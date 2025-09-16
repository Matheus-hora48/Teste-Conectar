import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/auth/domain/models/auth_response.dart';
import 'package:frontend/features/auth/domain/models/user.dart';

void main() {
  group('AuthResponse Tests', () {
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

    group('Construction', () {
      test('deve criar AuthResponse com token e usuário', () {
        expect(testAuthResponse.accessToken, 'test_token_123');
        expect(testAuthResponse.user, testUser);
      });
    });

    group('JSON Serialization', () {
      test('deve criar AuthResponse a partir de JSON', () {
        final json = {
          'access_token': 'test_token_123',
          'user': {
            'id': 1,
            'name': 'Test User',
            'email': 'test@example.com',
            'role': 'user',
          },
        };

        final authResponse = AuthResponse.fromJson(json);

        expect(authResponse.accessToken, 'test_token_123');
        expect(authResponse.user.id, 1);
        expect(authResponse.user.name, 'Test User');
        expect(authResponse.user.email, 'test@example.com');
        expect(authResponse.user.role, UserRole.user);
      });

      test('deve converter AuthResponse para JSON', () {
        final json = testAuthResponse.toJson();

        expect(json['access_token'], 'test_token_123');
        expect(json['user']['id'], 1);
        expect(json['user']['name'], 'Test User');
        expect(json['user']['email'], 'test@example.com');
        expect(json['user']['role'], 'user');
      });
    });

    group('Equatable', () {
      test('deve ser igual para mesmos dados', () {
        final otherAuthResponse = AuthResponse(
          accessToken: 'test_token_123',
          user: testUser,
        );

        expect(testAuthResponse, equals(otherAuthResponse));
      });

      test('deve ser diferente para tokens diferentes', () {
        final differentAuthResponse = AuthResponse(
          accessToken: 'different_token',
          user: testUser,
        );

        expect(testAuthResponse, isNot(equals(differentAuthResponse)));
      });

      test('deve ser diferente para usuários diferentes', () {
        final differentUser = testUser.copyWith(name: 'Different User');
        final differentAuthResponse = AuthResponse(
          accessToken: 'test_token_123',
          user: differentUser,
        );

        expect(testAuthResponse, isNot(equals(differentAuthResponse)));
      });

      test('deve ter mesmo hashCode para objetos iguais', () {
        final otherAuthResponse = AuthResponse(
          accessToken: 'test_token_123',
          user: testUser,
        );

        expect(testAuthResponse.hashCode, equals(otherAuthResponse.hashCode));
      });
    });
  });
}
