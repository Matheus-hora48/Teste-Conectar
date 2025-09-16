import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frontend/features/auth/domain/models/user.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late GetCurrentUserUseCase getCurrentUserUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    getCurrentUserUseCase = GetCurrentUserUseCase(mockAuthRepository);
  });

  group('GetCurrentUserUseCase Tests', () {
    final testUser = User(
      id: 1,
      name: 'Test User',
      email: 'test@example.com',
      role: UserRole.user,
    );

    group('execute', () {
      test('deve retornar usuário atual com sucesso', () async {
        // Arrange
        when(
          () => mockAuthRepository.getCurrentUser(),
        ).thenAnswer((_) async => testUser);

        // Act
        final result = await getCurrentUserUseCase.execute();

        // Assert
        expect(result, equals(testUser));
        expect(result?.id, equals(1));
        expect(result?.name, equals('Test User'));
        expect(result?.email, equals('test@example.com'));
        expect(result?.role, equals(UserRole.user));
        verify(() => mockAuthRepository.getCurrentUser()).called(1);
      });

      test('deve retornar null quando não há usuário logado', () async {
        // Arrange
        when(
          () => mockAuthRepository.getCurrentUser(),
        ).thenAnswer((_) async => null);

        // Act
        final result = await getCurrentUserUseCase.execute();

        // Assert
        expect(result, isNull);
        verify(() => mockAuthRepository.getCurrentUser()).called(1);
      });

      test('deve propagar erro do repository', () async {
        // Arrange
        when(
          () => mockAuthRepository.getCurrentUser(),
        ).thenThrow(Exception('Erro ao buscar usuário'));

        // Act & Assert
        expect(
          () => getCurrentUserUseCase.execute(),
          throwsA(isA<Exception>()),
        );
        verify(() => mockAuthRepository.getCurrentUser()).called(1);
      });
    });
  });
}
