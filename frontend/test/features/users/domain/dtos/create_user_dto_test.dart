import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/users/domain/dtos/create_user_dto.dart';
import 'package:frontend/features/users/domain/models/user_model.dart';

void main() {
  group('CreateUserDto', () {
    test('should create instance with required fields', () {
      const name = 'João Silva';
      const email = 'joao@email.com';
      const password = 'senha123';
      const role = UserRole.user;

      final dto = CreateUserDto(
        name: name,
        email: email,
        password: password,
        role: role,
      );

      expect(dto.name, equals(name));
      expect(dto.email, equals(email));
      expect(dto.password, equals(password));
      expect(dto.role, equals(role));
    });

    test('should create admin user dto', () {
      final dto = CreateUserDto(
        name: 'Admin User',
        email: 'admin@company.com',
        password: 'adminPass123',
        role: UserRole.admin,
      );

      expect(dto.role, equals(UserRole.admin));
      expect(dto.name, equals('Admin User'));
    });

    test('should create regular user dto', () {
      final dto = CreateUserDto(
        name: 'Regular User',
        email: 'user@company.com',
        password: 'userPass123',
        role: UserRole.user,
      );

      expect(dto.role, equals(UserRole.user));
      expect(dto.name, equals('Regular User'));
    });

    group('toJson', () {
      test('should convert admin user dto to json', () {
        final dto = CreateUserDto(
          name: 'Maria Santos',
          email: 'maria@company.com',
          password: 'senha456',
          role: UserRole.admin,
        );

        final json = dto.toJson();

        expect(
          json,
          equals({
            'name': 'Maria Santos',
            'email': 'maria@company.com',
            'password': 'senha456',
            'role': 'admin',
          }),
        );
      });

      test('should convert regular user dto to json', () {
        final dto = CreateUserDto(
          name: 'Pedro Costa',
          email: 'pedro@company.com',
          password: 'senha789',
          role: UserRole.user,
        );

        final json = dto.toJson();

        expect(
          json,
          equals({
            'name': 'Pedro Costa',
            'email': 'pedro@company.com',
            'password': 'senha789',
            'role': 'user',
          }),
        );
      });

      test('should include all required fields in json', () {
        final dto = CreateUserDto(
          name: 'Ana Oliveira',
          email: 'ana@test.com',
          password: 'testPassword',
          role: UserRole.user,
        );

        final json = dto.toJson();

        expect(json.keys.length, equals(4));
        expect(json, containsPair('name', 'Ana Oliveira'));
        expect(json, containsPair('email', 'ana@test.com'));
        expect(json, containsPair('password', 'testPassword'));
        expect(json, containsPair('role', 'user'));
      });

      test('should use role.name for role serialization', () {
        final adminDto = CreateUserDto(
          name: 'Admin',
          email: 'admin@test.com',
          password: 'pass',
          role: UserRole.admin,
        );

        final userDto = CreateUserDto(
          name: 'User',
          email: 'user@test.com',
          password: 'pass',
          role: UserRole.user,
        );

        final adminJson = adminDto.toJson();
        final userJson = userDto.toJson();

        expect(adminJson['role'], equals('admin'));
        expect(userJson['role'], equals('user'));
      });
    });

    group('edge cases', () {
      test('should handle empty strings', () {
        final dto = CreateUserDto(
          name: '',
          email: '',
          password: '',
          role: UserRole.user,
        );

        expect(dto.name, equals(''));
        expect(dto.email, equals(''));
        expect(dto.password, equals(''));
        expect(dto.role, equals(UserRole.user));
      });

      test('should handle special characters in fields', () {
        const name = 'José da Silva-Oliveira Jr.';
        const email = 'josé.silva+test@company.com.br';
        const password = 'P@ssw0rd!#123';

        final dto = CreateUserDto(
          name: name,
          email: email,
          password: password,
          role: UserRole.admin,
        );

        expect(dto.name, equals(name));
        expect(dto.email, equals(email));
        expect(dto.password, equals(password));

        final json = dto.toJson();
        expect(json['name'], equals(name));
        expect(json['email'], equals(email));
        expect(json['password'], equals(password));
      });

      test('should handle long strings', () {
        final longName = 'A' * 100;
        final longEmail = '${'b' * 50}@${'c' * 40}.com';
        final longPassword = 'D' * 200;

        final dto = CreateUserDto(
          name: longName,
          email: longEmail,
          password: longPassword,
          role: UserRole.user,
        );

        expect(dto.name.length, equals(100));
        expect(dto.email.length, equals(95));
        expect(dto.password.length, equals(200));
      });
    });
  });
}
