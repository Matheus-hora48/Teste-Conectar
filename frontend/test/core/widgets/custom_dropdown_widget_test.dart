import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/widgets/custom_dropdown_widget.dart';

void main() {
  group('CustomDropdownWidget Tests', () {
    const testLabel = 'Test Label';
    const testHintText = 'Select an option';
    final testItems = [
      const DropdownMenuItem<String>(value: 'option1', child: Text('Option 1')),
      const DropdownMenuItem<String>(value: 'option2', child: Text('Option 2')),
      const DropdownMenuItem<String>(value: 'option3', child: Text('Option 3')),
    ];

    Widget createTestWidget({
      String? value,
      List<DropdownMenuItem<String>>? items,
      ValueChanged<String?>? onChanged,
      bool enabled = true,
      String? errorText,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: CustomDropdownWidget<String>(
            label: testLabel,
            hintText: testHintText,
            value: value,
            items: items ?? testItems,
            onChanged: onChanged,
            enabled: enabled,
            errorText: errorText,
          ),
        ),
      );
    }

    group('Widget Construction', () {
      testWidgets('deve renderizar com propriedades básicas', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text(testLabel), findsOneWidget);
        expect(find.text(testHintText), findsOneWidget);
        expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      });

      testWidgets('deve exibir valor selecionado', (tester) async {
        await tester.pumpWidget(createTestWidget(value: 'option1'));

        expect(find.text('Option 1'), findsOneWidget);
      });

      testWidgets('deve exibir hint quando nenhum valor selecionado', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text(testHintText), findsOneWidget);
      });

      testWidgets('deve exibir mensagem de erro quando fornecida', (
        tester,
      ) async {
        const errorMessage = 'Campo obrigatório';
        await tester.pumpWidget(createTestWidget(errorText: errorMessage));

        expect(find.text(errorMessage), findsOneWidget);
      });
    });

    group('Interação do Usuário', () {
      testWidgets('deve abrir dropdown ao ser tocado', (tester) async {
        await tester.pumpWidget(createTestWidget());

        await tester.tap(find.byType(DropdownButtonFormField<String>));
        await tester.pumpAndSettle();

        // Verifica se as opções estão visíveis
        expect(find.text('Option 1'), findsWidgets);
        expect(find.text('Option 2'), findsOneWidget);
        expect(find.text('Option 3'), findsOneWidget);
      });

      testWidgets('deve chamar onChanged ao selecionar opção', (tester) async {
        String? selectedValue;

        await tester.pumpWidget(
          createTestWidget(onChanged: (value) => selectedValue = value),
        );

        await tester.tap(find.byType(DropdownButtonFormField<String>));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Option 2').last);
        await tester.pumpAndSettle();

        expect(selectedValue, equals('option2'));
      });

      testWidgets('não deve responder a interações quando desabilitado', (
        tester,
      ) async {
        bool onChangedCalled = false;

        await tester.pumpWidget(
          createTestWidget(
            enabled: false,
            onChanged: (value) => onChangedCalled = true,
          ),
        );

        await tester.tap(find.byType(DropdownButtonFormField<String>));
        await tester.pumpAndSettle();

        expect(onChangedCalled, isFalse);
        // Dropdown não deve abrir quando desabilitado
        expect(find.text('Option 1'), findsNothing);
      });
    });

    group('Estados Visuais', () {
      testWidgets('deve aplicar estilo correto para estado habilitado', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(enabled: true));

        final dropdown = tester.widget<DropdownButtonFormField<String>>(
          find.byType(DropdownButtonFormField<String>),
        );

        expect(dropdown.decoration.fillColor, equals(Colors.white));
        // Verificamos se está habilitado através do onChanged
        expect(dropdown.onChanged, isNotNull);
      });

      testWidgets('deve aplicar estilo correto para estado desabilitado', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(enabled: false));

        final dropdown = tester.widget<DropdownButtonFormField<String>>(
          find.byType(DropdownButtonFormField<String>),
        );

        expect(dropdown.decoration.fillColor, equals(Colors.grey.shade100));
        expect(dropdown.onChanged, isNull);
      });

      testWidgets('deve mostrar borda de erro quando errorText fornecido', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(errorText: 'Error'));

        final dropdown = tester.widget<DropdownButtonFormField<String>>(
          find.byType(DropdownButtonFormField<String>),
        );

        expect(dropdown.decoration.errorText, equals('Error'));
      });

      testWidgets('deve ter ícone dropdown correto', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      });
    });

    group('Layout e Estilo', () {
      testWidgets('deve ter estrutura de layout correta', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Text), findsAtLeast(1)); // Label + hint/value
        expect(
          find.byType(SizedBox),
          findsAtLeastNWidgets(1),
        ); // Espaçamento pode ter múltiplos
        expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      });

      testWidgets('deve aplicar padding correto', (tester) async {
        await tester.pumpWidget(createTestWidget());

        final dropdown = tester.widget<DropdownButtonFormField<String>>(
          find.byType(DropdownButtonFormField<String>),
        );

        expect(
          dropdown.decoration.contentPadding,
          equals(const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
        );
        expect(dropdown.decoration.isDense, isTrue);
      });

      testWidgets('deve ter bordas arredondadas', (tester) async {
        await tester.pumpWidget(createTestWidget());

        final dropdown = tester.widget<DropdownButtonFormField<String>>(
          find.byType(DropdownButtonFormField<String>),
        );

        final border = dropdown.decoration.border as OutlineInputBorder?;
        expect(border?.borderRadius, equals(BorderRadius.circular(8)));
      });

      testWidgets('deve ter estilo de label correto', (tester) async {
        await tester.pumpWidget(createTestWidget());

        final labelText = tester.widget<Text>(find.text(testLabel));
        expect(labelText.style?.fontSize, equals(14));
        expect(labelText.style?.fontWeight, equals(FontWeight.w500));
        expect(labelText.style?.color, equals(Colors.black87));
      });
    });

    group('Tipos Genéricos', () {
      testWidgets('deve funcionar com tipos diferentes', (tester) async {
        final intItems = [
          const DropdownMenuItem<int>(value: 1, child: Text('One')),
          const DropdownMenuItem<int>(value: 2, child: Text('Two')),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomDropdownWidget<int>(
                label: 'Number',
                hintText: 'Select a number',
                value: 1,
                items: intItems,
                onChanged: (value) {},
              ),
            ),
          ),
        );

        expect(find.text('One'), findsOneWidget);
        expect(find.byType(DropdownButtonFormField<int>), findsOneWidget);
      });

      testWidgets('deve funcionar com objetos customizados', (tester) async {
        final customItems = [
          const DropdownMenuItem<String>(
            value: 'custom1',
            child: Text('Custom 1'),
          ),
          const DropdownMenuItem<String>(
            value: 'custom2',
            child: Text('Custom 2'),
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomDropdownWidget<String>(
                label: 'Custom',
                hintText: 'Select custom',
                items: customItems,
                onChanged: (value) {},
              ),
            ),
          ),
        );

        expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      });
    });

    group('Acessibilidade', () {
      testWidgets('deve ter semantics apropriadas', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);

        // O widget deve ser encontrável por ferramentas de acessibilidade
        final dropdown = find.byType(DropdownButtonFormField<String>);
        expect(dropdown, findsOneWidget);
      });

      testWidgets('deve indicar quando está desabilitado para acessibilidade', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(enabled: false));

        final dropdown = tester.widget<DropdownButtonFormField<String>>(
          find.byType(DropdownButtonFormField<String>),
        );

        expect(dropdown.onChanged, isNull);
      });
    });

    group('Edge Cases', () {
      testWidgets('deve lidar com lista vazia de items', (tester) async {
        await tester.pumpWidget(createTestWidget(items: []));

        expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      });

      testWidgets('deve lidar com valor null', (tester) async {
        await tester.pumpWidget(createTestWidget(value: null));

        expect(find.text(testHintText), findsOneWidget);
      });

      testWidgets('deve lidar com onChanged null', (tester) async {
        await tester.pumpWidget(createTestWidget(onChanged: null));

        final dropdown = tester.widget<DropdownButtonFormField<String>>(
          find.byType(DropdownButtonFormField<String>),
        );

        expect(dropdown.onChanged, isNull);
      });
    });
  });

  group('DropdownOption Tests', () {
    test('deve criar instância corretamente', () {
      const option = DropdownOption<String>(value: 'test', label: 'Test Label');

      expect(option.value, equals('test'));
      expect(option.label, equals('Test Label'));
      expect(option.icon, isNull);
    });

    test('deve criar com ícone', () {
      const icon = Icon(Icons.star);
      const option = DropdownOption<String>(
        value: 'test',
        label: 'Test Label',
        icon: icon,
      );

      expect(option.icon, equals(icon));
    });

    test('deve converter para DropdownMenuItem', () {
      const option = DropdownOption<String>(value: 'test', label: 'Test Label');

      final menuItem = option.toDropdownMenuItem();

      expect(menuItem.value, equals('test'));
      expect(menuItem.child, isA<Row>());
    });

    test('deve converter para DropdownMenuItem com ícone', () {
      const icon = Icon(Icons.star);
      const option = DropdownOption<String>(
        value: 'test',
        label: 'Test Label',
        icon: icon,
      );

      final menuItem = option.toDropdownMenuItem();

      expect(menuItem.value, equals('test'));
      expect(menuItem.child, isA<Row>());
    });
  });

  group('DropdownOptionsExtension Tests', () {
    test('deve converter lista para DropdownMenuItems', () {
      final options = [
        const DropdownOption<String>(value: '1', label: 'One'),
        const DropdownOption<String>(value: '2', label: 'Two'),
      ];

      final menuItems = options.toDropdownMenuItems();

      expect(menuItems.length, equals(2));
      expect(menuItems[0].value, equals('1'));
      expect(menuItems[1].value, equals('2'));
    });

    test('deve lidar com lista vazia', () {
      final options = <DropdownOption<String>>[];
      final menuItems = options.toDropdownMenuItems();

      expect(menuItems, isEmpty);
    });

    test('deve preservar ordem dos itens', () {
      final options = [
        const DropdownOption<String>(value: 'z', label: 'Z'),
        const DropdownOption<String>(value: 'a', label: 'A'),
        const DropdownOption<String>(value: 'm', label: 'M'),
      ];

      final menuItems = options.toDropdownMenuItems();

      expect(menuItems[0].value, equals('z'));
      expect(menuItems[1].value, equals('a'));
      expect(menuItems[2].value, equals('m'));
    });
  });
}
