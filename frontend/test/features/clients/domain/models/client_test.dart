import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/clients/domain/models/client.dart';

void main() {
  group('Client Model Tests', () {
    const testClient = Client(
      id: 1,
      storeFrontName: 'Loja Teste',
      cnpj: '12.345.678/0001-99',
      companyName: 'Empresa Teste LTDA',
      cep: '12345-678',
      street: 'Rua Teste',
      neighborhood: 'Bairro Teste',
      city: 'Cidade Teste',
      state: 'SP',
      number: '123',
      complement: 'Sala 1',
      status: ClientStatus.ativo,
      phone: '(11) 99999-9999',
      email: 'teste@empresa.com',
      contactPerson: 'João Silva',
      assignedUserId: 1,
      createdAt: null,
      updatedAt: null,
    );

    test('deve criar um Client com todos os campos obrigatórios', () {
      const client = Client(
        storeFrontName: 'Loja ABC',
        cnpj: '11.222.333/0001-81',
        companyName: 'ABC Comércio LTDA',
        cep: '01234-567',
        street: 'Rua ABC',
        neighborhood: 'Centro',
        city: 'São Paulo',
        state: 'SP',
        number: '100',
      );

      expect(client.storeFrontName, 'Loja ABC');
      expect(client.cnpj, '11.222.333/0001-81');
      expect(client.companyName, 'ABC Comércio LTDA');
      expect(client.status, ClientStatus.ativo);
    });

    test('deve criar Client a partir de JSON válido', () {
      final json = {
        'id': 1,
        'storeFrontName': 'Loja Teste',
        'cnpj': '12.345.678/0001-99',
        'companyName': 'Empresa Teste LTDA',
        'cep': '12345-678',
        'street': 'Rua Teste',
        'neighborhood': 'Bairro Teste',
        'city': 'Cidade Teste',
        'state': 'SP',
        'number': '123',
        'complement': 'Sala 1',
        'status': 'ativo',
        'phone': '(11) 99999-9999',
        'email': 'teste@empresa.com',
        'contactPerson': 'João Silva',
        'assignedUserId': 1,
        'createdAt': '2024-01-01T10:00:00.000Z',
        'updatedAt': '2024-01-01T10:00:00.000Z',
      };

      final client = Client.fromJson(json);

      expect(client.id, 1);
      expect(client.storeFrontName, 'Loja Teste');
      expect(client.cnpj, '12.345.678/0001-99');
      expect(client.companyName, 'Empresa Teste LTDA');
      expect(client.status, ClientStatus.ativo);
      expect(client.phone, '(11) 99999-9999');
      expect(client.email, 'teste@empresa.com');
      expect(client.contactPerson, 'João Silva');
    });

    test('deve converter Client para JSON corretamente', () {
      final json = testClient.toJson();

      expect(json['id'], 1);
      expect(json['storeFrontName'], 'Loja Teste');
      expect(json['cnpj'], '12.345.678/0001-99');
      expect(json['companyName'], 'Empresa Teste LTDA');
      expect(json['status'], 'Ativo');
      expect(json['phone'], '(11) 99999-9999');
      expect(json['email'], 'teste@empresa.com');
      expect(json['contactPerson'], 'João Silva');
    });

    test('deve tratar status diferentes corretamente', () {
      final jsonAtivo = {
        'id': 1,
        'storeFrontName': 'Loja',
        'cnpj': '12.345.678/0001-99',
        'companyName': 'Empresa',
        'cep': '12345-678',
        'street': 'Rua',
        'neighborhood': 'Bairro',
        'city': 'Cidade',
        'state': 'SP',
        'number': '123',
        'status': 'ativo',
      };

      final jsonInativo = {...jsonAtivo, 'status': 'inativo'};

      final jsonPendente = {...jsonAtivo, 'status': 'pendente'};

      expect(Client.fromJson(jsonAtivo).status, ClientStatus.ativo);
      expect(Client.fromJson(jsonInativo).status, ClientStatus.inativo);
      expect(Client.fromJson(jsonPendente).status, ClientStatus.pendente);
    });

    test('deve usar ClientStatus.ativo como padrão para status inválido', () {
      final json = {
        'id': 1,
        'storeFrontName': 'Loja',
        'cnpj': '12.345.678/0001-99',
        'companyName': 'Empresa',
        'cep': '12345-678',
        'street': 'Rua',
        'neighborhood': 'Bairro',
        'city': 'Cidade',
        'state': 'SP',
        'number': '123',
        'status': 'status_invalido',
      };

      final client = Client.fromJson(json);
      expect(client.status, ClientStatus.ativo);
    });

    test('deve tratar campos opcionais nulos', () {
      final json = {
        'id': 1,
        'storeFrontName': 'Loja',
        'cnpj': '12.345.678/0001-99',
        'companyName': 'Empresa',
        'cep': '12345-678',
        'street': 'Rua',
        'neighborhood': 'Bairro',
        'city': 'Cidade',
        'state': 'SP',
        'number': '123',
        'status': 'ativo',
        'complement': null,
        'phone': null,
        'email': null,
        'contactPerson': null,
        'assignedUserId': null,
        'createdAt': null,
        'updatedAt': null,
      };

      final client = Client.fromJson(json);

      expect(client.complement, null);
      expect(client.phone, null);
      expect(client.email, null);
      expect(client.contactPerson, null);
      expect(client.assignedUserId, null);
      expect(client.createdAt, null);
      expect(client.updatedAt, null);
    });

    test('deve implementar equality corretamente', () {
      const client1 = Client(
        id: 1,
        storeFrontName: 'Loja',
        cnpj: '12.345.678/0001-99',
        companyName: 'Empresa',
        cep: '12345-678',
        street: 'Rua',
        neighborhood: 'Bairro',
        city: 'Cidade',
        state: 'SP',
        number: '123',
      );

      const client2 = Client(
        id: 1,
        storeFrontName: 'Loja',
        cnpj: '12.345.678/0001-99',
        companyName: 'Empresa',
        cep: '12345-678',
        street: 'Rua',
        neighborhood: 'Bairro',
        city: 'Cidade',
        state: 'SP',
        number: '123',
      );

      const client3 = Client(
        id: 2,
        storeFrontName: 'Loja',
        cnpj: '12.345.678/0001-99',
        companyName: 'Empresa',
        cep: '12345-678',
        street: 'Rua',
        neighborhood: 'Bairro',
        city: 'Cidade',
        state: 'SP',
        number: '123',
      );

      expect(client1, equals(client2));
      expect(client1, isNot(equals(client3)));
      expect(client1.hashCode, client2.hashCode);
    });

    test('deve criar copyWith corretamente', () {
      const originalClient = Client(
        id: 1,
        storeFrontName: 'Loja Original',
        cnpj: '12.345.678/0001-99',
        companyName: 'Empresa Original',
        cep: '12345-678',
        street: 'Rua Original',
        neighborhood: 'Bairro',
        city: 'Cidade',
        state: 'SP',
        number: '123',
        status: ClientStatus.ativo,
      );

      final updatedClient = originalClient.copyWith(
        storeFrontName: 'Loja Atualizada',
        status: ClientStatus.inativo,
      );

      expect(updatedClient.storeFrontName, 'Loja Atualizada');
      expect(updatedClient.status, ClientStatus.inativo);
      expect(updatedClient.cnpj, originalClient.cnpj);
      expect(updatedClient.companyName, originalClient.companyName);
      expect(updatedClient.id, originalClient.id);
    });
  });
}
