import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:frontend/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late CheckAuthStatusUseCase checkAuthStatusUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    checkAuthStatusUseCase = CheckAuthStatusUseCase(mockAuthRepository);
  });

  group('CheckAuthStatusUseCase Tests', () {
    group('execute', () {
      test('deve retornar true quando usuário está logado', () async {
        // Arrange
        when(
          () => mockAuthRepository.isLoggedIn(),
        ).thenAnswer((_) async => true);

        // Act
        final result = await checkAuthStatusUseCase.execute();

        // Assert
        expect(result, isTrue);
        verify(() => mockAuthRepository.isLoggedIn()).called(1);
      });

      test('deve retornar false quando usuário não está logado', () async {
        // Arrange
        when(
          () => mockAuthRepository.isLoggedIn(),
        ).thenAnswer((_) async => false);

        // Act
        final result = await checkAuthStatusUseCase.execute();

        // Assert
        expect(result, isFalse);
        verify(() => mockAuthRepository.isLoggedIn()).called(1);
      });

      test('deve propagar erro do repository', () async {
        // Arrange
        when(
          () => mockAuthRepository.isLoggedIn(),
        ).thenThrow(Exception('Erro ao verificar status de autenticação'));

        // Act & Assert
        expect(
          () => checkAuthStatusUseCase.execute(),
          throwsA(isA<Exception>()),
        );
        verify(() => mockAuthRepository.isLoggedIn()).called(1);
      });
    });
  });
}
