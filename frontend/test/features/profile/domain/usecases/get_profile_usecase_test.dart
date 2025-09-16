import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:frontend/features/profile/domain/repositories/profile_repository.dart';
import 'package:frontend/features/profile/domain/entities/profile_user.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late GetUserProfileUseCase getUserProfileUseCase;
  late MockProfileRepository mockProfileRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    getUserProfileUseCase = GetUserProfileUseCase(mockProfileRepository);
  });

  group('GetUserProfileUseCase Tests', () {
    final testProfileUser = ProfileUser(
      id: 1,
      name: 'Test User',
      email: 'test@example.com',
      role: 'admin',
      createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      updatedAt: DateTime.parse('2024-01-15T12:30:00.000Z'),
    );

    group('call', () {
      test('deve retornar perfil do usuário com sucesso', () async {
        // Arrange
        when(
          () => mockProfileRepository.getProfile(),
        ).thenAnswer((_) async => testProfileUser);

        // Act
        final result = await getUserProfileUseCase.call();

        // Assert
        expect(result, equals(testProfileUser));
        expect(result.id, equals(1));
        expect(result.name, equals('Test User'));
        expect(result.email, equals('test@example.com'));
        expect(result.role, equals('admin'));
        expect(
          result.createdAt,
          equals(DateTime.parse('2024-01-01T00:00:00.000Z')),
        );
        expect(
          result.updatedAt,
          equals(DateTime.parse('2024-01-15T12:30:00.000Z')),
        );
        verify(() => mockProfileRepository.getProfile()).called(1);
      });

      test(
        'deve retornar perfil de usuário com campos opcionais nulos',
        () async {
          // Arrange
          final simpleProfileUser = ProfileUser(
            id: 2,
            name: 'Simple User',
            email: 'simple@example.com',
            role: 'user',
          );

          when(
            () => mockProfileRepository.getProfile(),
          ).thenAnswer((_) async => simpleProfileUser);

          // Act
          final result = await getUserProfileUseCase.call();

          // Assert
          expect(result, equals(simpleProfileUser));
          expect(result.id, equals(2));
          expect(result.name, equals('Simple User'));
          expect(result.email, equals('simple@example.com'));
          expect(result.role, equals('user'));
          expect(result.createdAt, isNull);
          expect(result.updatedAt, isNull);
          verify(() => mockProfileRepository.getProfile()).called(1);
        },
      );

      test(
        'deve propagar erro do repository para usuário não autenticado',
        () async {
          // Arrange
          when(
            () => mockProfileRepository.getProfile(),
          ).thenThrow(Exception('Usuário não autenticado'));

          // Act & Assert
          expect(
            () => getUserProfileUseCase.call(),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Usuário não autenticado'),
              ),
            ),
          );
          verify(() => mockProfileRepository.getProfile()).called(1);
        },
      );

      test('deve propagar erro do repository para token expirado', () async {
        // Arrange
        when(
          () => mockProfileRepository.getProfile(),
        ).thenThrow(Exception('Token de acesso expirado'));

        // Act & Assert
        expect(
          () => getUserProfileUseCase.call(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Token de acesso expirado'),
            ),
          ),
        );
        verify(() => mockProfileRepository.getProfile()).called(1);
      });

      test('deve propagar erro de conectividade', () async {
        // Arrange
        when(
          () => mockProfileRepository.getProfile(),
        ).thenThrow(Exception('Falha na conexão com o servidor'));

        // Act & Assert
        expect(
          () => getUserProfileUseCase.call(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Falha na conexão'),
            ),
          ),
        );
        verify(() => mockProfileRepository.getProfile()).called(1);
      });

      test('deve propagar erro genérico do repository', () async {
        // Arrange
        when(
          () => mockProfileRepository.getProfile(),
        ).thenThrow(Exception('Erro interno do servidor'));

        // Act & Assert
        expect(() => getUserProfileUseCase.call(), throwsA(isA<Exception>()));
        verify(() => mockProfileRepository.getProfile()).called(1);
      });

      test(
        'deve chamar repository múltiplas vezes quando necessário',
        () async {
          // Arrange
          when(
            () => mockProfileRepository.getProfile(),
          ).thenAnswer((_) async => testProfileUser);

          // Act
          await getUserProfileUseCase.call();
          await getUserProfileUseCase.call();
          await getUserProfileUseCase.call();

          // Assert
          verify(() => mockProfileRepository.getProfile()).called(3);
        },
      );
    });
  });
}
