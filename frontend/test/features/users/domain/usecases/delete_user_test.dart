import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/users/domain/usecases/delete_user.dart';
import 'package:frontend/features/users/domain/repositories/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late DeleteUser deleteUserUseCase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    deleteUserUseCase = DeleteUser(mockUserRepository);
  });

  group('DeleteUser UseCase Tests', () {
    group('call', () {
      test('deve deletar usuário com sucesso', () async {
        // Arrange
        const userId = 1;
        when(
          () => mockUserRepository.deleteUser(userId),
        ).thenAnswer((_) async => {});

        // Act
        await deleteUserUseCase.call(userId);

        // Assert
        verify(() => mockUserRepository.deleteUser(userId)).called(1);
      });

      test('deve deletar usuário com ID diferente com sucesso', () async {
        // Arrange
        const userId = 42;
        when(
          () => mockUserRepository.deleteUser(userId),
        ).thenAnswer((_) async => {});

        // Act
        await deleteUserUseCase.call(userId);

        // Assert
        verify(() => mockUserRepository.deleteUser(userId)).called(1);
      });

      test(
        'deve propagar erro do repository para usuário não encontrado',
        () async {
          // Arrange
          const userId = 999;
          when(
            () => mockUserRepository.deleteUser(userId),
          ).thenThrow(Exception('Usuário não encontrado'));

          // Act & Assert
          expect(
            () => deleteUserUseCase.call(userId),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Usuário não encontrado'),
              ),
            ),
          );
          verify(() => mockUserRepository.deleteUser(userId)).called(1);
        },
      );

      test(
        'deve propagar erro do repository para usuário com relacionamentos',
        () async {
          // Arrange
          const userId = 1;
          when(() => mockUserRepository.deleteUser(userId)).thenThrow(
            Exception(
              'Não é possível deletar usuário com relacionamentos ativos',
            ),
          );

          // Act & Assert
          expect(
            () => deleteUserUseCase.call(userId),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('relacionamentos ativos'),
              ),
            ),
          );
          verify(() => mockUserRepository.deleteUser(userId)).called(1);
        },
      );

      test(
        'deve propagar erro do repository para falta de permissão',
        () async {
          // Arrange
          const userId = 1;
          when(() => mockUserRepository.deleteUser(userId)).thenThrow(
            Exception('Você não tem permissão para deletar este usuário'),
          );

          // Act & Assert
          expect(
            () => deleteUserUseCase.call(userId),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('não tem permissão'),
              ),
            ),
          );
          verify(() => mockUserRepository.deleteUser(userId)).called(1);
        },
      );

      test(
        'deve propagar erro do repository para tentativa de auto-deleção',
        () async {
          // Arrange
          const userId = 1;
          when(
            () => mockUserRepository.deleteUser(userId),
          ).thenThrow(Exception('Você não pode deletar sua própria conta'));

          // Act & Assert
          expect(
            () => deleteUserUseCase.call(userId),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('não pode deletar sua própria conta'),
              ),
            ),
          );
          verify(() => mockUserRepository.deleteUser(userId)).called(1);
        },
      );

      test('deve propagar erro genérico do repository', () async {
        // Arrange
        const userId = 1;
        when(
          () => mockUserRepository.deleteUser(userId),
        ).thenThrow(Exception('Erro interno do servidor'));

        // Act & Assert
        expect(
          () => deleteUserUseCase.call(userId),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Erro interno do servidor'),
            ),
          ),
        );
        verify(() => mockUserRepository.deleteUser(userId)).called(1);
      });

      test('deve propagar erro de conectividade', () async {
        // Arrange
        const userId = 1;
        when(
          () => mockUserRepository.deleteUser(userId),
        ).thenThrow(Exception('Falha na conexão com o servidor'));

        // Act & Assert
        expect(
          () => deleteUserUseCase.call(userId),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Falha na conexão'),
            ),
          ),
        );
        verify(() => mockUserRepository.deleteUser(userId)).called(1);
      });

      test('deve chamar repository com o ID correto múltiplas vezes', () async {
        // Arrange
        const userIds = [1, 2, 3, 4, 5];
        for (final id in userIds) {
          when(
            () => mockUserRepository.deleteUser(id),
          ).thenAnswer((_) async => {});
        }

        // Act
        for (final id in userIds) {
          await deleteUserUseCase.call(id);
        }

        // Assert
        for (final id in userIds) {
          verify(() => mockUserRepository.deleteUser(id)).called(1);
        }
      });
    });
  });
}
