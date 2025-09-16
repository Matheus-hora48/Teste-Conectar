import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/auth/domain/models/user.dart';

void main() {
  group('User Tests', () {
    final testUser = User(
      id: 1,
      name: 'Test User',
      email: 'test@example.com',
      role: UserRole.user,
      createdAt: DateTime(2024, 1, 1),
      lastLoginAt: DateTime(2024, 1, 2),
    );

    group('Construction', () {
      test('deve criar usuário com todos os parâmetros', () {
        expect(testUser.id, 1);
        expect(testUser.name, 'Test User');
        expect(testUser.email, 'test@example.com');
        expect(testUser.role, UserRole.user);
        expect(testUser.createdAt, DateTime(2024, 1, 1));
        expect(testUser.lastLoginAt, DateTime(2024, 1, 2));
      });

      test('deve criar usuário com campos opcionais nulos', () {
        final user = User(
          id: 1,
          name: 'Test',
          email: 'test@example.com',
          role: UserRole.admin,
        );

        expect(user.createdAt, isNull);
        expect(user.lastLoginAt, isNull);
      });
    });

    group('JSON Serialization', () {
      test('deve criar usuário a partir de JSON', () {
        final json = {
          'id': 1,
          'name': 'Test User',
          'email': 'test@example.com',
          'role': 'admin',
          'createdAt': '2024-01-01T00:00:00.000Z',
          'lastLoginAt': '2024-01-02T00:00:00.000Z',
        };

        final user = User.fromJson(json);

        expect(user.id, 1);
        expect(user.name, 'Test User');
        expect(user.email, 'test@example.com');
        expect(user.role, UserRole.admin);
        expect(user.createdAt, DateTime.parse('2024-01-01T00:00:00.000Z'));
        expect(user.lastLoginAt, DateTime.parse('2024-01-02T00:00:00.000Z'));
      });

      test('deve criar usuário a partir de JSON com role user', () {
        final json = {
          'id': 1,
          'name': 'Test User',
          'email': 'test@example.com',
          'role': 'user',
        };

        final user = User.fromJson(json);
        expect(user.role, UserRole.user);
      });

      test('deve criar usuário com datas nulas', () {
        final json = {
          'id': 1,
          'name': 'Test User',
          'email': 'test@example.com',
          'role': 'user',
          'createdAt': null,
          'lastLoginAt': null,
        };

        final user = User.fromJson(json);
        expect(user.createdAt, isNull);
        expect(user.lastLoginAt, isNull);
      });

      test('deve converter usuário para JSON', () {
        final json = testUser.toJson();

        expect(json['id'], 1);
        expect(json['name'], 'Test User');
        expect(json['email'], 'test@example.com');
        expect(json['role'], 'user');
        expect(json['createdAt'], testUser.createdAt!.toIso8601String());
        expect(json['lastLoginAt'], testUser.lastLoginAt!.toIso8601String());
      });

      test('deve converter admin para JSON', () {
        final adminUser = testUser.copyWith(role: UserRole.admin);
        final json = adminUser.toJson();

        expect(json['role'], 'admin');
      });

      test('deve converter usuário com datas nulas para JSON', () {
        final userWithNullDates = User(
          id: 1,
          name: 'Test',
          email: 'test@example.com',
          role: UserRole.user,
        );

        final json = userWithNullDates.toJson();
        expect(json['createdAt'], isNull);
        expect(json['lastLoginAt'], isNull);
      });
    });

    group('copyWith', () {
      test('deve criar cópia com novos valores', () {
        final copiedUser = testUser.copyWith(
          name: 'New Name',
          email: 'new@example.com',
          role: UserRole.admin,
        );

        expect(copiedUser.id, testUser.id);
        expect(copiedUser.name, 'New Name');
        expect(copiedUser.email, 'new@example.com');
        expect(copiedUser.role, UserRole.admin);
        expect(copiedUser.createdAt, testUser.createdAt);
        expect(copiedUser.lastLoginAt, testUser.lastLoginAt);
      });

      test('deve manter valores originais quando não especificado', () {
        final copiedUser = testUser.copyWith();

        expect(copiedUser.id, testUser.id);
        expect(copiedUser.name, testUser.name);
        expect(copiedUser.email, testUser.email);
        expect(copiedUser.role, testUser.role);
        expect(copiedUser.createdAt, testUser.createdAt);
        expect(copiedUser.lastLoginAt, testUser.lastLoginAt);
      });
    });

    group('isAdmin getter', () {
      test('deve retornar true para admin', () {
        final adminUser = testUser.copyWith(role: UserRole.admin);
        expect(adminUser.isAdmin, isTrue);
      });

      test('deve retornar false para user', () {
        expect(testUser.isAdmin, isFalse);
      });
    });

    group('Equatable', () {
      test('deve ser igual para mesmos dados', () {
        final otherUser = User(
          id: 1,
          name: 'Test User',
          email: 'test@example.com',
          role: UserRole.user,
          createdAt: DateTime(2024, 1, 1),
          lastLoginAt: DateTime(2024, 1, 2),
        );

        expect(testUser, equals(otherUser));
      });

      test('deve ser diferente para dados diferentes', () {
        final differentUser = testUser.copyWith(name: 'Different Name');
        expect(testUser, isNot(equals(differentUser)));
      });

      test('deve ter mesmo hashCode para objetos iguais', () {
        final otherUser = User(
          id: testUser.id,
          name: testUser.name,
          email: testUser.email,
          role: testUser.role,
          createdAt: testUser.createdAt,
          lastLoginAt: testUser.lastLoginAt,
        );

        expect(testUser.hashCode, equals(otherUser.hashCode));
      });
    });
  });

  group('UserRole Tests', () {
    test('deve ter valores corretos para enum', () {
      expect(UserRole.admin.toString(), 'UserRole.admin');
      expect(UserRole.user.toString(), 'UserRole.user');
    });
  });
}
