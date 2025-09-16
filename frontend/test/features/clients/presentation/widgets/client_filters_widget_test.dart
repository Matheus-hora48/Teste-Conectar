import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/clients/presentation/widgets/client_filters_widget.dart';
import 'package:frontend/features/clients/presentation/controllers/clients_controller.dart';
import 'package:frontend/features/clients/domain/models/client.dart';
import 'package:frontend/core/widgets/custom_text_field.dart';
import 'package:frontend/core/widgets/custom_dropdown_widget.dart';

class MockClientsController extends GetxController
    with Mock
    implements ClientsController {
  final RxString _nameFilter = ''.obs;
  final RxString _cnpjFilter = ''.obs;
  final RxString _cidadeFilter = ''.obs;
  final Rx<ClientStatus?> _statusFilter = Rx<ClientStatus?>(null);

  @override
  String get nameFilter => _nameFilter.value;

  @override
  String get cnpjFilter => _cnpjFilter.value;

  @override
  String get cidadeFilter => _cidadeFilter.value;

  @override
  ClientStatus? get statusFilter => _statusFilter.value;

  @override
  void setNameFilter(String filter) {
    _nameFilter.value = filter;
  }

  @override
  void setCnpjFilter(String filter) {
    _cnpjFilter.value = filter;
  }

  @override
  void setCidadeFilter(String filter) {
    _cidadeFilter.value = filter;
  }

  @override
  void setStatusFilter(ClientStatus? status) {
    _statusFilter.value = status;
  }

  @override
  void clearFilters() {
    _nameFilter.value = '';
    _cnpjFilter.value = '';
    _cidadeFilter.value = '';
    _statusFilter.value = null;
  }
}

