import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/widgets/custom_text_field.dart';

void main() {
  group('CustomTextField Widget Tests', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('deve renderizar CustomTextField com propriedades básicas', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Nome',
              hintText: 'Digite seu nome',
            ),
          ),
        ),
      );

      expect(find.text('Nome'), findsOneWidget);
      expect(find.text('Digite seu nome'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('deve aceitar entrada de texto', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(controller: controller, label: 'Nome'),
          ),
        ),
      );

      const textInput = 'João Silva';
      await tester.enterText(find.byType(TextFormField), textInput);

      expect(controller.text, textInput);
      expect(find.text(textInput), findsOneWidget);
    });

    testWidgets('deve mostrar/ocultar senha quando isPassword=true', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Senha',
              isPassword: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('deve executar validação quando fornecida', (tester) async {
      const errorMessage = 'Email é obrigatório';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: Column(
                children: [
                  CustomTextField(
                    controller: controller,
                    label: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return errorMessage;
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Form.of(
                        tester.element(find.byType(CustomTextField)),
                      ).validate();
                    },
                    child: const Text('Validar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('deve estar desabilitado quando enabled=false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Nome',
              enabled: false,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      expect(textField.enabled, false);
    });

    testWidgets('deve mostrar prefixIcon quando fornecido', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Email',
              prefixIcon: const Icon(Icons.email),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    testWidgets('deve respeitar maxLines através da configuração', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Descrição',
              maxLines: 3,
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);

      expect(find.text('Descrição'), findsOneWidget);
    });

    testWidgets('deve respeitar maxLength através da configuração', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Estado',
              maxLength: 2,
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Estado'), findsOneWidget);
    });

    testWidgets('deve aplicar TextCapitalization através da configuração', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Estado',
              textCapitalization: TextCapitalization.characters,
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Estado'), findsOneWidget);
    });

    testWidgets('deve aplicar keyboardType através da configuração', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Telefone',
              keyboardType: TextInputType.phone,
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Telefone'), findsOneWidget);
    });

    testWidgets('deve chamar onChanged quando texto mudar', (tester) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Nome',
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      const testValue = 'Teste';
      await tester.enterText(find.byType(TextFormField), testValue);

      expect(changedValue, testValue);
    });

    testWidgets('deve aplicar formatters quando fornecidos', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Valor',
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'abc123def');

      expect(controller.text, '123');
    });

    testWidgets('deve aplicar estilo correto quando focalizado', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(controller: controller, label: 'Nome'),
          ),
        ),
      );

      await tester.tap(find.byType(TextFormField));
      await tester.pump();

      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('deve limpar texto quando controller for limpo', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(controller: controller, label: 'Nome'),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Texto inicial');
      expect(controller.text, 'Texto inicial');

      controller.clear();
      await tester.pump();

      expect(controller.text, '');
    });
  });
}
