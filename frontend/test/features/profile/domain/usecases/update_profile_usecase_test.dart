import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:frontend/features/profile/domain/repositories/profile_repository.dart';
import 'package:frontend/features/profile/domain/entities/profile_user.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

class FakeUpdateProfileRequest extends Fake implements UpdateProfileRequest {}

void main() {
  late UpdateUserProfileUseCase updateUserProfileUseCase;
  late MockProfileRepository mockProfileRepository;

  setUpAll(() {
    registerFallbackValue(FakeUpdateProfileRequest());
  });

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    updateUserProfileUseCase = UpdateUserProfileUseCase(mockProfileRepository);
  });

  group('UpdateUserProfileUseCase Tests', () {
    final testProfileUser = ProfileUser(
      id: 1,
      name: 'Updated User',
      email: 'updated@example.com',
      role: 'admin',
      createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      updatedAt: DateTime.parse('2024-01-16T10:00:00.000Z'),
    );

    final updateRequest = UpdateProfileRequest(
      name: 'Updated User',
      email: 'updated@example.com',
    );

    group('call', () {
      test('deve atualizar perfil do usuário com sucesso', () async {
        // Arrange
        when(
          () => mockProfileRepository.updateProfile(any()),
        ).thenAnswer((_) async => testProfileUser);

        // Act
        final result = await updateUserProfileUseCase.call(updateRequest);

        // Assert
        expect(result, equals(testProfileUser));
        expect(result.id, equals(1));
        expect(result.name, equals('Updated User'));
        expect(result.email, equals('updated@example.com'));
        expect(result.role, equals('admin'));
        verify(
          () => mockProfileRepository.updateProfile(updateRequest),
        ).called(1);
      });

      test('deve atualizar apenas o nome do usuário', () async {
        // Arrange
        final nameOnlyRequest = UpdateProfileRequest(
          name: 'New Name Only',
          email: 'test@example.com', // email permanece o mesmo
        );

        final updatedUser = testProfileUser.copyWith(
          name: 'New Name Only',
          email: 'test@example.com',
        );

        when(
          () => mockProfileRepository.updateProfile(any()),
        ).thenAnswer((_) async => updatedUser);

        // Act
        final result = await updateUserProfileUseCase.call(nameOnlyRequest);

        // Assert
        expect(result.name, equals('New Name Only'));
        expect(result.email, equals('test@example.com'));
        verify(
          () => mockProfileRepository.updateProfile(nameOnlyRequest),
        ).called(1);
      });

      test('deve atualizar apenas o email do usuário', () async {
        // Arrange
        final emailOnlyRequest = UpdateProfileRequest(
          name: 'Test User', // nome permanece o mesmo
          email: 'newemail@example.com',
        );

        final updatedUser = testProfileUser.copyWith(
          name: 'Test User',
          email: 'newemail@example.com',
        );

        when(
          () => mockProfileRepository.updateProfile(any()),
        ).thenAnswer((_) async => updatedUser);

        // Act
        final result = await updateUserProfileUseCase.call(emailOnlyRequest);

        // Assert
        expect(result.name, equals('Test User'));
        expect(result.email, equals('newemail@example.com'));
        verify(
          () => mockProfileRepository.updateProfile(emailOnlyRequest),
        ).called(1);
      });

      test('deve propagar erro do repository para dados inválidos', () async {
        // Arrange
        when(
          () => mockProfileRepository.updateProfile(any()),
        ).thenThrow(Exception('Dados de perfil inválidos'));

        // Act & Assert
        expect(
          () => updateUserProfileUseCase.call(updateRequest),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Dados de perfil inválidos'),
            ),
          ),
        );
        verify(
          () => mockProfileRepository.updateProfile(updateRequest),
        ).called(1);
      });

      test('deve propagar erro do repository para email já em uso', () async {
        // Arrange
        when(
          () => mockProfileRepository.updateProfile(any()),
        ).thenThrow(Exception('Email já está em uso por outro usuário'));

        // Act & Assert
        expect(
          () => updateUserProfileUseCase.call(updateRequest),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Email já está em uso'),
            ),
          ),
        );
        verify(
          () => mockProfileRepository.updateProfile(updateRequest),
        ).called(1);
      });

      test(
        'deve propagar erro do repository para usuário não autenticado',
        () async {
          // Arrange
          when(
            () => mockProfileRepository.updateProfile(any()),
          ).thenThrow(Exception('Usuário não autenticado'));

          // Act & Assert
          expect(
            () => updateUserProfileUseCase.call(updateRequest),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Usuário não autenticado'),
              ),
            ),
          );
          verify(
            () => mockProfileRepository.updateProfile(updateRequest),
          ).called(1);
        },
      );

      test('deve propagar erro do repository para permissão negada', () async {
        // Arrange
        when(() => mockProfileRepository.updateProfile(any())).thenThrow(
          Exception('Você não tem permissão para atualizar este perfil'),
        );

        // Act & Assert
        expect(
          () => updateUserProfileUseCase.call(updateRequest),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('não tem permissão'),
            ),
          ),
        );
        verify(
          () => mockProfileRepository.updateProfile(updateRequest),
        ).called(1);
      });

      test('deve propagar erro de conectividade', () async {
        // Arrange
        when(
          () => mockProfileRepository.updateProfile(any()),
        ).thenThrow(Exception('Falha na conexão com o servidor'));

        // Act & Assert
        expect(
          () => updateUserProfileUseCase.call(updateRequest),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Falha na conexão'),
            ),
          ),
        );
        verify(
          () => mockProfileRepository.updateProfile(updateRequest),
        ).called(1);
      });

      test('deve propagar erro genérico do repository', () async {
        // Arrange
        when(
          () => mockProfileRepository.updateProfile(any()),
        ).thenThrow(Exception('Erro interno do servidor'));

        // Act & Assert
        expect(
          () => updateUserProfileUseCase.call(updateRequest),
          throwsA(isA<Exception>()),
        );
        verify(
          () => mockProfileRepository.updateProfile(updateRequest),
        ).called(1);
      });

      test('deve atualizar perfil com diferentes requests', () async {
        // Arrange
        final requests = [
          UpdateProfileRequest(name: 'User 1', email: 'user1@example.com'),
          UpdateProfileRequest(name: 'User 2', email: 'user2@example.com'),
          UpdateProfileRequest(name: 'User 3', email: 'user3@example.com'),
        ];

        for (int i = 0; i < requests.length; i++) {
          final expectedUser = testProfileUser.copyWith(
            name: requests[i].name,
            email: requests[i].email,
          );
          when(
            () => mockProfileRepository.updateProfile(requests[i]),
          ).thenAnswer((_) async => expectedUser);
        }

        // Act & Assert
        for (int i = 0; i < requests.length; i++) {
          final result = await updateUserProfileUseCase.call(requests[i]);
          expect(result.name, equals(requests[i].name));
          expect(result.email, equals(requests[i].email));
        }

        // Verify all calls were made
        for (final request in requests) {
          verify(() => mockProfileRepository.updateProfile(request)).called(1);
        }
      });
    });
  });
}
