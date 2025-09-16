import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/core/network/api_service.dart';
import 'package:frontend/features/auth/presentation/bindings/auth_binding.dart';
import 'package:frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frontend/features/auth/domain/usecases/login_usecase.dart';
import 'package:frontend/features/auth/domain/usecases/register_usecase.dart';
import 'package:frontend/features/auth/domain/usecases/logout_usecase.dart';
import 'package:frontend/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:frontend/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:frontend/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:frontend/features/auth/domain/usecases/update_password_usecase.dart';
import 'package:frontend/features/auth/presentation/controllers/auth_controller.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  group('AuthBinding Tests', () {
    late AuthBinding binding;
    late MockApiService mockApiService;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      Get.reset();

      binding = AuthBinding();
      mockApiService = MockApiService();

      // Pre-register ApiService dependency
      Get.put<ApiService>(mockApiService);
    });

    tearDown(() {
      Get.reset();
    });

    group('Dependencies Registration', () {
      test('deve registrar AuthRepository corretamente', () {
        // Act
        binding.dependencies();

        // Assert
        expect(Get.isRegistered<AuthRepository>(), isTrue);
        expect(Get.find<AuthRepository>(), isNotNull);
      });

      test('deve registrar todos os UseCases corretamente', () {
        // Act
        binding.dependencies();

        // Assert
        expect(Get.isRegistered<LoginUseCase>(), isTrue);
        expect(Get.isRegistered<RegisterUseCase>(), isTrue);
        expect(Get.isRegistered<LogoutUseCase>(), isTrue);
        expect(Get.isRegistered<GetCurrentUserUseCase>(), isTrue);
        expect(Get.isRegistered<CheckAuthStatusUseCase>(), isTrue);
        expect(Get.isRegistered<UpdateProfileUseCase>(), isTrue);
        expect(Get.isRegistered<UpdatePasswordUseCase>(), isTrue);
      });

      test('deve registrar AuthController com todas as dependências', () {
        // Act
        binding.dependencies();

        // Assert
        expect(Get.isRegistered<AuthController>(), isTrue);

        final controller = Get.find<AuthController>();
        expect(controller, isNotNull);
        expect(controller.isLoading, isFalse);
        expect(controller.isLoggedIn, isFalse);
        expect(controller.currentUser, isNull);
      });

      test('deve usar lazy loading para todas as dependências', () {
        // Act
        binding.dependencies();

        // Assert - verificar que as dependências não foram instanciadas ainda
        expect(Get.isRegistered<AuthRepository>(), isTrue);
        expect(Get.isRegistered<AuthController>(), isTrue);

        // Quando realmente usar as dependências, elas devem ser criadas
        final controller = Get.find<AuthController>();
        expect(controller, isNotNull);
      });
    });

    group('Dependency Resolution', () {
      test('deve resolver corretamente a cadeia de dependências', () {
        // Act
        binding.dependencies();

        // Assert - testar se consegue instanciar o controller com todas as deps
        expect(() => Get.find<AuthController>(), returnsNormally);
        expect(() => Get.find<LoginUseCase>(), returnsNormally);
        expect(() => Get.find<AuthRepository>(), returnsNormally);
      });

      test('deve reutilizar a mesma instância do repository', () {
        // Act
        binding.dependencies();

        // Assert
        final repo1 = Get.find<AuthRepository>();
        final repo2 = Get.find<AuthRepository>();
        expect(repo1, same(repo2));
      });

      test('deve reutilizar a mesma instância do controller', () {
        // Act
        binding.dependencies();

        // Assert
        final controller1 = Get.find<AuthController>();
        final controller2 = Get.find<AuthController>();
        expect(controller1, same(controller2));
      });
    });

    group('Integration Tests', () {
      test('deve permitir múltiplos bindings sem conflitos', () {
        // Act & Assert
        expect(() {
          binding.dependencies();
          binding.dependencies(); // Segunda chamada
        }, returnsNormally);
      });

      test('deve manter estado consistente após reset', () {
        // Arrange
        binding.dependencies();
        final originalController = Get.find<AuthController>();

        // Act
        Get.reset();
        Get.put<ApiService>(mockApiService);
        binding.dependencies();

        // Assert
        final newController = Get.find<AuthController>();
        expect(newController, isNot(same(originalController)));
        expect(newController.isLoading, isFalse);
      });
    });
  });
}
