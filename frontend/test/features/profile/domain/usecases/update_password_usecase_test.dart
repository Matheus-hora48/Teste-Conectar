import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/profile/domain/usecases/update_password_usecase.dart';
import 'package:frontend/features/profile/domain/repositories/profile_repository.dart';
import 'package:frontend/features/profile/domain/entities/profile_user.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

class FakeUpdatePasswordRequest extends Fake implements UpdatePasswordRequest {}

void main() {
  late UpdateUserPasswordUseCase updateUserPasswordUseCase;
  late MockProfileRepository mockProfileRepository;

  setUpAll(() {
    registerFallbackValue(FakeUpdatePasswordRequest());
  });

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    updateUserPasswordUseCase = UpdateUserPasswordUseCase(
      mockProfileRepository,
    );
  });

  group('UpdateUserPasswordUseCase Tests', () {
    final updatePasswordRequest = UpdatePasswordRequest(
      currentPassword: 'currentPass123',
      newPassword: 'newPass456',
    );

    group('call', () {
      test('deve atualizar senha do usuário com sucesso', () async {
        // Arrange
        when(
          () => mockProfileRepository.updatePassword(any()),
        ).thenAnswer((_) async => {});

        // Act
        await updateUserPasswordUseCase.call(updatePasswordRequest);

        // Assert
        verify(
          () => mockProfileRepository.updatePassword(updatePasswordRequest),
        ).called(1);
      });

      test('deve atualizar senha com diferentes senhas', () async {
        // Arrange
        final differentRequest = UpdatePasswordRequest(
          currentPassword: 'oldPassword789',
          newPassword: 'strongNewPassword123',
        );

        when(
          () => mockProfileRepository.updatePassword(any()),
        ).thenAnswer((_) async => {});

        // Act
        await updateUserPasswordUseCase.call(differentRequest);

        // Assert
        verify(
          () => mockProfileRepository.updatePassword(differentRequest),
        ).called(1);
      });

      test(
        'deve propagar erro do repository para senha atual incorreta',
        () async {
          // Arrange
          when(
            () => mockProfileRepository.updatePassword(any()),
          ).thenThrow(Exception('Senha atual incorreta'));

          // Act & Assert
          expect(
            () => updateUserPasswordUseCase.call(updatePasswordRequest),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Senha atual incorreta'),
              ),
            ),
          );
          verify(
            () => mockProfileRepository.updatePassword(updatePasswordRequest),
          ).called(1);
        },
      );

      test(
        'deve propagar erro do repository para nova senha inválida',
        () async {
          // Arrange
          when(() => mockProfileRepository.updatePassword(any())).thenThrow(
            Exception('Nova senha não atende aos requisitos de segurança'),
          );

          // Act & Assert
          expect(
            () => updateUserPasswordUseCase.call(updatePasswordRequest),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Nova senha não atende aos requisitos'),
              ),
            ),
          );
          verify(
            () => mockProfileRepository.updatePassword(updatePasswordRequest),
          ).called(1);
        },
      );

      test('deve propagar erro do repository para senha muito fraca', () async {
        // Arrange
        when(
          () => mockProfileRepository.updatePassword(any()),
        ).thenThrow(Exception('A nova senha é muito fraca'));

        // Act & Assert
        expect(
          () => updateUserPasswordUseCase.call(updatePasswordRequest),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('senha é muito fraca'),
            ),
          ),
        );
        verify(
          () => mockProfileRepository.updatePassword(updatePasswordRequest),
        ).called(1);
      });

      test(
        'deve propagar erro do repository para usuário não autenticado',
        () async {
          // Arrange
          when(
            () => mockProfileRepository.updatePassword(any()),
          ).thenThrow(Exception('Usuário não autenticado'));

          // Act & Assert
          expect(
            () => updateUserPasswordUseCase.call(updatePasswordRequest),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Usuário não autenticado'),
              ),
            ),
          );
          verify(
            () => mockProfileRepository.updatePassword(updatePasswordRequest),
          ).called(1);
        },
      );

      test('deve propagar erro do repository para token expirado', () async {
        // Arrange
        when(
          () => mockProfileRepository.updatePassword(any()),
        ).thenThrow(Exception('Token de acesso expirado'));

        // Act & Assert
        expect(
          () => updateUserPasswordUseCase.call(updatePasswordRequest),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Token de acesso expirado'),
            ),
          ),
        );
        verify(
          () => mockProfileRepository.updatePassword(updatePasswordRequest),
        ).called(1);
      });

      test('deve propagar erro de conectividade', () async {
        // Arrange
        when(
          () => mockProfileRepository.updatePassword(any()),
        ).thenThrow(Exception('Falha na conexão com o servidor'));

        // Act & Assert
        expect(
          () => updateUserPasswordUseCase.call(updatePasswordRequest),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Falha na conexão'),
            ),
          ),
        );
        verify(
          () => mockProfileRepository.updatePassword(updatePasswordRequest),
        ).called(1);
      });

      test('deve propagar erro genérico do repository', () async {
        // Arrange
        when(
          () => mockProfileRepository.updatePassword(any()),
        ).thenThrow(Exception('Erro interno do servidor'));

        // Act & Assert
        expect(
          () => updateUserPasswordUseCase.call(updatePasswordRequest),
          throwsA(isA<Exception>()),
        );
        verify(
          () => mockProfileRepository.updatePassword(updatePasswordRequest),
        ).called(1);
      });

      test('deve atualizar senhas múltiplas vezes', () async {
        // Arrange
        final requests = [
          UpdatePasswordRequest(
            currentPassword: 'pass1',
            newPassword: 'newPass1',
          ),
          UpdatePasswordRequest(
            currentPassword: 'pass2',
            newPassword: 'newPass2',
          ),
          UpdatePasswordRequest(
            currentPassword: 'pass3',
            newPassword: 'newPass3',
          ),
        ];

        for (final request in requests) {
          when(
            () => mockProfileRepository.updatePassword(request),
          ).thenAnswer((_) async => {});
        }

        // Act
        for (final request in requests) {
          await updateUserPasswordUseCase.call(request);
        }

        // Assert
        for (final request in requests) {
          verify(() => mockProfileRepository.updatePassword(request)).called(1);
        }
      });

      test('deve funcionar com senhas contendo caracteres especiais', () async {
        // Arrange
        final specialCharsRequest = UpdatePasswordRequest(
          currentPassword: 'current@Pass123#',
          newPassword: 'new\$Password456!&',
        );

        when(
          () => mockProfileRepository.updatePassword(any()),
        ).thenAnswer((_) async => {});

        // Act
        await updateUserPasswordUseCase.call(specialCharsRequest);

        // Assert
        verify(
          () => mockProfileRepository.updatePassword(specialCharsRequest),
        ).called(1);
      });
    });
  });
}
