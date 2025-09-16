import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/profile/domain/entities/profile_user.dart';

void main() {
  group('ProfileUser Tests', () {
    final testProfileUser = ProfileUser(
      id: 1,
      name: 'Test User',
      email: 'test@example.com',
      role: 'admin',
      createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      updatedAt: DateTime.parse('2024-01-15T12:30:00.000Z'),
    );

    group('Construction', () {
      test('deve criar ProfileUser com todos os parâmetros', () {
        expect(testProfileUser.id, equals(1));
        expect(testProfileUser.name, equals('Test User'));
        expect(testProfileUser.email, equals('test@example.com'));
        expect(testProfileUser.role, equals('admin'));
        expect(
          testProfileUser.createdAt,
          equals(DateTime.parse('2024-01-01T00:00:00.000Z')),
        );
        expect(
          testProfileUser.updatedAt,
          equals(DateTime.parse('2024-01-15T12:30:00.000Z')),
        );
      });

      test('deve criar ProfileUser com campos opcionais nulos', () {
        final user = ProfileUser(
          id: 2,
          name: 'Simple User',
          email: 'simple@example.com',
          role: 'user',
        );

        expect(user.id, equals(2));
        expect(user.name, equals('Simple User'));
        expect(user.email, equals('simple@example.com'));
        expect(user.role, equals('user'));
        expect(user.createdAt, isNull);
        expect(user.updatedAt, isNull);
      });
    });

    group('fromJson', () {
      test('deve criar ProfileUser a partir de JSON completo', () {
        final json = {
          'id': 1,
          'name': 'Test User',
          'email': 'test@example.com',
          'role': 'admin',
          'createdAt': '2024-01-01T00:00:00.000Z',
          'updatedAt': '2024-01-15T12:30:00.000Z',
        };

        final user = ProfileUser.fromJson(json);

        expect(user.id, equals(1));
        expect(user.name, equals('Test User'));
        expect(user.email, equals('test@example.com'));
        expect(user.role, equals('admin'));
        expect(
          user.createdAt,
          equals(DateTime.parse('2024-01-01T00:00:00.000Z')),
        );
        expect(
          user.updatedAt,
          equals(DateTime.parse('2024-01-15T12:30:00.000Z')),
        );
      });

      test('deve criar ProfileUser a partir de JSON sem datas', () {
        final json = {
          'id': 2,
          'name': 'Simple User',
          'email': 'simple@example.com',
          'role': 'user',
          'createdAt': null,
          'updatedAt': null,
        };

        final user = ProfileUser.fromJson(json);

        expect(user.id, equals(2));
        expect(user.name, equals('Simple User'));
        expect(user.email, equals('simple@example.com'));
        expect(user.role, equals('user'));
        expect(user.createdAt, isNull);
        expect(user.updatedAt, isNull);
      });

      test('deve criar ProfileUser a partir de JSON sem campos opcionais', () {
        final json = {
          'id': 3,
          'name': 'Minimal User',
          'email': 'minimal@example.com',
          'role': 'user',
        };

        final user = ProfileUser.fromJson(json);

        expect(user.id, equals(3));
        expect(user.name, equals('Minimal User'));
        expect(user.email, equals('minimal@example.com'));
        expect(user.role, equals('user'));
        expect(user.createdAt, isNull);
        expect(user.updatedAt, isNull);
      });
    });

    group('toJson', () {
      test('deve converter ProfileUser para JSON completo', () {
        final json = testProfileUser.toJson();

        expect(json['id'], equals(1));
        expect(json['name'], equals('Test User'));
        expect(json['email'], equals('test@example.com'));
        expect(json['role'], equals('admin'));
        expect(json['createdAt'], equals('2024-01-01T00:00:00.000Z'));
        expect(json['updatedAt'], equals('2024-01-15T12:30:00.000Z'));
      });

      test('deve converter ProfileUser para JSON com datas nulas', () {
        final userWithoutDates = ProfileUser(
          id: 2,
          name: 'Simple User',
          email: 'simple@example.com',
          role: 'user',
        );

        final json = userWithoutDates.toJson();

        expect(json['id'], equals(2));
        expect(json['name'], equals('Simple User'));
        expect(json['email'], equals('simple@example.com'));
        expect(json['role'], equals('user'));
        expect(json['createdAt'], isNull);
        expect(json['updatedAt'], isNull);
      });
    });

    group('copyWith', () {
      test('deve criar cópia com novos valores', () {
        final copiedUser = testProfileUser.copyWith(
          name: 'Updated User',
          email: 'updated@example.com',
          role: 'user',
        );

        expect(copiedUser.id, equals(testProfileUser.id));
        expect(copiedUser.name, equals('Updated User'));
        expect(copiedUser.email, equals('updated@example.com'));
        expect(copiedUser.role, equals('user'));
        expect(copiedUser.createdAt, equals(testProfileUser.createdAt));
        expect(copiedUser.updatedAt, equals(testProfileUser.updatedAt));
      });

      test('deve manter valores originais quando não especificado', () {
        final copiedUser = testProfileUser.copyWith();

        expect(copiedUser.id, equals(testProfileUser.id));
        expect(copiedUser.name, equals(testProfileUser.name));
        expect(copiedUser.email, equals(testProfileUser.email));
        expect(copiedUser.role, equals(testProfileUser.role));
        expect(copiedUser.createdAt, equals(testProfileUser.createdAt));
        expect(copiedUser.updatedAt, equals(testProfileUser.updatedAt));
      });

      test('deve atualizar apenas campos específicos', () {
        final copiedUser = testProfileUser.copyWith(name: 'New Name Only');

        expect(copiedUser.id, equals(testProfileUser.id));
        expect(copiedUser.name, equals('New Name Only'));
        expect(copiedUser.email, equals(testProfileUser.email));
        expect(copiedUser.role, equals(testProfileUser.role));
        expect(copiedUser.createdAt, equals(testProfileUser.createdAt));
        expect(copiedUser.updatedAt, equals(testProfileUser.updatedAt));
      });
    });
  });

  group('UpdateProfileRequest Tests', () {
    test('deve criar UpdateProfileRequest corretamente', () {
      final request = UpdateProfileRequest(
        name: 'Updated Name',
        email: 'updated@example.com',
      );

      expect(request.name, equals('Updated Name'));
      expect(request.email, equals('updated@example.com'));
    });

    test('deve converter UpdateProfileRequest para JSON', () {
      final request = UpdateProfileRequest(
        name: 'Test Name',
        email: 'test@example.com',
      );

      final json = request.toJson();

      expect(json['name'], equals('Test Name'));
      expect(json['email'], equals('test@example.com'));
      expect(json.keys, hasLength(2));
    });
  });

  group('UpdatePasswordRequest Tests', () {
    test('deve criar UpdatePasswordRequest corretamente', () {
      final request = UpdatePasswordRequest(
        currentPassword: 'currentPass123',
        newPassword: 'newPass456',
      );

      expect(request.currentPassword, equals('currentPass123'));
      expect(request.newPassword, equals('newPass456'));
    });

    test('deve converter UpdatePasswordRequest para JSON', () {
      final request = UpdatePasswordRequest(
        currentPassword: 'oldPassword',
        newPassword: 'newPassword',
      );

      final json = request.toJson();

      expect(json['currentPassword'], equals('oldPassword'));
      expect(json['newPassword'], equals('newPassword'));
      expect(json.keys, hasLength(2));
    });
  });
}
