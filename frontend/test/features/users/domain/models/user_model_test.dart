import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/users/domain/models/user_model.dart';

void main() {
  group('UserModel Tests', () {
    final testUser = UserModel(
      id: 1,
      name: 'Test User',
      email: 'test@example.com',
      role: UserRole.user,
      status: UserStatus.ativo,
      createdAt: DateTime(2024, 1, 1),
      lastLoginAt: DateTime(2024, 1, 2),
      phone: '11999999999',
      department: 'IT',
    );

    group('Construction', () {
      test('deve criar usuário com todos os parâmetros', () {
        expect(testUser.id, 1);
        expect(testUser.name, 'Test User');
        expect(testUser.email, 'test@example.com');
        expect(testUser.role, UserRole.user);
        expect(testUser.status, UserStatus.ativo);
        expect(testUser.createdAt, DateTime(2024, 1, 1));
        expect(testUser.lastLoginAt, DateTime(2024, 1, 2));
        expect(testUser.phone, '11999999999');
        expect(testUser.department, 'IT');
      });

      test('deve criar usuário com campos opcionais nulos', () {
        final user = UserModel(
          id: 1,
          name: 'Test',
          email: 'test@example.com',
          role: UserRole.admin,
          status: UserStatus.pendente,
        );

        expect(user.createdAt, isNull);
        expect(user.lastLoginAt, isNull);
        expect(user.phone, isNull);
        expect(user.department, isNull);
      });
    });

    group('JSON Serialization', () {
      test('deve criar usuário a partir de JSON completo', () {
        final json = {
          'id': 1,
          'name': 'Test User',
          'email': 'test@example.com',
          'role': 'admin',
          'status': 'ativo',
          'createdAt': '2024-01-01T00:00:00.000Z',
          'lastLoginAt': '2024-01-02T00:00:00.000Z',
          'phone': '11999999999',
          'department': 'IT',
        };

        final user = UserModel.fromJson(json);

        expect(user.id, 1);
        expect(user.name, 'Test User');
        expect(user.email, 'test@example.com');
        expect(user.role, UserRole.admin);
        expect(user.status, UserStatus.ativo);
        expect(user.createdAt, DateTime.parse('2024-01-01T00:00:00.000Z'));
        expect(user.lastLoginAt, DateTime.parse('2024-01-02T00:00:00.000Z'));
        expect(user.phone, '11999999999');
        expect(user.department, 'IT');
      });

      test('deve criar usuário com campos mínimos', () {
        final json = {
          'id': 1,
          'name': 'Test User',
          'email': 'test@example.com',
          'role': 'user',
          'status': 'pendente',
        };

        final user = UserModel.fromJson(json);
        expect(user.role, UserRole.user);
        expect(user.status, UserStatus.pendente);
        expect(user.createdAt, isNull);
        expect(user.lastLoginAt, isNull);
        expect(user.phone, isNull);
        expect(user.department, isNull);
      });

      test('deve usar status padrão para valor inválido', () {
        final json = {
          'id': 1,
          'name': 'Test User',
          'email': 'test@example.com',
          'role': 'user',
          'status': 'invalid_status',
        };

        final user = UserModel.fromJson(json);
        expect(user.status, UserStatus.ativo);
      });

      test('deve usar status padrão para valor nulo', () {
        final json = {
          'id': 1,
          'name': 'Test User',
          'email': 'test@example.com',
          'role': 'user',
          'status': null,
        };

        final user = UserModel.fromJson(json);
        expect(user.status, UserStatus.ativo);
      });

      test('deve converter usuário para JSON', () {
        final json = testUser.toJson();

        expect(json['id'], 1);
        expect(json['name'], 'Test User');
        expect(json['email'], 'test@example.com');
        expect(json['role'], 'user');
        expect(json['status'], 'ativo');
        expect(json['createdAt'], testUser.createdAt!.toIso8601String());
        expect(json['lastLoginAt'], testUser.lastLoginAt!.toIso8601String());
        expect(json['phone'], '11999999999');
        expect(json['department'], 'IT');
      });

      test('deve converter admin para JSON', () {
        final adminUser = testUser.copyWith(role: UserRole.admin);
        final json = adminUser.toJson();

        expect(json['role'], 'admin');
      });

      test('deve converter diferentes status para JSON', () {
        final inactiveUser = testUser.copyWith(status: UserStatus.inativo);
        final pendingUser = testUser.copyWith(status: UserStatus.pendente);

        expect(inactiveUser.toJson()['status'], 'inativo');
        expect(pendingUser.toJson()['status'], 'pendente');
      });
    });

    group('copyWith', () {
      test('deve criar cópia com novos valores', () {
        final copiedUser = testUser.copyWith(
          name: 'New Name',
          email: 'new@example.com',
          role: UserRole.admin,
          status: UserStatus.inativo,
          phone: '11888888888',
          department: 'HR',
        );

        expect(copiedUser.id, testUser.id);
        expect(copiedUser.name, 'New Name');
        expect(copiedUser.email, 'new@example.com');
        expect(copiedUser.role, UserRole.admin);
        expect(copiedUser.status, UserStatus.inativo);
        expect(copiedUser.phone, '11888888888');
        expect(copiedUser.department, 'HR');
        expect(copiedUser.createdAt, testUser.createdAt);
        expect(copiedUser.lastLoginAt, testUser.lastLoginAt);
      });

      test('deve manter valores originais quando não especificado', () {
        final copiedUser = testUser.copyWith();

        expect(copiedUser.id, testUser.id);
        expect(copiedUser.name, testUser.name);
        expect(copiedUser.email, testUser.email);
        expect(copiedUser.role, testUser.role);
        expect(copiedUser.status, testUser.status);
        expect(copiedUser.createdAt, testUser.createdAt);
        expect(copiedUser.lastLoginAt, testUser.lastLoginAt);
        expect(copiedUser.phone, testUser.phone);
        expect(copiedUser.department, testUser.department);
      });
    });

    group('Equatable', () {
      test('deve ser igual para mesmos dados', () {
        final otherUser = UserModel(
          id: 1,
          name: 'Test User',
          email: 'test@example.com',
          role: UserRole.user,
          status: UserStatus.ativo,
          createdAt: DateTime(2024, 1, 1),
          lastLoginAt: DateTime(2024, 1, 2),
          phone: '11999999999',
          department: 'IT',
        );

        expect(testUser, equals(otherUser));
      });

      test('deve ser diferente para dados diferentes', () {
        final differentUser = testUser.copyWith(name: 'Different Name');
        expect(testUser, isNot(equals(differentUser)));
      });

      test('deve ter mesmo hashCode para objetos iguais', () {
        final otherUser = UserModel(
          id: testUser.id,
          name: testUser.name,
          email: testUser.email,
          role: testUser.role,
          status: testUser.status,
          createdAt: testUser.createdAt,
          lastLoginAt: testUser.lastLoginAt,
          phone: testUser.phone,
          department: testUser.department,
        );

        expect(testUser.hashCode, equals(otherUser.hashCode));
      });
    });
  });

  group('UserRole Tests', () {
    test('deve ter valores corretos para enum', () {
      expect(UserRole.admin.name, 'admin');
      expect(UserRole.user.name, 'user');
    });
  });

  group('UserStatus Tests', () {
    test('deve ter valores corretos para enum', () {
      expect(UserStatus.ativo.name, 'ativo');
      expect(UserStatus.inativo.name, 'inativo');
      expect(UserStatus.pendente.name, 'pendente');
    });

    test('_statusFromString deve converter corretamente', () {
      final jsonAtivo = {
        'id': 1,
        'name': 'Test',
        'email': 'test@test.com',
        'role': 'user',
        'status': 'ativo',
      };
      final jsonInativo = {
        'id': 1,
        'name': 'Test',
        'email': 'test@test.com',
        'role': 'user',
        'status': 'inativo',
      };
      final jsonPendente = {
        'id': 1,
        'name': 'Test',
        'email': 'test@test.com',
        'role': 'user',
        'status': 'pendente',
      };
      final jsonInvalido = {
        'id': 1,
        'name': 'Test',
        'email': 'test@test.com',
        'role': 'user',
        'status': 'invalid',
      };

      expect(UserModel.fromJson(jsonAtivo).status, UserStatus.ativo);
      expect(UserModel.fromJson(jsonInativo).status, UserStatus.inativo);
      expect(UserModel.fromJson(jsonPendente).status, UserStatus.pendente);
      expect(UserModel.fromJson(jsonInvalido).status, UserStatus.ativo);
    });
  });
}
