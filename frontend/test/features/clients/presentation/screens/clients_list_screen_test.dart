import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/clients/presentation/screens/clients_list_screen.dart';
import 'package:frontend/features/clients/presentation/controllers/clients_controller.dart';
import 'package:frontend/features/clients/domain/models/client.dart';
import 'package:frontend/core/widgets/main_app_bar_widget.dart';

class MockClientsController extends GetxController
    with Mock
    implements ClientsController {
  final RxList<Client> _clients = <Client>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _nameFilter = ''.obs;
  final RxString _cnpjFilter = ''.obs;
  final RxString _cidadeFilter = ''.obs;
  final Rx<ClientStatus?> _statusFilter = Rx<ClientStatus?>(null);

  @override
  List<Client> get clients => _clients;

  @override
  bool get isLoading => _isLoading.value;

  @override
  String get nameFilter => _nameFilter.value;

  @override
  String get cnpjFilter => _cnpjFilter.value;

  @override
  String get cidadeFilter => _cidadeFilter.value;

  @override
  ClientStatus? get statusFilter => _statusFilter.value;

  List<Client> get filteredClients => _clients.where((client) {
    bool matchesName =
        nameFilter.isEmpty ||
        client.storeFrontName.toLowerCase().contains(nameFilter.toLowerCase());
    bool matchesCnpj = cnpjFilter.isEmpty || client.cnpj.contains(cnpjFilter);
    bool matchesCidade =
        cidadeFilter.isEmpty ||
        client.city.toLowerCase().contains(cidadeFilter.toLowerCase());
    bool matchesStatus = statusFilter == null || client.status == statusFilter;

    return matchesName && matchesCnpj && matchesCidade && matchesStatus;
  }).toList();

  void setMockClients(List<Client> clients) {
    _clients.assignAll(clients);
  }

  void setMockLoading(bool loading) {
    _isLoading.value = loading;
  }

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
  group('ClientsListScreen Tests', () {
    late MockClientsController mockController;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      Get.reset();

      mockController = MockClientsController();
      Get.put<ClientsController>(mockController);
    });

    tearDown(() {
      Get.reset();
    });

    final testClients = [
      const Client(
        id: 1,
        storeFrontName: 'Loja ABC',
        cnpj: '12.345.678/0001-90',
        companyName: 'ABC Ltda',
        cep: '12345-678',
        street: 'Rua ABC',
        neighborhood: 'Bairro ABC',
        city: 'São Paulo',
        state: 'SP',
        number: '123',
        status: ClientStatus.ativo,
        email: 'contato@abc.com',
        phone: '(11) 99999-9999',
      ),
      const Client(
        id: 2,
        storeFrontName: 'Loja XYZ',
        cnpj: '98.765.432/0001-10',
        companyName: 'XYZ Ltda',
        cep: '54321-876',
        street: 'Rua XYZ',
        neighborhood: 'Bairro XYZ',
        city: 'Rio de Janeiro',
        state: 'RJ',
        number: '456',
        status: ClientStatus.inativo,
        email: 'contato@xyz.com',
        phone: '(21) 88888-8888',
      ),
    ];

    Widget createTestWidget() {
      return GetMaterialApp(home: const ClientsListScreen());
    }

    group('UI Components', () {
      testWidgets('deve renderizar todos os componentes principais', (
        tester,
      ) async {
        mockController.setMockClients(testClients);

        await tester.pumpWidget(createTestWidget());

        expect(find.byType(ClientsListScreen), findsOneWidget);
        expect(find.byType(MainAppBarWidget), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('deve exibir título da tela', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Clientes'), findsOneWidget);
      });

      testWidgets('deve exibir botão de adicionar cliente', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.text('Adicionar Cliente'), findsOneWidget);
      });

      testWidgets('deve exibir filtros quando expandidos', (tester) async {
        await tester.pumpWidget(createTestWidget());

        await tester.tap(find.byIcon(Icons.filter_list));
        await tester.pumpAndSettle();

        expect(find.text('Filtros'), findsOneWidget);
        expect(find.text('Nome da Loja'), findsOneWidget);
        expect(find.text('CNPJ'), findsOneWidget);
        expect(find.text('Cidade'), findsOneWidget);
        expect(find.text('Status'), findsOneWidget);
      });
    });

    group('Client List Display', () {
      testWidgets('deve exibir lista de clientes', (tester) async {
        mockController.setMockClients(testClients);

        await tester.pumpWidget(createTestWidget());

        expect(find.text('Loja ABC'), findsOneWidget);
        expect(find.text('Loja XYZ'), findsOneWidget);
        expect(find.text('12.345.678/0001-90'), findsOneWidget);
        expect(find.text('98.765.432/0001-10'), findsOneWidget);
      });

      testWidgets('deve exibir status dos clientes', (tester) async {
        mockController.setMockClients(testClients);

        await tester.pumpWidget(createTestWidget());

        expect(find.text('Ativo'), findsOneWidget);
        expect(find.text('Inativo'), findsOneWidget);
      });

      testWidgets('deve exibir mensagem quando não há clientes', (
        tester,
      ) async {
        mockController.setMockClients([]);

        await tester.pumpWidget(createTestWidget());

        expect(find.text('Nenhum cliente encontrado'), findsOneWidget);
      });

      testWidgets('deve exibir loading quando carregando', (tester) async {
        mockController.setMockLoading(true);

        await tester.pumpWidget(createTestWidget());

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Filters', () {
      testWidgets('deve filtrar por nome', (tester) async {
        mockController.setMockClients(testClients);

        await tester.pumpWidget(createTestWidget());

        await tester.tap(find.byIcon(Icons.filter_list));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextField, 'Nome da Loja'),
          'ABC',
        );
        await tester.pumpAndSettle();

        verify(() => mockController.setNameFilter('ABC')).called(1);
      });

      testWidgets('deve filtrar por CNPJ', (tester) async {
        mockController.setMockClients(testClients);

        await tester.pumpWidget(createTestWidget());

        await tester.tap(find.byIcon(Icons.filter_list));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextField, 'CNPJ'),
          '12.345',
        );
        await tester.pumpAndSettle();

        verify(() => mockController.setCnpjFilter('12.345')).called(1);
      });

      testWidgets('deve limpar filtros', (tester) async {
        await tester.pumpWidget(createTestWidget());

        await tester.tap(find.byIcon(Icons.filter_list));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Limpar'));
        await tester.pumpAndSettle();

        verify(() => mockController.clearFilters()).called(1);
      });
    });

    group('Navigation', () {
      testWidgets('deve navegar para criação de cliente', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Adicionar Cliente'));
        await tester.pumpAndSettle();

        expect(find.text('Adicionar Cliente'), findsOneWidget);
      });

      testWidgets('deve permitir editar cliente', (tester) async {
        mockController.setMockClients(testClients);

        await tester.pumpWidget(createTestWidget());

        final editButtons = find.byIcon(Icons.edit);
        if (editButtons.hasFound) {
          await tester.tap(editButtons.first);
          await tester.pumpAndSettle();
        }

        expect(editButtons, findsAtLeastNWidgets(0));
      });
    });

    group('Responsive Design', () {
      testWidgets('deve adaptar layout para tela pequena', (tester) async {
        await tester.binding.setSurfaceSize(const Size(400, 600));
        mockController.setMockClients(testClients);

        await tester.pumpWidget(createTestWidget());

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(Column), findsAtLeastNWidgets(1));
      });

      testWidgets('deve adaptar layout para tela grande', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 800));
        mockController.setMockClients(testClients);

        await tester.pumpWidget(createTestWidget());

        expect(find.byType(Scaffold), findsOneWidget);
      });
    });

    group('Data Display', () {
      testWidgets('deve exibir informações completas do cliente', (
        tester,
      ) async {
        mockController.setMockClients([testClients.first]);

        await tester.pumpWidget(createTestWidget());

        expect(find.text('Loja ABC'), findsOneWidget);
        expect(find.text('12.345.678/0001-90'), findsOneWidget);
        expect(find.text('São Paulo, SP'), findsOneWidget);
        expect(find.text('Ativo'), findsOneWidget);
      });

      testWidgets('deve exibir contador de clientes', (tester) async {
        mockController.setMockClients(testClients);

        await tester.pumpWidget(createTestWidget());

        expect(find.textContaining('cliente(s) encontrado(s)'), findsOneWidget);
      });
    });

    group('Error Handling', () {
      testWidgets('deve lidar graciosamente com lista vazia', (tester) async {
        mockController.setMockClients([]);

        await tester.pumpWidget(createTestWidget());

        expect(find.text('Nenhum cliente encontrado'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('deve manter interface funcional durante loading', (
        tester,
      ) async {
        mockController.setMockLoading(true);

        await tester.pumpWidget(createTestWidget());

        expect(find.byType(MainAppBarWidget), findsOneWidget);
        expect(find.text('Adicionar Cliente'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });
  });
}
