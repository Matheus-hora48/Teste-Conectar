import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/clients/presentation/widgets/clients_section_header_widget.dart';

void main() {
  group('ClientsSectionHeaderWidget Tests', () {
    setUp(() {
      Get.testMode = true;
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('deve renderizar título e descrição corretamente', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ClientsSectionHeaderWidget())),
      );

      expect(find.text('Clientes'), findsOneWidget);
      expect(
        find.text('Selecione um usuário para editar suas informações'),
        findsOneWidget,
      );
    });

    testWidgets('deve renderizar botão Novo', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ClientsSectionHeaderWidget())),
      );

      expect(find.text('Novo'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('deve ter estilo correto no título', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ClientsSectionHeaderWidget())),
      );

      final titleWidget = tester.widget<Text>(find.text('Clientes'));
      expect(titleWidget.style?.fontSize, 20);
      expect(titleWidget.style?.fontWeight, FontWeight.w600);
      expect(titleWidget.style?.color, Colors.black87);
    });

    testWidgets('deve ter estilo correto na descrição', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ClientsSectionHeaderWidget())),
      );

      final descriptionWidget = tester.widget<Text>(
        find.text('Selecione um usuário para editar suas informações'),
      );
      expect(descriptionWidget.style?.fontSize, 14);
      expect(descriptionWidget.style?.color, Colors.grey[600]);
    });

    testWidgets('deve ter estilo correto no botão', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ClientsSectionHeaderWidget())),
      );

      final buttonWidget = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      final buttonStyle = buttonWidget.style;

      expect(buttonStyle?.backgroundColor?.resolve({}), Colors.white);
      expect(buttonStyle?.foregroundColor?.resolve({}), Colors.black87);
      expect(buttonStyle?.elevation?.resolve({}), 0);
    });

    testWidgets('deve ter layout correto', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ClientsSectionHeaderWidget())),
      );

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Column), findsAtLeastNWidgets(2));
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(SizedBox), findsNWidgets(2));
    });

    testWidgets('deve ter padding correto', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ClientsSectionHeaderWidget())),
      );

      final containerWidget = tester.widget<Container>(find.byType(Container));
      expect(containerWidget.padding, const EdgeInsets.all(16));
    });

    testWidgets('botão deve estar alinhado à direita', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ClientsSectionHeaderWidget())),
      );

      final columnWidget = tester.widget<Column>(find.byType(Column).first);
      expect(columnWidget.crossAxisAlignment, CrossAxisAlignment.end);
    });

    testWidgets('título e descrição devem estar alinhados à esquerda', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ClientsSectionHeaderWidget())),
      );

      final columns = find.byType(Column);
      final titleColumn = tester.widget<Column>(columns.at(1));
      expect(titleColumn.crossAxisAlignment, CrossAxisAlignment.start);
    });

    testWidgets('row deve ter espaçamento correto', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ClientsSectionHeaderWidget())),
      );

      final rowWidget = tester.widget<Row>(find.byType(Row));
      expect(rowWidget.mainAxisAlignment, MainAxisAlignment.spaceBetween);
    });
  });
}
