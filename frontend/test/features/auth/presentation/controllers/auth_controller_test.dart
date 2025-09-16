import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get/get.dart';
import 'package:frontend/features/auth/presentation/controllers/auth_controller.dart';
import 'package:frontend/features/auth/domain/usecases/login_usecase.dart';
import 'package:frontend/features/auth/domain/usecases/register_usecase.dart';
import 'package:frontend/features/auth/domain/usecases/logout_usecase.dart';
import 'package:frontend/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:frontend/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:frontend/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:frontend/features/auth/domain/usecases/update_password_usecase.dart';
import 'package:frontend/features/auth/domain/models/auth_response.dart';
import 'package:frontend/features/auth/domain/models/user.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

class MockCheckAuthStatusUseCase extends Mock
    implements CheckAuthStatusUseCase {}

class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}

class MockUpdatePasswordUseCase extends Mock implements UpdatePasswordUseCase {}

class MockGoogleLoginUseCase extends Mock implements GoogleLoginUseCase {}

void main() {
  late AuthController authController;
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockCheckAuthStatusUseCase mockCheckAuthStatusUseCase;
  late MockUpdateProfileUseCase mockUpdateProfileUseCase;
  late MockUpdatePasswordUseCase mockUpdatePasswordUseCase;
  late MockGoogleLoginUseCase mockGoogleLoginUseCase;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockCheckAuthStatusUseCase = MockCheckAuthStatusUseCase();
    mockUpdateProfileUseCase = MockUpdateProfileUseCase();
    mockUpdatePasswordUseCase = MockUpdatePasswordUseCase();
    mockGoogleLoginUseCase = MockGoogleLoginUseCase();

    Get.testMode = true;

    authController = AuthController(
      loginUseCase: mockLoginUseCase,
      registerUseCase: mockRegisterUseCase,
      logoutUseCase: mockLogoutUseCase,
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      checkAuthStatusUseCase: mockCheckAuthStatusUseCase,
      updateProfileUseCase: mockUpdateProfileUseCase,
      updatePasswordUseCase: mockUpdatePasswordUseCase,
      googleLoginUseCase: mockGoogleLoginUseCase,
    );
  });

  tearDown(() {
    Get.reset();
  });

  group('AuthController Tests', () {
    final testUser = User(
      id: 1,
      name: 'Test User',
      email: 'test@example.com',
      role: UserRole.user,
    );

    final testAdminUser = User(
      id: 2,
      name: 'Admin User',
      email: 'admin@example.com',
      role: UserRole.admin,
    );

    final testAuthResponse = AuthResponse(
      accessToken: 'test_token_123',
      user: testUser,
    );

    group('Initial State', () {
      test('deve ter estado inicial correto', () {
        expect(authController.currentUser, isNull);
        expect(authController.isLoading, isFalse);
        expect(authController.isLoggedIn, isFalse);
        expect(authController.obscurePassword, isTrue);
        expect(authController.isAdmin, isFalse);
      });
    });

    group('checkAuthStatus', () {
      test(
        'deve definir estado autenticado quando usuário está logado',
        () async {
          when(
            () => mockCheckAuthStatusUseCase.execute(),
          ).thenAnswer((_) async => true);
          when(
            () => mockGetCurrentUserUseCase.execute(),
          ).thenAnswer((_) async => testUser);

          await authController.checkAuthStatus();

          expect(authController.isLoggedIn, isTrue);
          expect(authController.currentUser, testUser);
          expect(authController.isAdmin, isFalse);
          expect(authController.isLoading, isFalse);
        },
      );

      test('deve definir estado admin quando usuário é admin', () async {
        when(
          () => mockCheckAuthStatusUseCase.execute(),
        ).thenAnswer((_) async => true);
        when(
          () => mockGetCurrentUserUseCase.execute(),
        ).thenAnswer((_) async => testAdminUser);

        await authController.checkAuthStatus();

        expect(authController.isLoggedIn, isTrue);
        expect(authController.currentUser, testAdminUser);
        expect(authController.isAdmin, isTrue);
        expect(authController.isLoading, isFalse);
      });

      test(
        'deve definir estado não autenticado quando usuário não está logado',
        () async {
          when(
            () => mockCheckAuthStatusUseCase.execute(),
          ).thenAnswer((_) async => false);

          await authController.checkAuthStatus();

          expect(authController.isLoggedIn, isFalse);
          expect(authController.currentUser, isNull);
          expect(authController.isAdmin, isFalse);
          expect(authController.isLoading, isFalse);
          verifyNever(() => mockGetCurrentUserUseCase.execute());
        },
      );

      test('deve lidar com erro e definir estado não autenticado', () async {
        when(
          () => mockCheckAuthStatusUseCase.execute(),
        ).thenThrow(Exception('Auth error'));

        await authController.checkAuthStatus();

        expect(authController.isLoggedIn, isFalse);
        expect(authController.currentUser, isNull);
        expect(authController.isAdmin, isFalse);
        expect(authController.isLoading, isFalse);
      });
    });

    group('login', () {
      test('deve fazer login com sucesso', () async {
        when(
          () => mockLoginUseCase.execute('test@example.com', 'password123'),
        ).thenAnswer((_) async => testAuthResponse);

        final result = await authController.login(
          'test@example.com',
          'password123',
        );

        expect(result, isTrue);
        expect(authController.currentUser, testUser);
        expect(authController.isLoggedIn, isTrue);
        expect(authController.isAdmin, isFalse);
        expect(authController.isLoading, isFalse);
        verify(
          () => mockLoginUseCase.execute('test@example.com', 'password123'),
        ).called(1);
      });

      test('deve fazer login de admin com sucesso', () async {
        final adminAuthResponse = AuthResponse(
          accessToken: 'admin_token_123',
          user: testAdminUser,
        );
        when(
          () => mockLoginUseCase.execute('admin@example.com', 'password123'),
        ).thenAnswer((_) async => adminAuthResponse);

        final result = await authController.login(
          'admin@example.com',
          'password123',
        );

        expect(result, isTrue);
        expect(authController.currentUser, testAdminUser);
        expect(authController.isLoggedIn, isTrue);
        expect(authController.isAdmin, isTrue);
        expect(authController.isLoading, isFalse);
      });

      test('deve retornar false quando login falha', () async {
        when(
          () => mockLoginUseCase.execute('test@example.com', 'wrongpassword'),
        ).thenThrow(Exception('Credenciais inválidas'));

        final result = await authController.login(
          'test@example.com',
          'wrongpassword',
        );

        expect(result, isFalse);
        expect(authController.currentUser, isNull);
        expect(authController.isLoggedIn, isFalse);
        expect(authController.isAdmin, isFalse);
        expect(authController.isLoading, isFalse);
        verify(
          () => mockLoginUseCase.execute('test@example.com', 'wrongpassword'),
        ).called(1);
      });
    });

    group('register', () {
      test('deve registrar usuário com sucesso', () async {
        when(
          () => mockRegisterUseCase.execute(
            name: 'Test User',
            email: 'test@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => testAuthResponse);

        final result = await authController.register(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
        );

        expect(result, isTrue);
        expect(authController.currentUser, testUser);
        expect(authController.isLoggedIn, isTrue);
        expect(authController.isAdmin, isFalse);
        expect(authController.isLoading, isFalse);
        verify(
          () => mockRegisterUseCase.execute(
            name: 'Test User',
            email: 'test@example.com',
            password: 'password123',
          ),
        ).called(1);
      });

      test('deve retornar false quando registro falha', () async {
        when(
          () => mockRegisterUseCase.execute(
            name: 'Test User',
            email: 'existing@example.com',
            password: 'password123',
          ),
        ).thenThrow(Exception('Email já está em uso'));

        final result = await authController.register(
          name: 'Test User',
          email: 'existing@example.com',
          password: 'password123',
        );

        expect(result, isFalse);
        expect(authController.currentUser, isNull);
        expect(authController.isLoggedIn, isFalse);
        expect(authController.isAdmin, isFalse);
        expect(authController.isLoading, isFalse);
      });
    });

    group('logout', () {
      test('deve fazer logout com sucesso', () async {
        when(
          () => mockLoginUseCase.execute('test@example.com', 'password123'),
        ).thenAnswer((_) async => testAuthResponse);
        await authController.login('test@example.com', 'password123');

        when(() => mockLogoutUseCase.execute()).thenAnswer((_) async {});

        await authController.logout();

        expect(authController.currentUser, isNull);
        expect(authController.isLoggedIn, isFalse);
        expect(authController.isAdmin, isFalse);
        verify(() => mockLogoutUseCase.execute()).called(1);
      });

      test('deve lidar com erro no logout', () async {
        when(
          () => mockLogoutUseCase.execute(),
        ).thenThrow(Exception('Logout error'));

        await authController.logout();
        verify(() => mockLogoutUseCase.execute()).called(1);
      });
    });

    group('togglePasswordVisibility', () {
      test('deve alternar visibilidade da senha', () {
        expect(authController.obscurePassword, isTrue);

        authController.togglePasswordVisibility();
        expect(authController.obscurePassword, isFalse);

        authController.togglePasswordVisibility();
        expect(authController.obscurePassword, isTrue);
      });
    });

    group('Loading State', () {
      test('deve definir loading como true durante login', () async {
        bool loadingDuringLogin = false;
        when(() => mockLoginUseCase.execute(any(), any())).thenAnswer((
          _,
        ) async {
          loadingDuringLogin = authController.isLoading;
          return testAuthResponse;
        });

        await authController.login('test@example.com', 'password123');

        expect(loadingDuringLogin, isTrue);
        expect(authController.isLoading, isFalse);
      });

      test('deve definir loading como true durante register', () async {
        bool loadingDuringRegister = false;
        when(
          () => mockRegisterUseCase.execute(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {
          loadingDuringRegister = authController.isLoading;
          return testAuthResponse;
        });

        await authController.register(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
        );

        expect(loadingDuringRegister, isTrue);
        expect(authController.isLoading, isFalse);
      });
    });
  });
}
