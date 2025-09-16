import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/widgets/erro_widget.dart';

void main() {
  group('ErroWidget Tests', () {
    const testError = 'Test error message';

    Widget createTestWidget({String? error}) {
      return MaterialApp(home: ErroWidget(error: error ?? testError));
    }

    group('Widget Construction', () {
      testWidgets('deve renderizar com mensagem de erro', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Erro na inicialização'), findsOneWidget);
        expect(find.text('Detalhes: $testError'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });

      testWidgets('deve renderizar com diferentes mensagens de erro', (
        tester,
      ) async {
        const customError = 'Custom error message';
        await tester.pumpWidget(createTestWidget(error: customError));

        expect(find.text('Detalhes: $customError'), findsOneWidget);
      });

      testWidgets('deve ter estrutura correta', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(Center), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
      });
    });

    group('Layout e Estilo', () {
      testWidgets('deve ter ícone de erro com tamanho e cor corretos', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget());

        final icon = tester.widget<Icon>(find.byIcon(Icons.error_outline));
        expect(icon.size, equals(64));
        expect(icon.color, equals(Colors.red));
      });

      testWidgets('deve ter título com estilo correto', (tester) async {
        await tester.pumpWidget(createTestWidget());

        final titleText = tester.widget<Text>(
          find.text('Erro na inicialização'),
        );
        expect(titleText.style?.fontSize, equals(18));
        expect(titleText.style?.fontWeight, equals(FontWeight.bold));
      });

      testWidgets('deve ter texto de detalhes com estilo correto', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget());

        final detailsText = tester.widget<Text>(
          find.text('Detalhes: $testError'),
        );
        expect(detailsText.style?.fontSize, equals(14));
        expect(detailsText.textAlign, equals(TextAlign.center));
      });

      testWidgets('deve ter espaçamento correto entre elementos', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(SizedBox), findsNWidgets(2));
      });

      testWidgets('deve centralizar conteúdo verticalmente', (tester) async {
        await tester.pumpWidget(createTestWidget());

        final column = tester.widget<Column>(find.byType(Column));
        expect(column.mainAxisAlignment, equals(MainAxisAlignment.center));
      });
    });

    group('Conteúdo', () {
      testWidgets('deve exibir mensagem estática corretamente', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Erro na inicialização'), findsOneWidget);
      });

      testWidgets('deve exibir detalhes do erro interpolados', (tester) async {
        const errorMessage = 'Network connection failed';
        await tester.pumpWidget(createTestWidget(error: errorMessage));

        expect(find.text('Detalhes: $errorMessage'), findsOneWidget);
      });

      testWidgets('deve lidar com mensagens de erro vazias', (tester) async {
        await tester.pumpWidget(createTestWidget(error: ''));

        expect(find.text('Detalhes: '), findsOneWidget);
      });

      testWidgets('deve lidar com mensagens de erro longas', (tester) async {
        const longError =
            'This is a very long error message that should still be displayed correctly even if it takes up multiple lines in the interface';
        await tester.pumpWidget(createTestWidget(error: longError));

        expect(find.text('Detalhes: $longError'), findsOneWidget);
      });
    });

    group('Responsividade', () {
      testWidgets('deve funcionar em diferentes tamanhos de tela', (
        tester,
      ) async {
        // Testa em tamanho pequeno
        await tester.binding.setSurfaceSize(const Size(320, 568));
        await tester.pumpWidget(createTestWidget());
        expect(find.byType(ErroWidget), findsOneWidget);

        // Testa em tamanho grande
        await tester.binding.setSurfaceSize(const Size(1920, 1080));
        await tester.pumpWidget(createTestWidget());
        expect(find.byType(ErroWidget), findsOneWidget);
      });

      testWidgets('deve manter centralização em diferentes tamanhos', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget());

        final center = tester.widget<Center>(find.byType(Center));
        expect(center, isNotNull);

        final column = tester.widget<Column>(find.byType(Column));
        expect(column.mainAxisAlignment, equals(MainAxisAlignment.center));
      });
    });

    group('Acessibilidade', () {
      testWidgets('deve ter conteúdo acessível', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verifica se textos são encontráveis para screen readers
        expect(find.text('Erro na inicialização'), findsOneWidget);
        expect(find.text('Detalhes: $testError'), findsOneWidget);

        // Verifica se ícone tem significado semântico
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('deve lidar com caracteres especiais na mensagem', (
        tester,
      ) async {
        const specialCharsError = 'Error with special chars: @#\$%^&*()';
        await tester.pumpWidget(createTestWidget(error: specialCharsError));

        expect(find.text('Detalhes: $specialCharsError'), findsOneWidget);
      });

      testWidgets('deve lidar com quebras de linha na mensagem', (
        tester,
      ) async {
        const multilineError = 'Line 1\nLine 2\nLine 3';
        await tester.pumpWidget(createTestWidget(error: multilineError));

        expect(find.text('Detalhes: $multilineError'), findsOneWidget);
      });

      testWidgets('deve funcionar como Scaffold raiz', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const ErroWidget(error: 'Test')),
        );

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(ErroWidget), findsOneWidget);
      });
    });

    group('Widget Properties', () {
      test('deve aceitar error como parâmetro obrigatório', () {
        expect(() => const ErroWidget(error: 'test'), returnsNormally);
      });

      test('deve ser StatelessWidget', () {
        const widget = ErroWidget(error: 'test');
        expect(widget, isA<StatelessWidget>());
      });

      test('deve ter key opcional', () {
        const key = Key('error_widget_key');
        const widget = ErroWidget(key: key, error: 'test');
        expect(widget.key, equals(key));
      });
    });

    group('Visual Design', () {
      testWidgets('deve seguir design system', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verifica cores do design system
        final icon = tester.widget<Icon>(find.byIcon(Icons.error_outline));
        expect(icon.color, equals(Colors.red));

        // Verifica tipografia
        final titleText = tester.widget<Text>(
          find.text('Erro na inicialização'),
        );
        expect(titleText.style?.fontWeight, equals(FontWeight.bold));

        final detailsText = tester.widget<Text>(
          find.text('Detalhes: $testError'),
        );
        expect(detailsText.style?.fontSize, isNotNull);
      });

      testWidgets('deve ter hierarquia visual clara', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Ícone -> Título -> Detalhes
        final icon = find.byIcon(Icons.error_outline);
        final title = find.text('Erro na inicialização');
        final details = find.text('Detalhes: $testError');

        expect(icon, findsOneWidget);
        expect(title, findsOneWidget);
        expect(details, findsOneWidget);
      });
    });
  });
}
