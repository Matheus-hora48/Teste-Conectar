import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/utils/validators.dart';

void main() {
  group('Validators Tests', () {
    group('email', () {
      test('deve retornar null para email válido', () {
        expect(Validators.email('teste@email.com'), null);
        expect(Validators.email('user.name@domain.co.uk'), null);
        expect(Validators.email('test123@test123.com'), null);
      });

      test('deve retornar erro para email inválido', () {
        expect(Validators.email('email_inválido'), 'E-mail inválido');
        expect(Validators.email('teste@'), 'E-mail inválido');
        expect(Validators.email('@domain.com'), 'E-mail inválido');
        expect(
          Validators.email('teste@domain'),
          'E-mail inválido',
        ); // sem TLD válido
      });

      test('deve retornar erro para email vazio', () {
        expect(Validators.email(''), 'E-mail é obrigatório');
        expect(Validators.email('   '), 'E-mail é obrigatório');
      });

      test('deve retornar erro para email null', () {
        expect(Validators.email(null), 'E-mail é obrigatório');
      });
    });

    group('password', () {
      test('deve retornar null para senha válida', () {
        expect(Validators.password('12345678'), null);
        expect(Validators.password('senha_forte_123'), null);
        expect(Validators.password('Abc123456'), null);
      });

      test('deve retornar erro para senha muito curta', () {
        expect(
          Validators.password('123'),
          'Senha deve ter pelo menos 6 caracteres',
        );
        expect(
          Validators.password('ab'),
          'Senha deve ter pelo menos 6 caracteres',
        );
        expect(Validators.password(''), 'Senha é obrigatória');
      });

      test('deve retornar erro para senha vazia', () {
        expect(Validators.password(''), 'Senha é obrigatória');
      });

      test('deve retornar erro para senha null', () {
        expect(Validators.password(null), 'Senha é obrigatória');
      });
    });

    group('required', () {
      test('deve retornar null para valor válido', () {
        expect(Validators.required('texto'), null);
        expect(Validators.required('123'), null);
        expect(Validators.required('a'), null);
      });

      test('deve retornar erro para valor vazio', () {
        expect(Validators.required(''), 'Este campo é obrigatório');
        expect(Validators.required('   '), 'Este campo é obrigatório');
      });

      test('deve retornar erro para valor null', () {
        expect(Validators.required(null), 'Este campo é obrigatório');
      });
    });

    group('cnpj', () {
      test('deve retornar null para CNPJ válido', () {
        expect(Validators.cnpj('11.222.333/0001-81'), null);
        expect(Validators.cnpj('11222333000181'), null);
      });

      test('deve retornar erro para CNPJ com formato incorreto', () {
        expect(Validators.cnpj('12345'), 'CNPJ deve ter 14 dígitos');
        expect(Validators.cnpj('111.222.333/0001'), 'CNPJ deve ter 14 dígitos');
      });

      test('deve retornar erro para CNPJ vazio', () {
        expect(Validators.cnpj(''), 'CNPJ é obrigatório');
      });

      test('deve retornar erro para CNPJ null', () {
        expect(Validators.cnpj(null), 'CNPJ é obrigatório');
      });
    });

    group('phone', () {
      test('deve retornar null para telefone válido', () {
        expect(Validators.phone('(11) 99999-9999'), null);
        expect(Validators.phone('11999999999'), null);
        expect(Validators.phone('(21) 8888-8888'), null);
      });

      test('deve retornar erro para telefone com formato incorreto', () {
        expect(Validators.phone('123'), 'Telefone inválido');
        expect(Validators.phone('(11) 9999'), 'Telefone inválido');
      });

      test('deve retornar erro para telefone vazio', () {
        expect(Validators.phone(''), 'Telefone é obrigatório');
      });

      test('deve retornar erro para telefone null', () {
        expect(Validators.phone(null), 'Telefone é obrigatório');
      });
    });

    group('name', () {
      test('deve retornar null para nome válido', () {
        expect(Validators.name('João Silva'), null);
        expect(Validators.name('Maria'), null);
        expect(Validators.name('José Carlos Santos'), null);
      });

      test('deve retornar erro para nome muito curto', () {
        expect(Validators.name('J'), 'Nome deve ter pelo menos 2 caracteres');
        expect(Validators.name(''), 'Nome é obrigatório');
      });

      test('deve retornar erro para nome vazio', () {
        expect(Validators.name(''), 'Nome é obrigatório');
        expect(Validators.name('   '), 'Nome é obrigatório');
      });

      test('deve retornar erro para nome null', () {
        expect(Validators.name(null), 'Nome é obrigatório');
      });
    });
  });
}
