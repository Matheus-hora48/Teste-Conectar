import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get/get.dart';
import 'package:frontend/features/users/presentation/controllers/users_controller.dart';
import 'package:frontend/features/users/domain/usecases/get_users.dart';
import 'package:frontend/features/users/domain/usecases/create_user.dart';
import 'package:frontend/features/users/domain/usecases/update_user.dart';
import 'package:frontend/features/users/domain/usecases/delete_user.dart';
import 'package:frontend/features/users/domain/models/user_model.dart';
import 'package:frontend/core/network/api_service.dart';

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUser extends Mock implements CreateUser {}

class MockUpdateUser extends Mock implements UpdateUser {}

class MockDeleteUser extends Mock implements DeleteUser {}

class MockApiService extends Mock implements ApiService {}

void main() {
  late UsersController usersController;
  late MockGetUsers mockGetUsers;
  late MockCreateUser mockCreateUser;
  late MockUpdateUser mockUpdateUser;
  late MockDeleteUser mockDeleteUser;
  late MockApiService mockApiService;

  setUp(() {
    mockGetUsers = MockGetUsers();
    mockCreateUser = MockCreateUser();
    mockUpdateUser = MockUpdateUser();
    mockDeleteUser = MockDeleteUser();
    mockApiService = MockApiService();

    Get.testMode = true;

    usersController = UsersController(
      mockGetUsers,
      mockCreateUser,
      mockUpdateUser,
      mockDeleteUser,
      mockApiService,
    );

    registerFallbackValue(
      UserModel(
        id: 0,
        name: '',
        email: '',
        role: UserRole.user,
        status: UserStatus.ativo,
      ),
    );
  });

  tearDown(() {
    Get.reset();
  });

  group('UsersController Tests', () {
    final testUsers = [
      UserModel(
        id: 1,
        name: 'User One',
        email: 'user1@example.com',
        role: UserRole.user,
        status: UserStatus.ativo,
        phone: '11999999999',
        department: 'IT',
      ),
      UserModel(
        id: 2,
        name: 'Admin User',
        email: 'admin@example.com',
        role: UserRole.admin,
        status: UserStatus.ativo,
        phone: '11888888888',
        department: 'HR',
      ),
    ];

    group('Initial State', () {
      test('deve ter estado inicial correto', () {
        expect(usersController.users, isEmpty);
        expect(usersController.isLoading, isFalse);
        expect(usersController.errorMessage, isEmpty);
        expect(usersController.nameFilter, isEmpty);
        expect(usersController.emailFilter, isEmpty);
        expect(usersController.statusFilter, isNull);
        expect(usersController.roleFilter, isNull);
      });
    });

    group('loadUsers', () {
      test('deve carregar usuários com sucesso', () async {
        when(
          () => mockGetUsers(
            name: any(named: 'name'),
            email: any(named: 'email'),
            status: any(named: 'status'),
            role: any(named: 'role'),
          ),
        ).thenAnswer((_) async => testUsers);

        await usersController.loadUsers();

        expect(usersController.users, testUsers);
        expect(usersController.isLoading, isFalse);
        expect(usersController.errorMessage, isEmpty);
        verify(
          () => mockGetUsers(name: null, email: null, status: null, role: null),
        ).called(1);
      });

      test('deve carregar usuários com filtros aplicados', () async {
        when(
          () => mockGetUsers(
            name: 'Test Name',
            email: 'test@email.com',
            status: UserStatus.ativo,
            role: UserRole.admin,
          ),
        ).thenAnswer((_) async => [testUsers[1]]);

        usersController.setNameFilter('Test Name');
        usersController.setEmailFilter('test@email.com');
        usersController.setStatusFilter(UserStatus.ativo);
        usersController.setRoleFilter(UserRole.admin);

        await usersController.loadUsers();

        expect(usersController.users, [testUsers[1]]);
        verify(
          () => mockGetUsers(
            name: 'Test Name',
            email: 'test@email.com',
            status: UserStatus.ativo,
            role: UserRole.admin,
          ),
        ).called(1);
      });

      test('deve lidar com erro ao carregar usuários', () async {
        when(
          () => mockGetUsers(
            name: any(named: 'name'),
            email: any(named: 'email'),
            status: any(named: 'status'),
            role: any(named: 'role'),
          ),
        ).thenThrow(Exception('Erro de rede'));

        await usersController.loadUsers();

        expect(usersController.users, isEmpty);
        expect(usersController.isLoading, isFalse);
        expect(usersController.errorMessage, contains('Erro de rede'));
      });

      test('deve definir loading como true durante carregamento', () async {
        bool loadingDuringCall = false;
        when(
          () => mockGetUsers(
            name: any(named: 'name'),
            email: any(named: 'email'),
            status: any(named: 'status'),
            role: any(named: 'role'),
          ),
        ).thenAnswer((_) async {
          loadingDuringCall = usersController.isLoading;
          return testUsers;
        });

        await usersController.loadUsers();

        expect(loadingDuringCall, isTrue);
        expect(usersController.isLoading, isFalse);
      });
    });

    group('createUser', () {
      test('deve criar usuário com sucesso', () async {
        final newUser = testUsers[0];
        when(() => mockCreateUser(any())).thenAnswer((_) async => newUser);
        when(
          () => mockGetUsers(
            name: any(named: 'name'),
            email: any(named: 'email'),
            status: any(named: 'status'),
            role: any(named: 'role'),
          ),
        ).thenAnswer((_) async => testUsers);

        await usersController.createUser(newUser);

        expect(usersController.isLoading, isFalse);
        verify(() => mockCreateUser(newUser)).called(1);
        verify(
          () => mockGetUsers(
            name: any(named: 'name'),
            email: any(named: 'email'),
            status: any(named: 'status'),
            role: any(named: 'role'),
          ),
        ).called(1);
      });

      test('deve lidar com erro ao criar usuário', () async {
        final newUser = testUsers[0];
        when(
          () => mockCreateUser(any()),
        ).thenThrow(Exception('Email já existe'));

        await usersController.createUser(newUser);

        expect(usersController.isLoading, isFalse);
        verify(() => mockCreateUser(newUser)).called(1);
        verifyNever(
          () => mockGetUsers(
            name: any(named: 'name'),
            email: any(named: 'email'),
            status: any(named: 'status'),
            role: any(named: 'role'),
          ),
        );
      });
    });

    group('updateUser', () {
      test('deve atualizar usuário com sucesso', () async {
        final updatedUser = testUsers[0].copyWith(name: 'Updated Name');
        when(() => mockUpdateUser(any())).thenAnswer((_) async => updatedUser);
        when(
          () => mockGetUsers(
            name: any(named: 'name'),
            email: any(named: 'email'),
            status: any(named: 'status'),
            role: any(named: 'role'),
          ),
        ).thenAnswer((_) async => testUsers);

        await usersController.updateUser(updatedUser);

        expect(usersController.isLoading, isFalse);
        verify(() => mockUpdateUser(updatedUser)).called(1);
        verify(
          () => mockGetUsers(
            name: any(named: 'name'),
            email: any(named: 'email'),
            status: any(named: 'status'),
            role: any(named: 'role'),
          ),
        ).called(1);
      });

      test('deve lidar com erro ao atualizar usuário', () async {
        final updatedUser = testUsers[0];
        when(
          () => mockUpdateUser(any()),
        ).thenThrow(Exception('Usuário não encontrado'));

        await usersController.updateUser(updatedUser);

        expect(usersController.isLoading, isFalse);
        verify(() => mockUpdateUser(updatedUser)).called(1);
        verifyNever(
          () => mockGetUsers(
            name: any(named: 'name'),
            email: any(named: 'email'),
            status: any(named: 'status'),
            role: any(named: 'role'),
          ),
        );
      });
    });

    group('deleteUser', () {
      test('deve deletar usuário com sucesso', () async {
        when(() => mockDeleteUser(1)).thenAnswer((_) async {});
        when(
          () => mockGetUsers(
            name: any(named: 'name'),
            email: any(named: 'email'),
            status: any(named: 'status'),
            role: any(named: 'role'),
          ),
        ).thenAnswer((_) async => [testUsers[1]]);

        await usersController.deleteUser(1);

        expect(usersController.isLoading, isFalse);
        verify(() => mockDeleteUser(1)).called(1);
        verify(
          () => mockGetUsers(
            name: any(named: 'name'),
            email: any(named: 'email'),
            status: any(named: 'status'),
            role: any(named: 'role'),
          ),
        ).called(1);
      });

      test('deve lidar com erro ao deletar usuário', () async {
        when(
          () => mockDeleteUser(1),
        ).thenThrow(Exception('Usuário não pode ser deletado'));

        await usersController.deleteUser(1);

        expect(usersController.isLoading, isFalse);
        verify(() => mockDeleteUser(1)).called(1);
        verifyNever(
          () => mockGetUsers(
            name: any(named: 'name'),
            email: any(named: 'email'),
            status: any(named: 'status'),
            role: any(named: 'role'),
          ),
        );
      });
    });

    group('Filters', () {
      test('deve atualizar filtro de nome', () {
        usersController.setNameFilter('Test Name');
        expect(usersController.nameFilter, 'Test Name');
      });

      test('deve atualizar filtro de email', () {
        usersController.setEmailFilter('test@email.com');
        expect(usersController.emailFilter, 'test@email.com');
      });

      test('deve atualizar filtro de status', () {
        usersController.setStatusFilter(UserStatus.inativo);
        expect(usersController.statusFilter, UserStatus.inativo);
      });

      test('deve atualizar filtro de role', () {
        usersController.setRoleFilter(UserRole.admin);
        expect(usersController.roleFilter, UserRole.admin);
      });

      test('deve limpar filtros', () async {
        when(
          () => mockGetUsers(
            name: any(named: 'name'),
            email: any(named: 'email'),
            status: any(named: 'status'),
            role: any(named: 'role'),
          ),
        ).thenAnswer((_) async => testUsers);

        usersController.setNameFilter('Test');
        usersController.setEmailFilter('test@email.com');
        usersController.setStatusFilter(UserStatus.ativo);
        usersController.setRoleFilter(UserRole.admin);

        usersController.clearFilters();

        expect(usersController.nameFilter, isEmpty);
        expect(usersController.emailFilter, isEmpty);
        expect(usersController.statusFilter, isNull);
        expect(usersController.roleFilter, isNull);
      });
    });

    group('Search and Refresh', () {
      test('deve aplicar filtros e recarregar', () async {
        when(
          () => mockGetUsers(
            name: any(named: 'name'),
            email: any(named: 'email'),
            status: any(named: 'status'),
            role: any(named: 'role'),
          ),
        ).thenAnswer((_) async => testUsers);

        usersController.applyFilters();

        verify(
          () => mockGetUsers(
            name: any(named: 'name'),
            email: any(named: 'email'),
            status: any(named: 'status'),
            role: any(named: 'role'),
          ),
        ).called(1);
      });

      test('deve recarregar usuários', () async {
        when(
          () => mockGetUsers(
            name: any(named: 'name'),
            email: any(named: 'email'),
            status: any(named: 'status'),
            role: any(named: 'role'),
          ),
        ).thenAnswer((_) async => testUsers);

        await usersController.loadUsers();

        verify(
          () => mockGetUsers(
            name: any(named: 'name'),
            email: any(named: 'email'),
            status: any(named: 'status'),
            role: any(named: 'role'),
          ),
        ).called(1);
      });
    });
  });
}
