import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/clients/presentation/widgets/dados_basicos_tab_widget.dart';

void main() {
  group('DadosBasicosTabWidget Tests', () {
    late TextEditingController nameController;
    late TextEditingController cnpjController;
    late TextEditingController cidadeController;
    late bool isFiltersExpanded;
    late VoidCallback onToggle;

    setUp(() {
      nameController = TextEditingController();
      cnpjController = TextEditingController();
      cidadeController = TextEditingController();
      isFiltersExpanded = false;
      onToggle = () {};
    });

    tearDown(() {
      nameController.dispose();
      cnpjController.dispose();
      cidadeController.dispose();
    });

    testWidgets('deve renderizar widget corretamente', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DadosBasicosTabWidget(
              isFiltersExpanded: isFiltersExpanded,
              onToggle: onToggle,
              nameController: nameController,
              cnpjController: cnpjController,
              cidadeController: cidadeController,
            ),
          ),
        ),
      );

      expect(find.byType(DadosBasicosTabWidget), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('deve ter cor de fundo branca', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DadosBasicosTabWidget(
              isFiltersExpanded: isFiltersExpanded,
              onToggle: onToggle,
              nameController: nameController,
              cnpjController: cnpjController,
              cidadeController: cidadeController,
            ),
          ),
        ),
      );

      final containerWidget = tester.widget<Container>(find.byType(Container));
      expect(containerWidget.color, Colors.white);
    });

    testWidgets('deve aceitar controladores diferentes', (
      WidgetTester tester,
    ) async {
      nameController.text = 'Test Name';
      cnpjController.text = '12345678901234';
      cidadeController.text = 'Test City';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DadosBasicosTabWidget(
              isFiltersExpanded: isFiltersExpanded,
              onToggle: onToggle,
              nameController: nameController,
              cnpjController: cnpjController,
              cidadeController: cidadeController,
            ),
          ),
        ),
      );

      expect(find.byType(DadosBasicosTabWidget), findsOneWidget);
    });

    testWidgets('deve aceitar diferentes estados de filtros', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DadosBasicosTabWidget(
              isFiltersExpanded: true,
              onToggle: onToggle,
              nameController: nameController,
              cnpjController: cnpjController,
              cidadeController: cidadeController,
            ),
          ),
        ),
      );

      expect(find.byType(DadosBasicosTabWidget), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DadosBasicosTabWidget(
              isFiltersExpanded: false,
              onToggle: onToggle,
              nameController: nameController,
              cnpjController: cnpjController,
              cidadeController: cidadeController,
            ),
          ),
        ),
      );

      expect(find.byType(DadosBasicosTabWidget), findsOneWidget);
    });

    testWidgets('deve ter estrutura de layout correta', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DadosBasicosTabWidget(
              isFiltersExpanded: isFiltersExpanded,
              onToggle: onToggle,
              nameController: nameController,
              cnpjController: cnpjController,
              cidadeController: cidadeController,
            ),
          ),
        ),
      );

      final containerWidget = find.descendant(
        of: find.byType(DadosBasicosTabWidget),
        matching: find.byType(Container),
      );
      expect(containerWidget, findsOneWidget);

      final columnWidget = find.descendant(
        of: containerWidget,
        matching: find.byType(Column),
      );
      expect(columnWidget, findsOneWidget);
    });

    testWidgets('deve ser um StatefulWidget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DadosBasicosTabWidget(
              isFiltersExpanded: isFiltersExpanded,
              onToggle: onToggle,
              nameController: nameController,
              cnpjController: cnpjController,
              cidadeController: cidadeController,
            ),
          ),
        ),
      );

      final widget = tester.widget(find.byType(DadosBasicosTabWidget));
      expect(widget, isA<StatefulWidget>());
    });

    testWidgets('deve receber callback onToggle', (WidgetTester tester) async {
      bool wasToggled = false;
      onToggle = () {
        wasToggled = true;
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DadosBasicosTabWidget(
              isFiltersExpanded: isFiltersExpanded,
              onToggle: onToggle,
              nameController: nameController,
              cnpjController: cnpjController,
              cidadeController: cidadeController,
            ),
          ),
        ),
      );

      expect(find.byType(DadosBasicosTabWidget), findsOneWidget);
      expect(wasToggled, isFalse);
    });
  });
}
