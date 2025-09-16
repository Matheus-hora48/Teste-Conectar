import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:frontend/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:frontend/features/profile/domain/entities/profile_user.dart';
import 'package:frontend/core/network/api_service.dart';

class MockApiService extends Mock implements ApiService {}

class FakeResponse extends Fake implements Response<dynamic> {}

class FakeUpdateProfileRequest extends Fake implements UpdateProfileRequest {}

class FakeUpdatePasswordRequest extends Fake implements UpdatePasswordRequest {}

void main() {
  late ProfileRepositoryImpl profileRepositoryImpl;
  late MockApiService mockApiService;

  setUpAll(() {
    registerFallbackValue(FakeResponse());
    registerFallbackValue(FakeUpdateProfileRequest());
    registerFallbackValue(FakeUpdatePasswordRequest());
  });

  setUp(() {
    mockApiService = MockApiService();
    profileRepositoryImpl = ProfileRepositoryImpl(mockApiService);
  });

  group('ProfileRepositoryImpl Tests', () {
    group('getProfile', () {
      test('deve retornar ProfileUser ao buscar perfil com sucesso', () async {
        final mockResponse = Response<dynamic>(
          data: {
            'id': 1,
            'name': 'Usuario Teste',
            'email': 'teste@email.com',
            'role': 'USER',
            'createdAt': '2024-01-01T10:00:00Z',
            'updatedAt': '2024-01-02T11:00:00Z',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/users/profile/me'),
        );

        when(
          () => mockApiService.get('/users/profile/me'),
        ).thenAnswer((_) async => mockResponse);

        final result = await profileRepositoryImpl.getProfile();

        expect(result, isA<ProfileUser>());
        expect(result.id, equals(1));
        expect(result.name, equals('Usuario Teste'));
        expect(result.email, equals('teste@email.com'));
        expect(result.role, equals('USER'));
        verify(() => mockApiService.get('/users/profile/me')).called(1);
      });

      test('deve retornar ProfileUser com role ADMIN', () async {
        final mockResponse = Response<dynamic>(
          data: {
            'id': 2,
            'name': 'Admin Teste',
            'email': 'admin@email.com',
            'role': 'ADMIN',
            'createdAt': '2024-01-01T10:00:00Z',
            'updatedAt': '2024-01-02T11:00:00Z',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/users/profile/me'),
        );

        when(
          () => mockApiService.get('/users/profile/me'),
        ).thenAnswer((_) async => mockResponse);

        final result = await profileRepositoryImpl.getProfile();

        expect(result, isA<ProfileUser>());
        expect(result.id, equals(2));
        expect(result.role, equals('ADMIN'));
        verify(() => mockApiService.get('/users/profile/me')).called(1);
      });

      test('deve retornar ProfileUser com informações atualizadas', () async {
        final mockResponse = Response<dynamic>(
          data: {
            'id': 3,
            'name': 'Usuario Atualizado',
            'email': 'atualizado@email.com',
            'role': 'USER',
            'createdAt': '2024-01-01T10:00:00Z',
            'updatedAt': '2024-01-02T11:00:00Z',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/users/profile/me'),
        );

        when(
          () => mockApiService.get('/users/profile/me'),
        ).thenAnswer((_) async => mockResponse);

        final result = await profileRepositoryImpl.getProfile();

        expect(result, isA<ProfileUser>());
        expect(result.name, equals('Usuario Atualizado'));
        verify(() => mockApiService.get('/users/profile/me')).called(1);
      });

      test(
        'deve lançar exceção quando ApiService falha com erro 401',
        () async {
          when(() => mockApiService.get('/users/profile/me')).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: '/users/profile/me'),
              response: Response(
                statusCode: 401,
                requestOptions: RequestOptions(path: '/users/profile/me'),
              ),
            ),
          );

          expect(
            () => profileRepositoryImpl.getProfile(),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Erro ao carregar perfil'),
              ),
            ),
          );
          verify(() => mockApiService.get('/users/profile/me')).called(1);
        },
      );

      test(
        'deve lançar exceção quando ApiService falha com erro 404',
        () async {
          when(() => mockApiService.get('/users/profile/me')).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: '/users/profile/me'),
              response: Response(
                statusCode: 404,
                requestOptions: RequestOptions(path: '/users/profile/me'),
              ),
            ),
          );

          expect(
            () => profileRepositoryImpl.getProfile(),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Erro ao carregar perfil'),
              ),
            ),
          );
          verify(() => mockApiService.get('/users/profile/me')).called(1);
        },
      );

      test(
        'deve lançar exceção quando ApiService falha com erro 500',
        () async {
          when(() => mockApiService.get('/users/profile/me')).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: '/users/profile/me'),
              response: Response(
                statusCode: 500,
                requestOptions: RequestOptions(path: '/users/profile/me'),
              ),
            ),
          );

          expect(
            () => profileRepositoryImpl.getProfile(),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Erro ao carregar perfil'),
              ),
            ),
          );
          verify(() => mockApiService.get('/users/profile/me')).called(1);
        },
      );

      test('deve lançar exceção quando há erro de conectividade', () async {
        when(() => mockApiService.get('/users/profile/me')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/users/profile/me'),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        expect(
          () => profileRepositoryImpl.getProfile(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Erro ao carregar perfil'),
            ),
          ),
        );
        verify(() => mockApiService.get('/users/profile/me')).called(1);
      });

      test(
        'deve lançar exceção quando dados de resposta são inválidos',
        () async {
          final mockResponse = Response<dynamic>(
            data: null,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/users/profile/me'),
          );

          when(
            () => mockApiService.get('/users/profile/me'),
          ).thenAnswer((_) async => mockResponse);

          expect(
            () => profileRepositoryImpl.getProfile(),
            throwsA(isA<Exception>()),
          );
          verify(() => mockApiService.get('/users/profile/me')).called(1);
        },
      );
    });

    group('updateProfile', () {
      final updateProfileRequest = UpdateProfileRequest(
        name: 'Novo Usuario',
        email: 'novo@email.com',
      );

      test('deve retornar ProfileUser atualizado com sucesso', () async {
        final mockResponse = Response<dynamic>(
          data: {
            'id': 1,
            'name': 'Novo Usuario',
            'email': 'novo@email.com',
            'role': 'USER',
            'createdAt': '2024-01-01T10:00:00Z',
            'updatedAt': '2024-01-02T12:00:00Z',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/users/profile/me'),
        );

        when(
          () => mockApiService.patch(
            '/users/profile/me',
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await profileRepositoryImpl.updateProfile(
          updateProfileRequest,
        );

        expect(result, isA<ProfileUser>());
        expect(result.name, equals('Novo Usuario'));
        expect(result.email, equals('novo@email.com'));
        verify(
          () => mockApiService.patch(
            '/users/profile/me',
            data: any(named: 'data'),
          ),
        ).called(1);
      });

      test('deve atualizar apenas nome', () async {
        final partialRequest = UpdateProfileRequest(
          name: 'Usuario Alterado',
          email: 'email_original@teste.com',
        );

        final mockResponse = Response<dynamic>(
          data: {
            'id': 1,
            'name': 'Usuario Alterado',
            'email': 'email_original@teste.com',
            'role': 'USER',
            'createdAt': '2024-01-01T10:00:00Z',
            'updatedAt': '2024-01-02T12:30:00Z',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/users/profile/me'),
        );

        when(
          () => mockApiService.patch(
            '/users/profile/me',
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await profileRepositoryImpl.updateProfile(
          partialRequest,
        );

        expect(result.name, equals('Usuario Alterado'));
        verify(
          () => mockApiService.patch(
            '/users/profile/me',
            data: any(named: 'data'),
          ),
        ).called(1);
      });

      test('deve atualizar apenas email', () async {
        final emailRequest = UpdateProfileRequest(
          name: 'Usuario Original',
          email: 'email_novo@teste.com',
        );

        final mockResponse = Response<dynamic>(
          data: {
            'id': 1,
            'name': 'Usuario Original',
            'email': 'email_novo@teste.com',
            'role': 'USER',
            'createdAt': '2024-01-01T10:00:00Z',
            'updatedAt': '2024-01-02T13:00:00Z',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/users/profile/me'),
        );

        when(
          () => mockApiService.patch(
            '/users/profile/me',
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await profileRepositoryImpl.updateProfile(emailRequest);

        expect(result.email, equals('email_novo@teste.com'));
        verify(
          () => mockApiService.patch(
            '/users/profile/me',
            data: any(named: 'data'),
          ),
        ).called(1);
      });

      test(
        'deve lançar exceção quando ApiService falha com erro 400',
        () async {
          when(
            () => mockApiService.patch(
              '/users/profile/me',
              data: any(named: 'data'),
            ),
          ).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: '/users/profile/me'),
              response: Response(
                statusCode: 400,
                requestOptions: RequestOptions(path: '/users/profile/me'),
              ),
            ),
          );

          expect(
            () => profileRepositoryImpl.updateProfile(updateProfileRequest),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Erro ao atualizar perfil'),
              ),
            ),
          );
          verify(
            () => mockApiService.patch(
              '/users/profile/me',
              data: any(named: 'data'),
            ),
          ).called(1);
        },
      );

      test(
        'deve lançar exceção quando ApiService falha com erro 401',
        () async {
          when(
            () => mockApiService.patch(
              '/users/profile/me',
              data: any(named: 'data'),
            ),
          ).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: '/users/profile/me'),
              response: Response(
                statusCode: 401,
                requestOptions: RequestOptions(path: '/users/profile/me'),
              ),
            ),
          );

          expect(
            () => profileRepositoryImpl.updateProfile(updateProfileRequest),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Erro ao atualizar perfil'),
              ),
            ),
          );
          verify(
            () => mockApiService.patch(
              '/users/profile/me',
              data: any(named: 'data'),
            ),
          ).called(1);
        },
      );

      test('deve lançar exceção quando há erro de conectividade', () async {
        when(
          () => mockApiService.patch(
            '/users/profile/me',
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/users/profile/me'),
            type: DioExceptionType.receiveTimeout,
          ),
        );

        expect(
          () => profileRepositoryImpl.updateProfile(updateProfileRequest),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Erro ao atualizar perfil'),
            ),
          ),
        );
        verify(
          () => mockApiService.patch(
            '/users/profile/me',
            data: any(named: 'data'),
          ),
        ).called(1);
      });
    });

    group('updatePassword', () {
      final updatePasswordRequest = UpdatePasswordRequest(
        currentPassword: 'senhaAtual123',
        newPassword: 'novaSenha456',
      );

      test('deve atualizar senha com sucesso', () async {
        final mockResponse = Response<dynamic>(
          data: {},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/users/profile/me/password'),
        );

        when(
          () => mockApiService.patch(
            '/users/profile/me/password',
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => mockResponse);

        expect(
          () => profileRepositoryImpl.updatePassword(updatePasswordRequest),
          returnsNormally,
        );

        await profileRepositoryImpl.updatePassword(updatePasswordRequest);

        verify(
          () => mockApiService.patch(
            '/users/profile/me/password',
            data: any(named: 'data'),
          ),
        ).called(1);
      });

      test('deve atualizar senha com senhas diferentes', () async {
        final differentRequest = UpdatePasswordRequest(
          currentPassword: 'outraSenhaAtual789',
          newPassword: 'outraNovaSenha012',
        );

        final mockResponse = Response<dynamic>(
          data: {},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/users/profile/me/password'),
        );

        when(
          () => mockApiService.patch(
            '/users/profile/me/password',
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => mockResponse);

        await profileRepositoryImpl.updatePassword(differentRequest);

        verify(
          () => mockApiService.patch(
            '/users/profile/me/password',
            data: any(named: 'data'),
          ),
        ).called(1);
      });

      test(
        'deve lançar exceção quando ApiService falha com erro 400 (senha atual incorreta)',
        () async {
          when(
            () => mockApiService.patch(
              '/users/profile/me/password',
              data: any(named: 'data'),
            ),
          ).thenThrow(
            DioException(
              requestOptions: RequestOptions(
                path: '/users/profile/me/password',
              ),
              response: Response(
                statusCode: 400,
                requestOptions: RequestOptions(
                  path: '/users/profile/me/password',
                ),
              ),
            ),
          );

          expect(
            () => profileRepositoryImpl.updatePassword(updatePasswordRequest),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Erro ao alterar senha'),
              ),
            ),
          );
          verify(
            () => mockApiService.patch(
              '/users/profile/me/password',
              data: any(named: 'data'),
            ),
          ).called(1);
        },
      );

      test(
        'deve lançar exceção quando ApiService falha com erro 401',
        () async {
          when(
            () => mockApiService.patch(
              '/users/profile/me/password',
              data: any(named: 'data'),
            ),
          ).thenThrow(
            DioException(
              requestOptions: RequestOptions(
                path: '/users/profile/me/password',
              ),
              response: Response(
                statusCode: 401,
                requestOptions: RequestOptions(
                  path: '/users/profile/me/password',
                ),
              ),
            ),
          );

          expect(
            () => profileRepositoryImpl.updatePassword(updatePasswordRequest),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Erro ao alterar senha'),
              ),
            ),
          );
          verify(
            () => mockApiService.patch(
              '/users/profile/me/password',
              data: any(named: 'data'),
            ),
          ).called(1);
        },
      );

      test(
        'deve lançar exceção quando ApiService falha com erro 422 (nova senha inválida)',
        () async {
          when(
            () => mockApiService.patch(
              '/users/profile/me/password',
              data: any(named: 'data'),
            ),
          ).thenThrow(
            DioException(
              requestOptions: RequestOptions(
                path: '/users/profile/me/password',
              ),
              response: Response(
                statusCode: 422,
                requestOptions: RequestOptions(
                  path: '/users/profile/me/password',
                ),
              ),
            ),
          );

          expect(
            () => profileRepositoryImpl.updatePassword(updatePasswordRequest),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Erro ao alterar senha'),
              ),
            ),
          );
          verify(
            () => mockApiService.patch(
              '/users/profile/me/password',
              data: any(named: 'data'),
            ),
          ).called(1);
        },
      );

      test('deve lançar exceção quando há erro de conectividade', () async {
        when(
          () => mockApiService.patch(
            '/users/profile/me/password',
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/users/profile/me/password'),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        expect(
          () => profileRepositoryImpl.updatePassword(updatePasswordRequest),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Erro ao alterar senha'),
            ),
          ),
        );
        verify(
          () => mockApiService.patch(
            '/users/profile/me/password',
            data: any(named: 'data'),
          ),
        ).called(1);
      });

      test('deve lançar exceção quando há erro de timeout de envio', () async {
        when(
          () => mockApiService.patch(
            '/users/profile/me/password',
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/users/profile/me/password'),
            type: DioExceptionType.sendTimeout,
          ),
        );

        expect(
          () => profileRepositoryImpl.updatePassword(updatePasswordRequest),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Erro ao alterar senha'),
            ),
          ),
        );
        verify(
          () => mockApiService.patch(
            '/users/profile/me/password',
            data: any(named: 'data'),
          ),
        ).called(1);
      });

      test('deve funcionar com senhas contendo caracteres especiais', () async {
        final specialRequest = UpdatePasswordRequest(
          currentPassword: 'current@Pass123#',
          newPassword: 'new\$Password456!&',
        );

        final mockResponse = Response<dynamic>(
          data: {},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/users/profile/me/password'),
        );

        when(
          () => mockApiService.patch(
            '/users/profile/me/password',
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => mockResponse);

        await profileRepositoryImpl.updatePassword(specialRequest);

        verify(
          () => mockApiService.patch(
            '/users/profile/me/password',
            data: any(named: 'data'),
          ),
        ).called(1);
      });
    });
  });
}
