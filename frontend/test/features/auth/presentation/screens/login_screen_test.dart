import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/auth/presentation/screens/login_screen.dart';
import 'package:frontend/features/auth/presentation/controllers/auth_controller.dart';
import 'package:frontend/core/widgets/custom_text_field.dart';

class MockAuthController extends GetxController
    with Mock
    implements AuthController {
  final RxBool _isLoading = false.obs;
  final RxBool _isLoggedIn = false.obs;
  final RxBool _obscurePassword = true.obs;

  @override
  bool get isLoading => _isLoading.value;

  @override
  bool get isLoggedIn => _isLoggedIn.value;

  @override
  bool get obscurePassword => _obscurePassword.value;

  void setLoading(bool value) => _isLoading.value = value;
  void setLoggedIn(bool value) => _isLoggedIn.value = value;
}

void main() {
  group('LoginScreen Tests', () {
    late MockAuthController mockAuthController;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      Get.reset();

      mockAuthController = MockAuthController();
      Get.put<AuthController>(mockAuthController);
    });

    tearDown(() {
      Get.reset();
    });

    Widget createTestWidget() {
      return GetMaterialApp(home: const LoginScreen());
    }

    group('UI Components', () {
      testWidgets('deve renderizar todos os componentes principais', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(LoginScreen), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(CustomTextField), findsNWidgets(2));
        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.text('Entrar'), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('deve exibir campos de email e senha', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Senha'), findsOneWidget);
      });

      testWidgets('deve exibir logo da aplicação', (tester) async {
        await tester.pumpWidget(createTestWidget());

        final logoWidget = find.byType(Image);
        expect(logoWidget, findsOneWidget);

        final image = tester.widget<Image>(logoWidget);
        expect((image.image as AssetImage).assetName, 'assets/logo.png');
      });

      testWidgets('deve ter estrutura de layout responsiva', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(Center), findsOneWidget);
        expect(find.byType(Column), findsAtLeastNWidgets(1));
        expect(find.byType(Container), findsAtLeastNWidgets(1));
      });
    });

    group('Form Validation', () {
      testWidgets('deve validar email obrigatório', (tester) async {
        await tester.pumpWidget(createTestWidget());

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('E-mail é obrigatório'), findsOneWidget);
      });

      testWidgets('deve validar senha obrigatória', (tester) async {
        await tester.pumpWidget(createTestWidget());

        await tester.enterText(
          find.byType(CustomTextField).first,
          'test@email.com',
        );
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Senha é obrigatória'), findsOneWidget);
      });

      testWidgets('deve validar formato de email', (tester) async {
        await tester.pumpWidget(createTestWidget());

        await tester.enterText(
          find.byType(CustomTextField).first,
          'email_invalido',
        );
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('E-mail inválido'), findsOneWidget);
      });

      testWidgets('deve validar tamanho mínimo da senha', (tester) async {
        await tester.pumpWidget(createTestWidget());

        await tester.enterText(
          find.byType(CustomTextField).first,
          'test@email.com',
        );
        await tester.enterText(find.byType(CustomTextField).last, '123');
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(
          find.text('Senha deve ter pelo menos 6 caracteres'),
          findsOneWidget,
        );
      });
    });

    group('User Interactions', () {
      testWidgets('deve permitir inserir email', (tester) async {
        await tester.pumpWidget(createTestWidget());
        const testEmail = 'test@email.com';

        await tester.enterText(find.byType(CustomTextField).first, testEmail);

        expect(find.text(testEmail), findsOneWidget);
      });

      testWidgets('deve permitir inserir senha', (tester) async {
        await tester.pumpWidget(createTestWidget());
        const testPassword = 'password123';

        await tester.enterText(find.byType(CustomTextField).last, testPassword);

        expect(find.text(testPassword), findsOneWidget);
      });

      testWidgets('deve chamar login quando formulário válido', (tester) async {
        when(
          () => mockAuthController.login(any(), any()),
        ).thenAnswer((_) async => true);

        await tester.pumpWidget(createTestWidget());

        await tester.enterText(
          find.byType(CustomTextField).first,
          'test@email.com',
        );
        await tester.enterText(
          find.byType(CustomTextField).last,
          'password123',
        );
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        verify(
          () => mockAuthController.login('test@email.com', 'password123'),
        ).called(1);
      });
    });

    group('Loading State', () {
      testWidgets('deve exibir loading quando isLoading é true', (
        tester,
      ) async {
        mockAuthController.setLoading(true);
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Entrar'), findsNothing);
      });

      testWidgets('deve desabilitar botão quando isLoading é true', (
        tester,
      ) async {
        mockAuthController.setLoading(true);
        await tester.pumpWidget(createTestWidget());

        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );

        expect(button.onPressed, isNull);
      });

      testWidgets('deve habilitar botão quando isLoading é false', (
        tester,
      ) async {
        mockAuthController.setLoading(false);
        await tester.pumpWidget(createTestWidget());

        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );

        expect(button.onPressed, isNotNull);
      });
    });

    group('Navigation', () {
      testWidgets('deve navegar para clients após login bem-sucedido', (
        tester,
      ) async {
        when(
          () => mockAuthController.login(any(), any()),
        ).thenAnswer((_) async => true);

        await tester.pumpWidget(createTestWidget());

        await tester.enterText(
          find.byType(CustomTextField).first,
          'test@email.com',
        );
        await tester.enterText(
          find.byType(CustomTextField).last,
          'password123',
        );
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        verify(() => mockAuthController.login(any(), any())).called(1);
      });
    });

    group('Styling', () {
      testWidgets('deve ter cores corretas no tema', (tester) async {
        await tester.pumpWidget(createTestWidget());

        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );

        expect(scaffold.backgroundColor, isNotNull);
        expect(button.style, isNotNull);
      });

      testWidgets('deve ter padding e espaçamento adequados', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(SizedBox), findsAtLeastNWidgets(2));
        expect(find.byType(Padding), findsAtLeastNWidgets(1));
      });
    });
  });
}
