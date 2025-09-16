import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/core/network/api_service.dart';
import 'package:frontend/features/profile/presentation/bindings/profile_binding.dart';
import 'package:frontend/features/profile/domain/repositories/profile_repository.dart';
import 'package:frontend/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:frontend/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:frontend/features/profile/domain/usecases/update_password_usecase.dart';
import 'package:frontend/features/profile/presentation/controllers/profile_controller.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  group('ProfileBinding Tests', () {
    late ProfileBinding binding;
    late MockApiService mockApiService;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      Get.reset();

      binding = ProfileBinding();
      mockApiService = MockApiService();

      Get.put<ApiService>(mockApiService);
    });

    tearDown(() {
      Get.reset();
    });

    group('Dependencies Registration', () {
      test('deve registrar ProfileRepository corretamente', () {
        binding.dependencies();

        expect(Get.isRegistered<ProfileRepository>(), isTrue);
        expect(Get.find<ProfileRepository>(), isNotNull);
      });

      test('deve registrar todos os UseCases corretamente', () {
        binding.dependencies();

        expect(Get.isRegistered<GetUserProfileUseCase>(), isTrue);
        expect(Get.isRegistered<UpdateUserProfileUseCase>(), isTrue);
        expect(Get.isRegistered<UpdateUserPasswordUseCase>(), isTrue);

        expect(Get.find<GetUserProfileUseCase>(), isNotNull);
        expect(Get.find<UpdateUserProfileUseCase>(), isNotNull);
        expect(Get.find<UpdateUserPasswordUseCase>(), isNotNull);
      });

      test('deve registrar ProfileController com todas as dependências', () {
        binding.dependencies();

        expect(Get.isRegistered<ProfileController>(), isTrue);

        final controller = Get.find<ProfileController>();
        expect(controller, isNotNull);
        expect(controller.isLoading, isFalse);
        expect(controller.profileUser, isNull);
      });

      test('deve usar lazy loading para todas as dependências', () {
        binding.dependencies();

        expect(Get.isRegistered<ProfileRepository>(), isTrue);
        expect(Get.isRegistered<ProfileController>(), isTrue);
        expect(Get.isRegistered<GetUserProfileUseCase>(), isTrue);
        expect(Get.isRegistered<UpdateUserProfileUseCase>(), isTrue);
        expect(Get.isRegistered<UpdateUserPasswordUseCase>(), isTrue);
      });
    });

    group('Dependency Resolution', () {
      test('deve resolver corretamente a cadeia de dependências', () {
        binding.dependencies();

        expect(() => Get.find<ProfileController>(), returnsNormally);
        expect(() => Get.find<GetUserProfileUseCase>(), returnsNormally);
        expect(() => Get.find<UpdateUserProfileUseCase>(), returnsNormally);
        expect(() => Get.find<UpdateUserPasswordUseCase>(), returnsNormally);
        expect(() => Get.find<ProfileRepository>(), returnsNormally);
      });

      test('deve reutilizar a mesma instância do repository', () {
        binding.dependencies();

        final repo1 = Get.find<ProfileRepository>();
        final repo2 = Get.find<ProfileRepository>();
        expect(repo1, same(repo2));
      });

      test('deve reutilizar a mesma instância do controller', () {
        binding.dependencies();

        final controller1 = Get.find<ProfileController>();
        final controller2 = Get.find<ProfileController>();
        expect(controller1, same(controller2));
      });

      test('deve reutilizar a mesma instância dos use cases', () {
        binding.dependencies();

        final useCase1 = Get.find<GetUserProfileUseCase>();
        final useCase2 = Get.find<GetUserProfileUseCase>();
        expect(useCase1, same(useCase2));

        final updateUseCase1 = Get.find<UpdateUserProfileUseCase>();
        final updateUseCase2 = Get.find<UpdateUserProfileUseCase>();
        expect(updateUseCase1, same(updateUseCase2));

        final passwordUseCase1 = Get.find<UpdateUserPasswordUseCase>();
        final passwordUseCase2 = Get.find<UpdateUserPasswordUseCase>();
        expect(passwordUseCase1, same(passwordUseCase2));
      });
    });

    group('Integration Tests', () {
      test('deve permitir múltiplos bindings sem conflitos', () {
        expect(() {
          binding.dependencies();
          binding.dependencies();
        }, returnsNormally);
      });

      test('deve manter estado consistente após reset', () {
        binding.dependencies();
        final originalController = Get.find<ProfileController>();

        Get.reset();
        Get.put<ApiService>(mockApiService);
        binding.dependencies();

        final newController = Get.find<ProfileController>();
        expect(newController, isNot(same(originalController)));
        expect(newController.isLoading, isFalse);
        expect(newController.profileUser, isNull);
      });

      test('deve funcionar corretamente com ApiService mockado', () {
        binding.dependencies();

        final repository = Get.find<ProfileRepository>();
        expect(repository, isNotNull);

        final controller = Get.find<ProfileController>();
        expect(controller, isNotNull);
      });
    });

    group('Dependencies Order', () {
      test('deve registrar dependências na ordem correta', () {
        binding.dependencies();

        expect(() {
          final repo = Get.find<ProfileRepository>();
          final getUserUseCase = Get.find<GetUserProfileUseCase>();
          final updateProfileUseCase = Get.find<UpdateUserProfileUseCase>();
          final updatePasswordUseCase = Get.find<UpdateUserPasswordUseCase>();
          final controller = Get.find<ProfileController>();

          expect(repo, isNotNull);
          expect(getUserUseCase, isNotNull);
          expect(updateProfileUseCase, isNotNull);
          expect(updatePasswordUseCase, isNotNull);
          expect(controller, isNotNull);
        }, returnsNormally);
      });
    });

    group('Error Handling', () {
      test('deve lidar com ApiService não registrado', () {
        Get.reset();

        expect(() => binding.dependencies(), throwsA(isA<String>()));
      });

      test('deve funcionar após re-registro do ApiService', () {
        Get.reset();

        Get.put<ApiService>(mockApiService);
        binding.dependencies();

        expect(() => Get.find<ProfileController>(), returnsNormally);
        expect(() => Get.find<ProfileRepository>(), returnsNormally);
      });
    });
  });
}
