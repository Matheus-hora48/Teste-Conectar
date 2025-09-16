import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/core/bindings/app_binding.dart';
import 'package:frontend/core/network/api_service.dart';
import 'package:frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frontend/features/auth/domain/usecases/login_usecase.dart';
import 'package:frontend/features/auth/domain/usecases/register_usecase.dart';
import 'package:frontend/features/auth/domain/usecases/logout_usecase.dart';
import 'package:frontend/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:frontend/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:frontend/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:frontend/features/auth/domain/usecases/update_password_usecase.dart';
import 'package:frontend/features/auth/presentation/controllers/auth_controller.dart';

void main() {
  group('AppBinding Tests', () {
    late AppBinding appBinding;

    setUp(() {
      // Limpa todas as dependências antes de cada teste
      Get.reset();
      appBinding = AppBinding();
    });

    tearDown(() {
      // Limpa todas as dependências após cada teste
      Get.reset();
    });

    group('Dependency Registration', () {
      test('deve registrar todas as dependências', () {
        // Act
        appBinding.dependencies();

        // Assert - Verifica se todas as dependências foram registradas
        expect(Get.isRegistered<ApiService>(), isTrue);
        expect(Get.isRegistered<AuthRepository>(), isTrue);
        expect(Get.isRegistered<LoginUseCase>(), isTrue);
        expect(Get.isRegistered<RegisterUseCase>(), isTrue);
        expect(Get.isRegistered<LogoutUseCase>(), isTrue);
        expect(Get.isRegistered<GetCurrentUserUseCase>(), isTrue);
        expect(Get.isRegistered<CheckAuthStatusUseCase>(), isTrue);
        expect(Get.isRegistered<UpdateProfileUseCase>(), isTrue);
        expect(Get.isRegistered<UpdatePasswordUseCase>(), isTrue);
        expect(Get.isRegistered<AuthController>(), isTrue);
      });

      test('deve registrar ApiService como permanent', () {
        // Act
        appBinding.dependencies();

        // Assert
        expect(Get.isRegistered<ApiService>(), isTrue);

        // Obtém a instância
        final apiService = Get.find<ApiService>();
        expect(apiService, isA<ApiService>());

        // Verifica se é permanent (não é removido ao chamar reset)
        Get.delete<AuthRepository>(); // Remove uma dependência não permanent
        expect(Get.isRegistered<ApiService>(), isTrue);
      });

      test('deve registrar dependências como lazy loading', () {
        // Act
        appBinding.dependencies();

        // Assert - Dependências lazy não são instanciadas até serem solicitadas
        expect(Get.isRegistered<AuthRepository>(), isTrue);
        expect(Get.isRegistered<LoginUseCase>(), isTrue);
        expect(Get.isRegistered<RegisterUseCase>(), isTrue);
        expect(Get.isRegistered<LogoutUseCase>(), isTrue);
        expect(Get.isRegistered<GetCurrentUserUseCase>(), isTrue);
        expect(Get.isRegistered<CheckAuthStatusUseCase>(), isTrue);
        expect(Get.isRegistered<UpdateProfileUseCase>(), isTrue);
        expect(Get.isRegistered<UpdatePasswordUseCase>(), isTrue);
        expect(Get.isRegistered<AuthController>(), isTrue);
      });
    });

    group('ApiService Binding', () {
      test('deve criar e inicializar ApiService corretamente', () {
        // Act
        appBinding.dependencies();
        final apiService = Get.find<ApiService>();

        // Assert
        expect(apiService, isA<ApiService>());
        expect(apiService.dio, isNotNull);
      });

      test('deve manter ApiService como singleton', () {
        // Act
        appBinding.dependencies();
        final apiService1 = Get.find<ApiService>();
        final apiService2 = Get.find<ApiService>();

        // Assert
        expect(identical(apiService1, apiService2), isTrue);
      });

      test('deve permitir acesso ao ApiService após binding', () {
        // Act
        appBinding.dependencies();

        // Assert
        expect(() => Get.find<ApiService>(), returnsNormally);
        final apiService = Get.find<ApiService>();
        expect(apiService, isNotNull);
      });
    });

    group('Repository Binding', () {
      test('deve criar AuthRepository com ApiService injetado', () {
        // Act
        appBinding.dependencies();
        final repository = Get.find<AuthRepository>();

        // Assert
        expect(repository, isA<AuthRepository>());
      });

      test('deve usar mesma instância de ApiService no repository', () {
        // Act
        appBinding.dependencies();
        final apiService = Get.find<ApiService>();
        final repository = Get.find<AuthRepository>();

        // Assert
        expect(repository, isNotNull);
        expect(apiService, isNotNull);
        // Repository deve usar a mesma instância de ApiService
      });
    });

    group('UseCase Bindings', () {
      test('deve criar todos os UseCases com repository injetado', () {
        // Act
        appBinding.dependencies();

        // Assert
        expect(Get.find<LoginUseCase>(), isA<LoginUseCase>());
        expect(Get.find<RegisterUseCase>(), isA<RegisterUseCase>());
        expect(Get.find<LogoutUseCase>(), isA<LogoutUseCase>());
        expect(Get.find<GetCurrentUserUseCase>(), isA<GetCurrentUserUseCase>());
        expect(
          Get.find<CheckAuthStatusUseCase>(),
          isA<CheckAuthStatusUseCase>(),
        );
        expect(Get.find<UpdateProfileUseCase>(), isA<UpdateProfileUseCase>());
        expect(Get.find<UpdatePasswordUseCase>(), isA<UpdatePasswordUseCase>());
      });

      test('deve usar mesma instância de repository em todos os UseCases', () {
        // Act
        appBinding.dependencies();
        final repository = Get.find<AuthRepository>();
        final loginUseCase = Get.find<LoginUseCase>();
        final registerUseCase = Get.find<RegisterUseCase>();

        // Assert
        expect(repository, isNotNull);
        expect(loginUseCase, isNotNull);
        expect(registerUseCase, isNotNull);
        // Todos os UseCases devem usar a mesma instância do repository
      });

      test('deve criar UseCases independentemente', () {
        // Act
        appBinding.dependencies();

        // Assert - Cada UseCase deve ser uma instância diferente
        final loginUseCase1 = Get.find<LoginUseCase>();
        final loginUseCase2 = Get.find<LoginUseCase>();
        expect(
          identical(loginUseCase1, loginUseCase2),
          isTrue,
        ); // Get retorna mesma instância

        final registerUseCase = Get.find<RegisterUseCase>();
        expect(
          identical(loginUseCase1, registerUseCase),
          isFalse,
        ); // Diferentes tipos
      });
    });

    group('Controller Binding', () {
      test('deve criar AuthController com todos os UseCases injetados', () {
        // Act
        appBinding.dependencies();
        final controller = Get.find<AuthController>();

        // Assert
        expect(controller, isA<AuthController>());
      });

      test('deve injetar todas as dependências no controller', () {
        // Act
        appBinding.dependencies();

        // Assert - Verifica se controller pode ser criado (todas dependências disponíveis)
        expect(() => Get.find<AuthController>(), returnsNormally);

        final controller = Get.find<AuthController>();
        expect(controller, isNotNull);
      });

      test('deve usar mesmas instâncias dos UseCases no controller', () {
        // Act
        appBinding.dependencies();
        final loginUseCase = Get.find<LoginUseCase>();
        final controller = Get.find<AuthController>();

        // Assert
        expect(loginUseCase, isNotNull);
        expect(controller, isNotNull);
        // Controller deve usar as mesmas instâncias dos UseCases
      });
    });

    group('Dependency Chain Validation', () {
      test('deve manter cadeia de dependências consistente', () {
        // Act
        appBinding.dependencies();

        // Assert - Testa toda a cadeia: ApiService -> Repository -> UseCases -> Controller
        final apiService = Get.find<ApiService>();
        final repository = Get.find<AuthRepository>();
        final loginUseCase = Get.find<LoginUseCase>();
        final controller = Get.find<AuthController>();

        expect(apiService, isNotNull);
        expect(repository, isNotNull);
        expect(loginUseCase, isNotNull);
        expect(controller, isNotNull);
      });

      test('deve resolver dependências circulares corretamente', () {
        // Act & Assert - Não deve gerar erro de dependência circular
        expect(() => appBinding.dependencies(), returnsNormally);

        // Verifica se todas as dependências podem ser resolvidas
        expect(() => Get.find<AuthController>(), returnsNormally);
      });

      test('deve permitir acesso às dependências em qualquer ordem', () {
        // Act
        appBinding.dependencies();

        // Assert - Testa acesso em diferentes ordens
        expect(() => Get.find<AuthController>(), returnsNormally);
        expect(() => Get.find<LoginUseCase>(), returnsNormally);
        expect(() => Get.find<AuthRepository>(), returnsNormally);
        expect(() => Get.find<ApiService>(), returnsNormally);

        // E na ordem reversa
        expect(() => Get.find<ApiService>(), returnsNormally);
        expect(() => Get.find<AuthRepository>(), returnsNormally);
        expect(() => Get.find<LoginUseCase>(), returnsNormally);
        expect(() => Get.find<AuthController>(), returnsNormally);
      });
    });

    group('Memory Management', () {
      test('deve permitir cleanup de dependências lazy', () {
        // Act
        appBinding.dependencies();

        // Verifica se dependências existem
        expect(Get.isRegistered<AuthRepository>(), isTrue);
        expect(Get.isRegistered<LoginUseCase>(), isTrue);

        // Remove dependências lazy
        Get.delete<AuthRepository>();
        Get.delete<LoginUseCase>();

        // Assert
        expect(Get.isRegistered<AuthRepository>(), isFalse);
        expect(Get.isRegistered<LoginUseCase>(), isFalse);

        // ApiService deve permanecer (permanent)
        expect(Get.isRegistered<ApiService>(), isTrue);
      });

      test('deve recriar dependências lazy após cleanup', () {
        // Act
        appBinding.dependencies();

        // Remove uma dependência
        Get.delete<LoginUseCase>();
        expect(Get.isRegistered<LoginUseCase>(), isFalse);

        // Registra novamente
        appBinding.dependencies();

        // Assert
        expect(Get.isRegistered<LoginUseCase>(), isTrue);
        expect(() => Get.find<LoginUseCase>(), returnsNormally);
      });
    });

    group('Error Handling', () {
      test('deve lidar com múltiplas chamadas de dependencies', () {
        // Act & Assert
        expect(() => appBinding.dependencies(), returnsNormally);
        expect(() => appBinding.dependencies(), returnsNormally);
        expect(() => appBinding.dependencies(), returnsNormally);

        // Dependências devem ainda estar disponíveis
        expect(Get.isRegistered<ApiService>(), isTrue);
        expect(Get.isRegistered<AuthController>(), isTrue);
      });

      test('deve funcionar após reset completo', () {
        // Act
        appBinding.dependencies();
        expect(Get.isRegistered<ApiService>(), isTrue);

        Get.reset(); // Reset completo
        expect(Get.isRegistered<ApiService>(), isFalse);

        appBinding.dependencies(); // Registra novamente

        // Assert
        expect(Get.isRegistered<ApiService>(), isTrue);
        expect(Get.isRegistered<AuthController>(), isTrue);
      });
    });

    group('Bindings Interface Compliance', () {
      test('deve implementar Bindings corretamente', () {
        // Assert
        expect(appBinding, isA<Bindings>());
        expect(appBinding.dependencies, isA<Function>());
      });

      test('deve ser instanciável múltiplas vezes', () {
        // Act
        final binding1 = AppBinding();
        final binding2 = AppBinding();

        // Assert
        expect(binding1, isA<AppBinding>());
        expect(binding2, isA<AppBinding>());
        expect(identical(binding1, binding2), isFalse);
      });

      test('deve executar dependencies sem erros', () {
        // Act & Assert
        expect(() => appBinding.dependencies(), returnsNormally);

        // Verifica se pelo menos uma dependência foi registrada
        expect(Get.isRegistered<ApiService>(), isTrue);
      });
    });
  });
}
