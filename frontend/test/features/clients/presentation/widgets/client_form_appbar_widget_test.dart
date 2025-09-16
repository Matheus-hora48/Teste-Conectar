import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/clients/presentation/widgets/client_form_appbar_widget.dart';

void main() {
  group('ClientFormAppBarWidget Tests', () {
    late TabController tabController;

    setUp(() {
      Get.testMode = true;
    });

    tearDown(() {
      Get.reset();
    });

    Widget createTestWidget({
      required String title,
      required VoidCallback onSave,
      bool isLoading = false,
    }) {
      return GetMaterialApp(
        home: DefaultTabController(
          length: 3,
          child: Builder(
            builder: (context) {
              tabController = DefaultTabController.of(context);
              return Scaffold(
                appBar: ClientFormAppBarWidget(
                  title: title,
                  tabController: tabController,
                  onSave: onSave,
                  isLoading: isLoading,
                ),
                body: const TabBarView(
                  children: [
                    Center(child: Text('Tab 1')),
                    Center(child: Text('Tab 2')),
                    Center(child: Text('Tab 3')),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }

    testWidgets('deve renderizar AppBar com título correto', (tester) async {
      const title = 'Novo Cliente';

      await tester.pumpWidget(createTestWidget(title: title, onSave: () {}));

      expect(find.text(title), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('deve mostrar botão de voltar', (tester) async {
      await tester.pumpWidget(
        createTestWidget(title: 'Novo Cliente', onSave: () {}),
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('deve mostrar botão de voltar funcional', (tester) async {
      await tester.pumpWidget(
        createTestWidget(title: 'Novo Cliente', onSave: () {}),
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('deve mostrar botão de salvar com texto correto', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(title: 'Novo Cliente', onSave: () {}),
      );

      expect(find.text('Salvar'), findsOneWidget);
      expect(find.byIcon(Icons.save), findsOneWidget);
    });

    testWidgets(
      'deve executar callback onSave quando botão salvar for pressionado',
      (tester) async {
        bool saveCalled = false;

        await tester.pumpWidget(
          createTestWidget(
            title: 'Novo Cliente',
            onSave: () {
              saveCalled = true;
            },
          ),
        );

        await tester.tap(find.text('Salvar'));
        await tester.pump();

        expect(saveCalled, true);
      },
    );

    testWidgets('deve mostrar estado de loading quando isLoading=true', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(title: 'Novo Cliente', onSave: () {}, isLoading: true),
      );

      expect(find.text('Salvando...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('deve desabilitar botão quando isLoading=true', (tester) async {
      bool saveCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          title: 'Novo Cliente',
          onSave: () {
            saveCalled = true;
          },
          isLoading: true,
        ),
      );

      await tester.tap(find.text('Salvando...'));
      await tester.pump();

      expect(saveCalled, false);
    });

    testWidgets('deve mostrar TabBar com 3 abas corretas', (tester) async {
      await tester.pumpWidget(
        createTestWidget(title: 'Novo Cliente', onSave: () {}),
      );

      expect(find.byType(TabBar), findsOneWidget);
      expect(find.text('Dados Cadastrais'), findsOneWidget);
      expect(find.text('Informações Internas'), findsOneWidget);
      expect(find.text('Usuários Atribuídos'), findsOneWidget);
    });

    testWidgets('deve mostrar ícones nas abas', (tester) async {
      await tester.pumpWidget(
        createTestWidget(title: 'Novo Cliente', onSave: () {}),
      );

      expect(find.byIcon(Icons.business), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
      expect(find.byIcon(Icons.people_outline), findsOneWidget);
    });

    testWidgets('deve alternar entre abas quando clicadas', (tester) async {
      await tester.pumpWidget(
        createTestWidget(title: 'Novo Cliente', onSave: () {}),
      );

      expect(find.text('Tab 1'), findsOneWidget);

      await tester.tap(find.text('Informações Internas'));
      await tester.pumpAndSettle();

      expect(find.text('Tab 2'), findsOneWidget);

      await tester.tap(find.text('Usuários Atribuídos'));
      await tester.pumpAndSettle();

      expect(find.text('Tab 3'), findsOneWidget);
    });

    testWidgets('deve ter preferredSize correto', (tester) async {
      await tester.pumpWidget(
        createTestWidget(title: 'Novo Cliente', onSave: () {}),
      );

      final appBar = tester.widget<ClientFormAppBarWidget>(
        find.byType(ClientFormAppBarWidget),
      );

      expect(
        appBar.preferredSize,
        const Size.fromHeight(kToolbarHeight + kTextTabBarHeight),
      );
    });

    testWidgets('deve aplicar cores corretas do tema', (tester) async {
      await tester.pumpWidget(
        createTestWidget(title: 'Novo Cliente', onSave: () {}),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));

      expect(appBar.backgroundColor, Colors.white);
      expect(appBar.elevation, 0);
      expect(appBar.scrolledUnderElevation, 0);
    });

    testWidgets('deve funcionar com títulos diferentes', (tester) async {
      const titles = ['Novo Cliente', 'Editar Cliente', 'Visualizar Cliente'];

      for (final title in titles) {
        await tester.pumpWidget(createTestWidget(title: title, onSave: () {}));

        expect(find.text(title), findsOneWidget);
        await tester.pump();
      }
    });
  });
}