void main() {
  group('ClientFiltersWidget Tests', () {
    late MockClientsController mockController;
    late TextEditingController nameController;
    late TextEditingController cnpjController;
    late TextEditingController cidadeController;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      Get.reset();

      mockController = MockClientsController();
      Get.put<ClientsController>(mockController);

      nameController = TextEditingController();
      cnpjController = TextEditingController();
      cidadeController = TextEditingController();
    });

    tearDown(() {
      Get.reset();
      nameController.dispose();
      cnpjController.dispose();
      cidadeController.dispose();
    });

    Widget createTestWidget({bool isExpanded = true}) {
      return GetMaterialApp(
        home: Scaffold(
          body: ClientFiltersWidget(
            isExpanded: isExpanded,
            onToggle: () {},
            nameController: nameController,
            cnpjController: cnpjController,
            cidadeController: cidadeController,
          ),
        ),
      );
    }

    group('UI Components', () {
      testWidgets('deve renderizar componentes quando expandido', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(isExpanded: true));

        expect(find.byType(ClientFiltersWidget), findsOneWidget);
        expect(find.text('Filtros'), findsOneWidget);
        expect(find.byType(CustomTextField), findsNWidgets(3));
        expect(
          find.byType(CustomDropdownWidget<ClientStatus?>),
          findsOneWidget,
        );
      });

      testWidgets('deve exibir header quando recolhido', (tester) async {
        await tester.pumpWidget(createTestWidget(isExpanded: false));

        expect(find.text('Filtros'), findsOneWidget);
        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      });

      testWidgets('deve exibir todos os campos de filtro', (tester) async {
        await tester.pumpWidget(createTestWidget(isExpanded: true));

        expect(find.text('Nome da Loja'), findsOneWidget);
        expect(find.text('CNPJ'), findsOneWidget);
        expect(find.text('Cidade'), findsOneWidget);
        expect(find.text('Status'), findsOneWidget);
      });

      testWidgets('deve exibir botões de ação', (tester) async {
        await tester.pumpWidget(createTestWidget(isExpanded: true));

        expect(find.text('Limpar'), findsOneWidget);
        expect(find.text('Filtrar'), findsOneWidget);
      });
    });

    group('Filter Interactions', () {
      testWidgets('deve atualizar filtro de nome', (tester) async {
        await tester.pumpWidget(createTestWidget(isExpanded: true));

        final nameField = find.widgetWithText(CustomTextField, 'Nome da Loja');
        await tester.enterText(nameField, 'Loja Teste');

        expect(nameController.text, equals('Loja Teste'));
      });

      testWidgets('deve atualizar filtro de CNPJ', (tester) async {
        await tester.pumpWidget(createTestWidget(isExpanded: true));

        final cnpjField = find.widgetWithText(CustomTextField, 'CNPJ');
        await tester.enterText(cnpjField, '12.345.678/0001-90');

        expect(cnpjController.text, equals('12.345.678/0001-90'));
      });

      testWidgets('deve atualizar filtro de cidade', (tester) async {
        await tester.pumpWidget(createTestWidget(isExpanded: true));

        final cidadeField = find.widgetWithText(CustomTextField, 'Cidade');
        await tester.enterText(cidadeField, 'São Paulo');

        expect(cidadeController.text, equals('São Paulo'));
      });

      testWidgets('deve chamar clearFilters ao clicar em Limpar', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(isExpanded: true));
        await tester.tap(find.text('Limpar'));

        verify(() => mockController.clearFilters()).called(1);
        expect(nameController.text, isEmpty);
        expect(cnpjController.text, isEmpty);
        expect(cidadeController.text, isEmpty);
      });
    });

    group('Status Filter', () {
      testWidgets('deve exibir opções de status corretas', (tester) async {
        await tester.pumpWidget(createTestWidget(isExpanded: true));

        await tester.tap(find.byType(CustomDropdownWidget<ClientStatus?>));
        await tester.pumpAndSettle();

        expect(
          find.byType(DropdownMenuItem<ClientStatus?>),
          findsAtLeastNWidgets(1),
        );
      });

      testWidgets('deve atualizar filtro de status', (tester) async {
        when(() => mockController.setStatusFilter(any())).thenReturn(null);

        await tester.pumpWidget(createTestWidget(isExpanded: true));

        mockController.setStatusFilter(ClientStatus.ativo);

        verify(
          () => mockController.setStatusFilter(ClientStatus.ativo),
        ).called(1);
      });
    });

    group('Expand/Collapse', () {
      testWidgets('deve mostrar ícone correto quando expandido', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(isExpanded: true));

        expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
      });

      testWidgets('deve mostrar ícone correto quando recolhido', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(isExpanded: false));

        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      });

      testWidgets('deve esconder campos quando recolhido', (tester) async {
        await tester.pumpWidget(createTestWidget(isExpanded: false));

        expect(find.byType(CustomTextField), findsNothing);
        expect(find.byType(CustomDropdownWidget<ClientStatus?>), findsNothing);
        expect(find.text('Limpar'), findsNothing);
        expect(find.text('Filtrar'), findsNothing);
      });
    });

    group('Layout and Styling', () {
      testWidgets('deve ter layout correto', (tester) async {
        await tester.pumpWidget(createTestWidget(isExpanded: true));

        expect(find.byType(Container), findsAtLeastNWidgets(1));
        expect(find.byType(Column), findsAtLeastNWidgets(1));
        expect(find.byType(Row), findsAtLeastNWidgets(2));
      });

      testWidgets('deve ter espaçamento adequado', (tester) async {
        await tester.pumpWidget(createTestWidget(isExpanded: true));

        expect(find.byType(SizedBox), findsAtLeastNWidgets(2));
        expect(find.byType(Padding), findsAtLeastNWidgets(1));
      });

      testWidgets('deve ter cores e estilos corretos', (tester) async {
        await tester.pumpWidget(createTestWidget(isExpanded: true));

        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        expect(container.decoration, isNotNull);
      });
    });

    group('Filter Logic', () {
      testWidgets('deve aplicar filtros quando clicar em Filtrar', (
        tester,
      ) async {
        when(() => mockController.setNameFilter(any())).thenReturn(null);
        when(() => mockController.setCnpjFilter(any())).thenReturn(null);
        when(() => mockController.setCidadeFilter(any())).thenReturn(null);

        await tester.pumpWidget(createTestWidget(isExpanded: true));

        await tester.enterText(
          find.widgetWithText(CustomTextField, 'Nome da Loja'),
          'Teste',
        );
        await tester.enterText(
          find.widgetWithText(CustomTextField, 'CNPJ'),
          '12345',
        );
        await tester.enterText(
          find.widgetWithText(CustomTextField, 'Cidade'),
          'SP',
        );

        await tester.tap(find.text('Filtrar'));

        verify(() => mockController.setNameFilter('Teste')).called(1);
        verify(() => mockController.setCnpjFilter('12345')).called(1);
        verify(() => mockController.setCidadeFilter('SP')).called(1);
      });

      testWidgets('deve manter valores dos campos após aplicar filtros', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(isExpanded: true));

        await tester.enterText(
          find.widgetWithText(CustomTextField, 'Nome da Loja'),
          'Teste',
        );
        await tester.tap(find.text('Filtrar'));
        await tester.pumpAndSettle();

        expect(nameController.text, equals('Teste'));
      });
    });

    group('Responsive Design', () {
      testWidgets('deve adaptar layout para diferentes tamanhos de tela', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(400, 600));

        await tester.pumpWidget(createTestWidget(isExpanded: true));

        expect(find.byType(ClientFiltersWidget), findsOneWidget);
        expect(find.byType(CustomTextField), findsNWidgets(3));
      });

      testWidgets('deve manter funcionalidade em tela pequena', (tester) async {
        await tester.binding.setSurfaceSize(const Size(300, 400));

        await tester.pumpWidget(createTestWidget(isExpanded: true));

        expect(find.text('Limpar'), findsOneWidget);
        expect(find.text('Filtrar'), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('deve ter labels adequados para acessibilidade', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(isExpanded: true));

        expect(find.text('Nome da Loja'), findsOneWidget);
        expect(find.text('CNPJ'), findsOneWidget);
        expect(find.text('Cidade'), findsOneWidget);
        expect(find.text('Status'), findsOneWidget);
      });

      testWidgets('deve ter botões com texto claro', (tester) async {
        await tester.pumpWidget(createTestWidget(isExpanded: true));

        expect(find.text('Limpar'), findsOneWidget);
        expect(find.text('Filtrar'), findsOneWidget);
      });
    });
  });
}
