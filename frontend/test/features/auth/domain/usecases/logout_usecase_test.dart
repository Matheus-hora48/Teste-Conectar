import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/auth/domain/usecases/logout_usecase.dart';
import 'package:frontend/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LogoutUseCase logoutUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    logoutUseCase = LogoutUseCase(mockAuthRepository);
  });

  group('LogoutUseCase Tests', () {
    group('execute', () {
      test('deve fazer logout com sucesso', () async {
        // Arrange
        when(() => mockAuthRepository.logout()).thenAnswer((_) async => {});

        // Act
        await logoutUseCase.execute();

        // Assert
        verify(() => mockAuthRepository.logout()).called(1);
      });

      test('deve propagar erro do repository', () async {
        // Arrange
        when(
          () => mockAuthRepository.logout(),
        ).thenThrow(Exception('Erro de logout'));

        // Act & Assert
        expect(() => logoutUseCase.execute(), throwsA(isA<Exception>()));
        verify(() => mockAuthRepository.logout()).called(1);
      });
    });
  });
}
