import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/clients/presentation/screens/client_form_screen.dart';
import 'package:frontend/features/clients/presentation/controllers/clients_controller.dart';
import 'package:frontend/features/clients/domain/models/client.dart';
import 'package:frontend/features/clients/domain/usecases/get_clients_usecase.dart';
import 'package:frontend/features/clients/domain/usecases/get_client_by_id_usecase.dart';
import 'package:frontend/features/clients/domain/usecases/create_client_usecase.dart';
import 'package:frontend/features/clients/domain/usecases/update_client_usecase.dart';

class MockGetClientsUseCase extends Mock implements GetClientsUseCase {}

class MockGetClientByIdUseCase extends Mock implements GetClientByIdUseCase {}

class MockCreateClientUseCase extends Mock implements CreateClientUseCase {}

class MockUpdateClientUseCase extends Mock implements UpdateClientUseCase {}

void main() {
  late MockGetClientsUseCase mockGetClientsUseCase;
  late MockGetClientByIdUseCase mockGetClientByIdUseCase;
  late MockCreateClientUseCase mockCreateClientUseCase;
  late MockUpdateClientUseCase mockUpdateClientUseCase;

  setUp(() {
    mockGetClientsUseCase = MockGetClientsUseCase();
    mockGetClientByIdUseCase = MockGetClientByIdUseCase();
    mockCreateClientUseCase = MockCreateClientUseCase();
    mockUpdateClientUseCase = MockUpdateClientUseCase();

    Get.put<ClientsController>(
      ClientsController(
        getClientsUseCase: mockGetClientsUseCase,
        getClientByIdUseCase: mockGetClientByIdUseCase,
        createClientUseCase: mockCreateClientUseCase,
        updateClientUseCase: mockUpdateClientUseCase,
      ),
    );
  });

  tearDown(() {
    Get.reset();
  });

  final testClient = Client(
    id: 1,
    storeFrontName: 'Loja Teste',
    cnpj: '12.345.678/0001-99',
    companyName: 'Empresa Teste LTDA',
    status: ClientStatus.ativo,
    phone: '(11) 99999-9999',
    email: 'teste@empresa.com',
    contactPerson: 'João Silva',
    cep: '01000-000',
    street: 'Rua Teste',
    neighborhood: 'Centro',
    city: 'São Paulo',
    state: 'SP',
    number: '123',
  );

  Widget createTestWidget({int? clientId}) {
    return GetMaterialApp(home: ClientFormScreen(clientId: clientId));
  }

  group('ClientFormScreen Widget Tests', () {
    testWidgets('deve renderizar tela de criação de cliente', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ClientFormScreen), findsOneWidget);
      expect(find.byType(TabController), findsOneWidget);

      expect(find.text('Básico'), findsOneWidget);
      expect(find.text('Endereço'), findsOneWidget);
      expect(find.text('Contato'), findsOneWidget);
    });

    testWidgets('deve exibir campos da aba Básico', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Nome da Loja'), findsOneWidget);
      expect(find.text('CNPJ'), findsOneWidget);
      expect(find.text('Razão Social'), findsOneWidget);
      expect(find.text('Status'), findsOneWidget);
    });

    testWidgets('deve navegar entre abas', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Endereço'));
      await tester.pumpAndSettle();

      expect(find.text('CEP'), findsOneWidget);
      expect(find.text('Rua'), findsOneWidget);
      expect(find.text('Número'), findsOneWidget);
      expect(find.text('Bairro'), findsOneWidget);

      await tester.tap(find.text('Contato'));
      await tester.pumpAndSettle();

      expect(find.text('Telefone'), findsOneWidget);
      expect(find.text('E-mail'), findsOneWidget);
      expect(find.text('Pessoa de Contato'), findsOneWidget);
    });

    testWidgets('deve validar campos obrigatórios ao salvar', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final saveButton = find.text('Salvar');
      expect(saveButton, findsOneWidget);

      await tester.tap(saveButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text('Nome da loja é obrigatório'), findsWidgets);
    });

    testWidgets('deve carregar dados do cliente em modo edição', (
      tester,
    ) async {
      when(
        () => mockGetClientByIdUseCase.execute(1),
      ).thenAnswer((_) async => testClient);

      await tester.pumpWidget(createTestWidget(clientId: 1));
      await tester.pumpAndSettle();

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Loja Teste'), findsOneWidget);
      expect(find.text('12.345.678/0001-99'), findsOneWidget);
      verify(() => mockGetClientByIdUseCase.execute(1)).called(1);
    });

    testWidgets('deve criar novo cliente com sucesso', (tester) async {
      when(
        () => mockCreateClientUseCase.execute(any()),
      ).thenAnswer((_) async => testClient);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nome da Loja'),
        'Loja Teste',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'CNPJ'),
        '12.345.678/0001-99',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Razão Social'),
        'Empresa Teste LTDA',
      );

      await tester.tap(find.text('Endereço'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'CEP'),
        '01000-000',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Rua'),
        'Rua Teste',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Número'),
        '123',
      );

      await tester.tap(find.text('Contato'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Telefone'),
        '(11) 99999-9999',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'E-mail'),
        'teste@empresa.com',
      );

      await tester.tap(find.text('Salvar'), warnIfMissed: false);
      await tester.pumpAndSettle();

      verify(() => mockCreateClientUseCase.execute(any())).called(1);
    });

    testWidgets('deve atualizar cliente existente com sucesso', (tester) async {
      when(
        () => mockGetClientByIdUseCase.execute(1),
      ).thenAnswer((_) async => testClient);
      when(
        () => mockUpdateClientUseCase.execute(any()),
      ).thenAnswer((_) async => testClient);

      await tester.pumpWidget(createTestWidget(clientId: 1));
      await tester.pumpAndSettle();

      await tester.pump(const Duration(milliseconds: 500));

      final nomeField = find.widgetWithText(TextFormField, 'Loja Teste');
      await tester.enterText(nomeField, 'Loja Atualizada');

      await tester.tap(find.text('Salvar'), warnIfMissed: false);
      await tester.pumpAndSettle();

      verify(() => mockGetClientByIdUseCase.execute(1)).called(1);
      verify(() => mockUpdateClientUseCase.execute(any())).called(1);
    });

    testWidgets('deve mostrar loading durante operações', (tester) async {
      when(() => mockCreateClientUseCase.execute(any())).thenAnswer(
        (_) => Future.delayed(const Duration(seconds: 2), () => testClient),
      );

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nome da Loja').first,
        'Loja Teste',
      );

      await tester.tap(find.text('Salvar'), warnIfMissed: false);
      await tester.pump();

      expect(find.text('Salvando...'), findsOneWidget);
    });

    testWidgets('deve exibir erro quando falha ao salvar', (tester) async {
      when(
        () => mockCreateClientUseCase.execute(any()),
      ).thenThrow(Exception('Erro ao criar cliente'));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nome da Loja').first,
        'Loja Teste',
      );

      await tester.tap(find.text('Salvar'), warnIfMissed: false);
      await tester.pumpAndSettle();

      verify(() => mockCreateClientUseCase.execute(any())).called(1);
    });

    testWidgets('deve validar formato de CNPJ', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'CNPJ'),
        '123456789',
      );

      await tester.tap(find.widgetWithText(TextFormField, 'Nome da Loja'));
      await tester.pumpAndSettle();

      expect(find.text('CNPJ deve ter 14 dígitos'), findsOneWidget);
    });

    testWidgets('deve validar formato de email', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Contato'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'E-mail'),
        'email_invalido',
      );

      await tester.tap(find.widgetWithText(TextFormField, 'Telefone'));
      await tester.pumpAndSettle();

      expect(find.text('E-mail inválido'), findsOneWidget);
    });
  });
}
